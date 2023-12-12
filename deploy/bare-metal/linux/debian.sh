#!/usr/bin/env bash

root_path=$(pwd)

env_name=${1:-defaults}

source_path=${2:-$root_path/deploy/config/$env_name.env}

install_packages=${3:-}

install_venv=${4:-}

cmd_name='tpl'
var_prefix='TPL'
system_packages='build-essential,python3,python3-dev,python3-pip,python3-venv'

source 'config.txt'

system_packages=$(echo "$system_packages" | tr ',' ' ')

var_env_file="${var_prefix}_ENV_FILE"
var_secret_key="${var_prefix}_SECRET_KEY"
var_salt="${var_prefix}_SALT"

# shellcheck source=deploy/config/defaults.env
source "$source_path"

if [ "$install_packages" == "" ]; then
    read -rp "Do you want to install the required system packages for this project? [y/n] " install_packages
fi

install_packages=$(echo "$install_packages" | tr '[:upper:]' '[:lower:]')

case "$install_packages" in
    1|t|true|y|yes|yeah|yep|sure)
        install_packages="1"
        ;;
    *)
        ;;
esac

if [ "$install_packages" == "1" ]; then
    echo "Installing system packages..."
    sudo apt update
    # shellcheck disable=SC2086
    sudo apt-get -y --ignore-missing install $system_packages
fi

if [ "$install_venv" == "" ]; then
    echo ""
    read -rp "Do you want to install the Python virtual environment and install pip dependencies? [y/n] " install_venv
fi

install_venv=$(echo "$install_venv" | tr '[:upper:]' '[:lower:]')

case "$install_venv" in
    1|t|true|y|yes|yeah|yep|sure)
        install_venv="1"
        ;;
    *)
        ;;
esac

if [ "$install_venv" == "1" ]; then
    echo ""
    echo "Installing Python virtual environment and pip dependencies..."
    rm -fr venv
    python3 -m venv venv
    source venv/bin/activate
    pip install -e .
fi

confirmed="1"

if [ -f "${!var_env_file}" ]; then
  confirmed="0"
  echo ""
  read -rp "Would you like to overwrite the existing settings file at ${!var_env_file}? [y/n] " overwrite
  overwrite=$(echo "$overwrite" | tr '[:upper:]' '[:lower:]')
  case "$overwrite" in
      1|t|true|y|yes|yeah|yep|sure)
          confirmed="1"
          ;;
      *)
          ;;
  esac
fi

if ! [ -f "${!var_env_file}" ] || [ "$confirmed" == "1" ]; then
  username=$(whoami)
  group_name=$(id -gn)
  env_directory="$(dirname "${!var_env_file}")"

  echo ""
  echo "Creating configuration file at ${!var_env_file}"

  sudo mkdir -p "$env_directory"
  sudo cp "$source_path" "${!var_env_file}"

  echo ""
  echo "Setting configuration file ownership to $username:$group_name"
  sudo chown -R "$username:$group_name" "$env_directory"

  IFS= read -r -d '' "$var_secret_key" <<< "$(echo $RANDOM | sha256sum | head -c 64; echo;)"
  export var_secret_key
  IFS= read -r -d '' "$var_salt" <<< "$("$cmd_name" gen_salt -r)"

  {
    echo ""
    echo -n "$var_salt=${!var_salt}"
    echo -n "$var_secret_key=${!var_secret_key}"
  } | sudo tee -a "${!var_env_file}"
fi
