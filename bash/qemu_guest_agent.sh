#!/bin/bash

# Determine package manager
if command -v apt > /dev/null; then
    PKG_MANAGER="apt"
elif command -v dnf > /dev/null; then
    PKG_MANAGER="dnf"
else
    echo "Neither apt nor dnf found. Exiting."
    exit 1
fi

# Check if qemu-guest-agent is already running
if sudo systemctl is-active --quiet qemu-guest-agent; then
    echo "qemu-guest-agent is already running."
    exit 0
fi

# Install virt-what if not already installed
if ! command -v virt-what > /dev/null; then
    sudo $PKG_MANAGER update -y
    sudo $PKG_MANAGER install virt-what -y
fi

# Check if the system is running as a VM
if virt-what | grep -q "kvm"; then
    echo "System is running as a VM."
else
    echo "System is not running as a VM."
    exit 1
fi

# Remove virt-what
sudo $PKG_MANAGER remove virt-what -y

# Check if qemu-guest-agent is installed
if ! dpkg -l | grep -q qemu-guest-agent; then
    # Update package lists and install qemu-guest-agent
    sudo $PKG_MANAGER update -y
    sudo $PKG_MANAGER install qemu-guest-agent -y
else
    echo "qemu-guest-agent is already installed."
fi

# Enable qemu-guest-agent service
sudo systemctl enable qemu-guest-agent

# Verify if qemu-guest-agent is running
if sudo systemctl is-active --quiet qemu-guest-agent; then
    echo "qemu-guest-agent is running."
else
    echo "qemu-guest-agent is not running."
fi
