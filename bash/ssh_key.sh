# This script generates an SSH key for a specified user or the current user.
# It performs the following steps:
# 1. Defines a function to handle errors and exit the script.
# 2. Defines a function to check write permissions for the user's home and .ssh directories.
# 3. Defines a function to generate an SSH key using the ed25519 algorithm.
# 4. Determines the username to generate the SSH key for, defaulting to the current user if none is specified.
# 5. Checks if the script is run with sudo if generating an SSH key for another user.
# 6. Checks the necessary permissions.
# 7. Generates the SSH key for the specified or current user.
#!/bin/bash

# Function to handle errors
error_exit() {
    echo "$1" 1>&2
    exit 1
}

# Function to check permissions
check_permissions() {
    local username=$1
    local user_home=$(eval echo ~$username)
    local ssh_dir="$user_home/.ssh"

    if [ ! -w "$user_home" ]; then
        error_exit "You do not have write permissions to the home directory of $username."
    fi

    if [ -d "$ssh_dir" ] && [ ! -w "$ssh_dir" ]; then
        error_exit "You do not have write permissions to the .ssh directory of $username."
    fi
}

# Function to generate SSH key
generate_ssh_key() {
    local username=$1
    local user_home=$(eval echo ~$username)
    local ssh_dir="$user_home/.ssh"
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
if [ -z "$1" ]; then
    if [ "$EUID" -eq 0 ]; then
        username=${SUDO_USER}
    else
        username=$(whoami)
    fi
else
    username=$1
fi

# Check if running with sudo if a username is specified
if [ "$username" != "$(whoami)" ] && [ "$EUID" -ne 0 ]; then
    error_exit "You must run this script with sudo to generate an SSH key for another user."
fi

# Check permissions
check_permissions "$username"

# Generate SSH key for the specified or current user
generate_ssh_key "$username"