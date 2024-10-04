# 
# This script generates an SSH key for a specified user or the current logged-in user.
# 
# Usage:
#   ./ssh_key.sh [username]
# 
# If no username is provided, the script will use the current logged-in user.
# 
# Functions:
# 
# error_exit(message):
#   Prints the provided error message to stderr and exits the script with a status of 1.
# 
# generate_ssh_key(username):
#   Generates an SSH key for the specified username.
#   - Checks if the user exists.
#   - Creates the .ssh directory if it doesn't exist.
#   - Generates an SSH key using the ed25519 algorithm.
#   - Sets appropriate permissions for the key files.
#   - Prints a success message with the location of the generated key.
# 
# Variables:
# 
# username:
#   The username for which the SSH key will be generated. If not provided, defaults to the current logged-in user.
#!/bin/bash

# Function to handle errors
error_exit() {
    echo "$1" 1>&2
    exit 1
}

# Function to generate SSH key
generate_ssh_key() {
    local username=$1
    local ssh_dir="/home/$username/.ssh"
    local key_file="$ssh_dir/id_ed25519"

    # Check if the user exists
    if id "$username" &>/dev/null; then
        # Create .ssh directory if it doesn't exist
        mkdir -p "$ssh_dir"
        chmod 700 "$ssh_dir"

        # Prompt the user for a passphrase
        read -sp "Enter passphrase for the SSH key: " passphrase
        echo

        # Generate SSH key using the most secure algorithm
        ssh-keygen -t ed25519 -f "$key_file" -N "$passphrase" -C "$username@$(hostname)"

        # Set appropriate permissions
        chmod 600 "$key_file"
        chmod 644 "$key_file.pub"

        echo "SSH key generated for user $username at $key_file"
    else
        error_exit "User $username does not exist."
    fi
}

# Get the current logged in user if no user is specified
username=${1:-$(whoami)}

# Generate SSH key for the specified or current user
generate_ssh_key "$username"