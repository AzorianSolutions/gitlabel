# GitLabel

This project provides a tool for copying the labels from one GitHub repository to another.

|                                                                                                           Main Branch                                                                                                           |                                                                                                           Dev Branch                                                                                                           |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| [![CodeQL](https://github.com/AzorianSolutions/gitlabel/actions/workflows/codeql-analysis.yml/badge.svg?branch=main)](https://github.com/AzorianSolutions/gitlabel/actions/workflows/codeql-analysis.yml) | [![CodeQL](https://github.com/AzorianSolutions/gitlabel/actions/workflows/codeql-analysis.yml/badge.svg?branch=dev)](https://github.com/AzorianSolutions/gitlabel/actions/workflows/codeql-analysis.yml)

## TL;DR - Linux

To get started quickly with a simple deployment, execute the following `bash` / `shell` commands on a Debian Linux
based system with `git` installed:

```
git clone https://github.com/AzorianSolutions/gitlabel.git
cd gitlabel
./deploy/bare-metal/linux/debian.sh
source venv/bin/activate
gitlabel run
```

## TL;DR - Windows

Start with checking out the project's official repository using git. The official repository can be
cloned from `https://github.com/AzorianSolutions/gitlabel.git`.

```
cd C:/Path/To/Project/Root
python3 -m venv venv
venv\Scripts\activate
pip install -e .
copy deploy\config\defaults.env deploy\config\production.env
```

Edit the default settings as needed in `deploy\config\production.env`.

Then, run the following commands each time you want to activate the project for use:

```
cd C:/Path/To/Project/Root
venv\Scripts\activate
for /F %A in (deploy\config\production.env) do SET %A
gitlabel run
```

## Project Documentation

### Configuration

GitLabel is configured via environment variables. Please refer to the default values in [deploy/config/defaults.env](./deploy/config/defaults.env) for a list of the
environment variables that can be set.

To see the concrete implementation of the settings associated with the environment variables, please see the
[src/app/config.py](./src/app/config.py) file.

### Contributing

This project is not currently accepting outside contributions. If you're interested in participating in the project,
please contact the project owner.

## [Security Policy](./.github/SECURITY.md)

Please see our [Security Policy](./.github/SECURITY.md).

## [Support Policy](./.github/SUPPORT.md)

Please see our [Support Policy](./.github/SUPPORT.md).

## [Code of Conduct](./.github/CODE_OF_CONDUCT.md)

Please see our [Code of Conduct](./.github/CODE_OF_CONDUCT.md).

## [License](./LICENSE)

This project is released under the MIT license. For additional information, [see the full license](./LICENSE).
