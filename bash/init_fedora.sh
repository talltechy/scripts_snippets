#!/bin/bash

# Check if the script is being run as root using sudo
if ! sudo -v &> /dev/null; then
    echo "This script must be run as root using sudo."
    exit 1
fi

# Install dnf5 and its dependencies, install dialog and tmux packages
sudo dnf install -y dnf5 dnf5-plugins dialog tmux

# Update dnf configuration to allow more mirrors and enable fastestmirror plugin
echo -e "max_parallel_downloads=10\nfastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf

# Create a symbolic link from dnf to dnf5
sudo ln -sf /usr/bin/dnf5 /usr/bin/dnf

# Clean up the package cache
sudo dnf clean all

echo "dnf5 and its dependencies, along with dialog and tmux, have been installed successfully."
