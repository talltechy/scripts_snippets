"""
This script resolves conflicts between Rancher Desktop and Docker Desktop
on MacOS by updating symlinks for docker-buildx and docker-compose. It
backs up existing symlinks in the Docker CLI plugins directory and
creates new symlinks pointing to the respective files in the Rancher
Desktop bin directory.
"""
import os
import shutil

def main():
    """
    This script resolves conflicts between Rancher Desktop and Docker Desktop
    on MacOS by updating symlinks for docker-buildx and docker-compose.
    """

    # Define the user's home directory and necessary paths
    user_home = os.path.expanduser('~')
    docker_cli_plugins_dir = os.path.join(user_home, '.docker', 'cli-plugins')
    rd_bin_dir = os.path.join(user_home, '.rd', 'bin')

    # List of CLI plugin files to be processed
    files = ['docker-buildx', 'docker-compose']

    for file in files:
        # Construct paths for original, backup, and new symlink destinations
        original_path = os.path.join(docker_cli_plugins_dir, file)
        backup_path = os.path.join(docker_cli_plugins_dir, f'{file}.bak')
        rd_bin_path = os.path.join(rd_bin_dir, file)

        # Backup existing symlinks if they exist
        if os.path.exists(original_path):
            print(f"Backing up {original_path} to {backup_path}...")
            shutil.move(original_path, backup_path)

        # Create new symlinks pointing to the .rd/bin directory
        print(f"Creating symlink for {file}...")
        os.symlink(rd_bin_path, original_path)

    # Verify and output the status of the newly created symlinks
    print("Symlink status:")
    for file in files:
        symlink_path = os.path.join(docker_cli_plugins_dir, file)
        if os.path.islink(symlink_path):
            # Output the target of each symlink
            print(f"{file}: {os.readlink(symlink_path)}")
        else:
            print(f"{file}: Symlink not found")

if __name__ == "__main__":
    # Execute the main function of the script
    main()
