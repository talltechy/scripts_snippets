#!/bin/bash
set -euo pipefail

# --- Script Information ---
SCRIPT_VERSION="2.0.0"
SCRIPT_NAME="create_admin_user.sh"
LAST_UPDATED="2025-07-23"

# --- Configurable variables ---
DEFAULT_USERNAME="talltechy"
LOG_FILE="/var/log/create_admin_user.log"

# --- Functions ---
log() {
  local msg="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') $msg" | tee -a "$LOG_FILE" > /dev/null
}

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." >&2
    exit 1
  fi
}

validate_username() {
  local name="$1"
  # Allow more standard username formats while maintaining security
  if [[ ! "$name" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]] || [[ ${#name} -gt 32 ]]; then
    echo "Invalid username: $name (must start with letter/underscore, contain only alphanumeric/underscore/hyphen, max 32 chars)" >&2
    exit 1
  fi
}

backup_file() {
  local file="$1"
  if [ -f "$file" ]; then
    local backup="$BACKUP_DIR/$(basename "$file").bak.$(date +%s)"
    cp -p "$file" "$backup"
    log "Backed up $file to $backup"
  fi
}

usage() {
  echo "$SCRIPT_NAME v$SCRIPT_VERSION (Updated: $LAST_UPDATED)"
  echo "Usage: $0 [username]"
  echo "Creates a new admin user with SSH key and passwordless sudo."
  echo ""
  echo "Options:"
  echo "  -h, --help     Show this help message"
  echo "  -v, --version  Show version information"
  echo ""
  echo "Examples:"
  echo "  $0                    # Creates user '$DEFAULT_USERNAME'"
  echo "  $0 myuser            # Creates user 'myuser'"
  exit 1
}

show_version() {
  echo "$SCRIPT_NAME v$SCRIPT_VERSION"
  echo "Last Updated: $LAST_UPDATED"
  echo "Description: Creates admin users with SSH keys and passwordless sudo access"
  exit 0
}

verify_setup() {
  local user="$1"
  echo "Verifying setup for $user..."
  
  # Check user exists and is in sudo group
  if groups "$user" | grep -q sudo; then
    echo "✓ User is in sudo group"
  else
    echo "✗ User not in sudo group"
    return 1
  fi
  
  # Check SSH key exists
  if sudo -u "$user" test -f "/home/$user/.ssh/id_ed25519"; then
    echo "✓ SSH private key exists"
  else
    echo "✗ SSH private key missing"
    return 1
  fi
  
  # Check sudoers file
  if visudo -cf "/etc/sudoers.d/$user"; then
    echo "✓ Sudoers configuration valid"
  else
    echo "✗ Sudoers configuration invalid"
    return 1
  fi
  
  echo "Setup verification complete!"
}

cleanup_on_failure() {
  local user="$1"
  local stage="$2"
  
  log "Setup failed at stage: $stage. Performing cleanup for user: $user"
  
  # Remove sudoers file if it was created
  if [[ -f "/etc/sudoers.d/$user" ]]; then
    rm -f "/etc/sudoers.d/$user"
    log "Removed sudoers file for $user"
  fi
  
  # Remove SSH directory if we created it
  if [[ -d "/home/$user/.ssh" ]] && [[ "$stage" != "user_creation" ]]; then
    rm -rf "/home/$user/.ssh"
    log "Removed SSH directory for $user"
  fi
  
  # Note: We don't remove the user account as it might have been pre-existing
  # or the admin might want to manually investigate
  
  log "Cleanup completed. User account $user was left intact for manual review."
  echo "Setup failed. Partial cleanup completed. Please review user account $user manually."
}

# --- Main script ---
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
fi

if [[ "${1:-}" == "-v" || "${1:-}" == "--version" ]]; then
  show_version
fi

require_root

USERNAME="${1:-$DEFAULT_USERNAME}"
validate_username "$USERNAME"
SSH_DIR="/home/$USERNAME/.ssh"
KEY_PATH="$SSH_DIR/id_ed25519"
SUDOERS_FILE="/etc/sudoers.d/$USERNAME"
BACKUP_DIR="/root/user_backups/$USERNAME/$(date +%Y%m%d_%H%M%S)"

log "Starting $SCRIPT_NAME v$SCRIPT_VERSION for user: $USERNAME"

# Create backup directory
mkdir -p "$BACKUP_DIR"
log "Created backup directory: $BACKUP_DIR"

# Set restrictive permissions on log file
touch "$LOG_FILE"
chmod 600 "$LOG_FILE"

# Add user and prompt for password
if id "$USERNAME" &>/dev/null; then
  log "User $USERNAME already exists. Skipping user creation."
else
  if ! adduser "$USERNAME"; then
    log "Failed to add user."
    cleanup_on_failure "$USERNAME" "user_creation"
    exit 1
  fi
  log "User $USERNAME created."
fi

# Add user to sudo group
if ! usermod -aG sudo "$USERNAME"; then
  log "Failed to add user to sudo group."
  cleanup_on_failure "$USERNAME" "sudo_group"
  exit 1
fi
log "User $USERNAME added to sudo group."

# Configure passwordless sudo securely
backup_file "$SUDOERS_FILE"
SUDOERS_LINE="$USERNAME ALL=(ALL) NOPASSWD:ALL"
echo "$SUDOERS_LINE" > "$SUDOERS_FILE"
chmod 0440 "$SUDOERS_FILE"
if ! visudo -cf "$SUDOERS_FILE"; then
  log "Sudoers file syntax error. Removing $SUDOERS_FILE for safety."
  rm -f "$SUDOERS_FILE"
  cleanup_on_failure "$USERNAME" "sudoers_config"
  exit 1
fi
log "Passwordless sudo configured for $USERNAME."

# Create .ssh directory with correct permissions
mkdir -p "$SSH_DIR"
chown "$USERNAME:$USERNAME" "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Backup existing SSH keys if present
backup_file "$KEY_PATH"
backup_file "${KEY_PATH}.pub"

# Generate SSH key pair for $USERNAME if not exists
if sudo -u "$USERNAME" test -f "$KEY_PATH"; then
  log "SSH key already exists at $KEY_PATH. Skipping key generation."
else
  echo "Generating SSH key for $USERNAME. You will be prompted for a passphrase (recommended)."
  if ! sudo -u "$USERNAME" ssh-keygen -t ed25519 -C "$USERNAME@$(hostname)" -f "$KEY_PATH"; then
    log "SSH key generation failed."
    cleanup_on_failure "$USERNAME" "ssh_key_generation"
    exit 1
  fi
  log "SSH key generated for $USERNAME."
  
  # Verify that a passphrase was set (optional but recommended)
  if sudo -u "$USERNAME" ssh-keygen -y -P "" -f "$KEY_PATH" &>/dev/null; then
    echo "WARNING: SSH key was generated without a passphrase. Consider regenerating with a passphrase for better security."
    log "WARNING: SSH key generated without passphrase for $USERNAME"
  else
    log "SSH key generated with passphrase for $USERNAME"
  fi
fi

# Set permissions for private and public keys
chmod 600 "$KEY_PATH"
chmod 644 "${KEY_PATH}.pub"
chown "$USERNAME:$USERNAME" "$KEY_PATH" "${KEY_PATH}.pub"

# Add public key to authorized_keys if not already present
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
if [ -f "$AUTHORIZED_KEYS" ] && grep -q -F "$(cat ${KEY_PATH}.pub)" "$AUTHORIZED_KEYS"; then
  log "Public key already in authorized_keys."
else
  touch "$AUTHORIZED_KEYS"
  cat "${KEY_PATH}.pub" >> "$AUTHORIZED_KEYS"
  chmod 600 "$AUTHORIZED_KEYS"
  chown "$USERNAME:$USERNAME" "$AUTHORIZED_KEYS"
  log "Public key added to authorized_keys."
fi

# Verify the complete setup
echo ""
echo "Setup completed! Verifying configuration..."
if verify_setup "$USERNAME"; then
  log "User $USERNAME setup completed successfully with verification."
  echo ""
  echo "✅ User $USERNAME created successfully!"
  echo "📁 Backups stored in: $BACKUP_DIR"
  echo "📋 SSH public key:"
  cat "${KEY_PATH}.pub"
  echo ""
  echo "🔐 You can now:"
  echo "   1. Copy the SSH public key to remote servers"
  echo "   2. Test sudo access: sudo -u $USERNAME sudo whoami"
  echo "   3. Test SSH key: ssh -i $KEY_PATH user@remote-server"
else
  log "Setup verification failed for $USERNAME"
  echo "❌ Setup completed but verification failed. Please check the logs."
  exit 1
fi
