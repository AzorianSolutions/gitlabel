import click
import requests
from loguru import logger
from app.cli.start import Environment, pass_environment
from app.config import settings


def get_labels(username: str, repository: str):
    url = f"https://api.github.com/repos/{username}/{repository}/labels"
    headers = {
        "Authorization": f"Bearer {settings.github_access_token}",
        "Accept": "application/vnd.github.v3+json"
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        labels = response.json()
        return labels
    else:
        print(f"Failed to retrieve labels. Status code: {response.status_code}")
        return None


def create_label(username: str, repository: str, label: dict) -> bool:
    url = f'https://api.github.com/repos/{username}/{repository}/labels'
    headers = {
        'Authorization': f'Bearer {settings.github_access_token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    data: dict = {
        'name': label['name'],
        'color': label['color'],
        'description': label['description'],
    }

    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 201:
        return True
    else:
        print(f'Failed to create label {label}. Status code: {response.status_code}')
        return False


def delete_label(username: str, repository: str, label: str) -> bool:
    url = f'https://api.github.com/repos/{username}/{repository}/labels/{label}'
    headers = {
        'Authorization': f'Bearer {settings.github_access_token}',
        'Accept': 'application/vnd.github.v3+json'
    }

    response = requests.delete(url, headers=headers)

    if response.status_code == 204:
        return True
    else:
        print(f'Failed to delete label {label}. Status code: {response.status_code}')
        return False


@click.command("run", short_help="Run the CLI application.")
@click.option(
    "--username",
    "-u",
    default=settings.github_username,
    help="GitHub username.",
)
@click.option(
    "--source-repository",
    "-sr",
    default=settings.github_source_repository,
    help="Source repository to retrieve labels from.",
)
@click.option(
    "--target-repository",
    "-tr",
    default=settings.github_target_repository,
    help="Target repository to add labels to.",
)
@click.option(
    "--access-token",
    "-at",
    default=settings.github_access_token,
    help="GitHub access token.",
)
@pass_environment
def cli(ctx: Environment, username: str, source_repository: str, target_repository: str, access_token: str):
    """Run the CLI application."""

    source_labels = get_labels(username, source_repository)
    target_labels = get_labels(username, target_repository)

    logger.warning(source_labels)
    logger.warning(target_labels)

    if source_labels:
        for label in source_labels:
            logger.warning(label)

        logger.info(f'Labels in the source repository: {source_repository}')
        for label in source_labels:
            logger.info(label['name'])

    if target_labels:
        logger.info(f'Labels in the target repository: {target_repository}')
        for label in target_labels:
            logger.info(label['name'])
            delete_label(username, target_repository, label['name'])

    if source_labels:
        logger.info(f'Creating labels in the target repository: {target_repository}')
        for label in source_labels:
            create_label(username, target_repository, label)

    logger.success(f'Loaded {len(source_labels)} labels from the source repository: {username}/{source_repository}')
    logger.success(f'Loaded {len(target_labels)} labels from the target repository: {username}/{target_repository}')
