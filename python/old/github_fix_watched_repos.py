"""
This script updates the subscription settings for all repositories the user is watching on GitHub.
"""

import getpass
import webbrowser
import logging
import os
import sys
import requests
from colorama import just_fix_windows_console

# use Colorama to make Termcolor work on Windows too
just_fix_windows_console()

# Set up logging
log_file = os.path.join(os.path.dirname(__file__), 'log.txt')
logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')

# ANSI color codes
GREEN = '\033[32m'
YELLOW = '\033[33m'
RED = '\033[31m'
RESET = '\033[0m'

print(f"{GREEN}To generate a personal access token in GitHub:\n"
    f"{GREEN}1. Sign in to your GitHub account.\n"
    f"{GREEN}2. Click on your profile photo in the upper-right corner of any page.\n"
    f"{GREEN}3. Click on {YELLOW}'Settings'{GREEN} in the drop-down menu.\n"
    f"{GREEN}4. In the left sidebar, click on {YELLOW}'Developer settings'{GREEN}.\n"
    f"{GREEN}5. Click on {YELLOW}'Personal access tokens'{GREEN}.\n"
    f"{GREEN}6. Click on {YELLOW}'Generate new token'{GREEN}.\n"
    f"{GREEN}7. Give your token a descriptive name in the {YELLOW}'Note'{GREEN} field.\n"
    f"{GREEN}8. Select the scopes, or permissions, you'd like to grant this token.\n"
    f"{GREEN}   For this script, you'll need at least the {YELLOW}'repo'{GREEN} scope.\n"
    f"{GREEN}9. Click {YELLOW}'Generate token'{GREEN}.\n"
    f"{GREEN}10. After generating the token, make sure to copy it. You won't be able to see it again!\n"
    f"{GREEN}Remember to keep your tokens secret; treat them just like passwords.\n"
    f"{GREEN}If a token is ever compromised, you can go back to the token settings and revoke it.{RESET}")

# Ask the user if they want to open the URL to create a personal access token in a browser
open_url = input(f"{YELLOW}Do you want to open the URL to create a personal access token in a browser? (y/n/cancel): "
                 f"{RESET}").strip()
if open_url.lower() == 'y':
    webbrowser.open('https://github.com/settings/tokens/new')
elif open_url.lower() == 'cancel':
    sys.exit(0)

# Prompt the user for their GitHub username and personal access token
username = input(f"{YELLOW}Enter your GitHub username (cancel to exit): {RESET}")
if username.lower() == 'cancel':
    sys.exit(0)
token = getpass.getpass(f"{YELLOW}Enter your GitHub token (cancel to exit): {RESET}")
if token.lower() == 'cancel':
    sys.exit(0)

# Check if the username and token are correct
headers = {
    'Accept': 'application/vnd.github.v3+json',
    'Authorization': f'token {token}',
}
response = requests.get(f'https://api.github.com/users/{username}', headers=headers, timeout=10)
if response.status_code == 200:
    print(f"{GREEN}Username and token are correct.{RESET}")
else:
    print(f"{RED}Invalid username or token.{RESET}")
    sys.exit(0)

# Log input
logging.info('Open URL: %s', open_url)

# The headers for the API request
headers = {
    'Accept': 'application/vnd.github.v3+json',
    'Authorization': f'token {token}',
}

# Get the list of repositories you're watching
response = requests.get(f'https://api.github.com/users/{username}/subscriptions',
                        headers=headers, timeout=10)
repos = response.json()

# Prompt the user if they want to update settings for each individual repo or update all repos at once
update_all = input(f"{YELLOW}Do you want to update settings for each individual repo or update all repos at once? (individual/all/cancel): {RESET}").strip()
if update_all.lower() == 'individual':
    # Loop over the repositories
    for repo in repos:
        # Get the repo's owner and name
        owner = repo['owner']['login']
        repo_name = repo['name']

        # Change the subscription settings
        subscribe_input = input(f"{YELLOW}Subscribe to notifications for {repo_name}? (y/n/cancel): {RESET}").lower()
        if subscribe_input == 'cancel':
            sys.exit(0)
        subscribe = subscribe_input == 'y'

        ignore_input = input(f"{YELLOW}Ignore notifications for {repo_name}? (y/n/cancel): {RESET}").lower()
        if ignore_input == 'cancel':
            sys.exit(0)
        ignore = ignore_input == 'y'

        reason_input = input(f"{YELLOW}Reason for notifications for {repo_name} (e.g. releases, all, etc.) (cancel to skip): {RESET}")
        if reason_input.lower() == 'cancel':
            continue
        reason = reason_input

        subscription_url = f'https://api.github.com/repos/{owner}/{repo_name}/subscription'
        subscription_settings = {
            'subscribed': subscribe,
            'ignored': ignore,
            'reason': reason,
        }

        response = requests.put(subscription_url, headers=headers, json=subscription_settings, timeout=10)

        # Log the repo name and settings
        logging.info('Repo: %s, Settings: %s', repo_name, subscription_settings)

        # Check if the request was successful
        if response.status_code == 200:
            SUCCESS_MSG = f"{GREEN}Successfully updated settings for {repo_name}{RESET}"
            print(SUCCESS_MSG)
            logging.info(SUCCESS_MSG)
        else:
            ERROR_MSG = f"{RED}Failed to update settings for {repo_name}{RESET}"
            print(ERROR_MSG)
            logging.error(ERROR_MSG)
elif update_all.lower() == 'all':
    # Change the subscription settings for all repos at once
    subscribe_input = input(f"{YELLOW}Subscribe to notifications for all repos? (y/n/cancel): {RESET}").lower()
    if subscribe_input == 'cancel':
        sys.exit(0)
    subscribe = subscribe_input == 'y'

    ignore_input = input(f"{YELLOW}Ignore notifications for all repos? (y/n/cancel): {RESET}").lower()
    if ignore_input == 'cancel':
        sys.exit(0)
    ignore = ignore_input == 'y'

    reason_input = input(f"{YELLOW}Reason for notifications for all repos (e.g. releases, all, etc.) (cancel to skip): {RESET}")
    if reason_input.lower() == 'cancel':
        sys.exit(0)
    reason = reason_input

    for repo in repos:
        # Get the repo's owner and name
        owner = repo['owner']['login']
        repo_name = repo['name']

        subscription_url = f'https://api.github.com/repos/{owner}/{repo_name}/subscription'
        subscription_settings = {
            'subscribed': subscribe,
            'ignored': ignore,
            'reason': reason,
        }

        response = requests.put(subscription_url, headers=headers, json=subscription_settings, timeout=10)

        # Log the repo name and settings
        logging.info('Repo: %s, Settings: %s', repo_name, subscription_settings)

        # Check if the request was successful
        if response.status_code == 200:
            SUCCESS_MSG = f"{GREEN}Successfully updated settings for {repo_name}{RESET}"
            print(SUCCESS_MSG)
            logging.info(SUCCESS_MSG)
        else:
            ERROR_MSG = f"{RED}Failed to update settings for {repo_name}{RESET}"
            print(ERROR_MSG)
            logging.error(ERROR_MSG)
elif update_all.lower() == 'cancel':
    sys.exit(0)
else:
    print(f"{RED}Invalid input. Please enter 'individual' or 'all'.{RESET}")
    sys.exit(0)
