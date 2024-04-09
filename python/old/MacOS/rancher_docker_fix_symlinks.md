
# Rancher Docker Fix Symlinks Script

## Overview

This script is designed to resolve conflicts between Rancher Desktop and Docker Desktop on MacOS. It specifically addresses issues with the symlinks for `docker-buildx` and `docker-compose` CLI plugins.

## Functionality

The script performs the following actions:

1. Backs up existing symlinks for `docker-buildx` and `docker-compose` in the Docker CLI plugins directory.
2. Creates new symlinks pointing to the respective files in the Rancher Desktop bin directory.
3. Outputs the status of the newly created symlinks.

## Usage

To use this script, follow these steps:

1. Ensure Python is installed on your system.
2. Place the script in a desired directory.
3. Run the script using Python:

   ```bash
   python3 rancher_docker_fix_symlinks.py
   ```

## License

This script is provided "as is", without warranty of any kind, express or implied.
