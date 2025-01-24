#!/bin/sh

# Path to the environment configuration file
ENV_FILE="/etc/auto-update.env"

# Function to create the .env file if it doesn't exist
create_env_file() {
    if [ ! -f "$ENV_FILE" ]; then
        cat <<EOF > "$ENV_FILE"
AUTO_UPDATE_EMAIL=""

# Optional settings for secure email relay
SMTP_SERVER="smtp.example.com"
SMTP_PORT="587"
SMTP_USER="your-smtp-username"
SMTP_PASSWORD="your-smtp-password"
EOF
        chmod 600 "$ENV_FILE"
        log "Created default environment configuration file at $ENV_FILE"
    fi
}

# Source environment variables from the configuration file
. "$ENV_FILE"

LOGFILE="/var/log/auto-update.log"
EMAIL="${AUTO_UPDATE_EMAIL:-root}"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

# Function to send email notification securely
send_email() {
    SUBJECT="Alpine Linux Auto-Update Script Completion"
    if [ -n "$SMTP_SERVER" ] && [ -n "$SMTP_PORT" ] && [ -n "$SMTP_USER" ] && [ -n "$SMTP_PASSWORD" ]; then
        cat $LOGFILE | msmtp --host="$SMTP_SERVER" --port="$SMTP_PORT" --auth=on --user="$SMTP_USER" --passwordeval="echo $SMTP_PASSWORD" --tls=on --tls-starttls=on --subject="$SUBJECT" "$EMAIL"
    else
        cat $LOGFILE | msmtp --subject="$SUBJECT" "$EMAIL"
    fi
}

# Ensure log file has restricted permissions
touch $LOGFILE
chmod 600 $LOGFILE

# Create the .env file if it doesn't exist
create_env_file

# Check if the script is running on Alpine Linux
if [ -f /etc/alpine-release ]; then
    log "Running on Alpine Linux."
else
    log "This script is intended to be used on Alpine Linux only."
    exit 1
fi

# Update the package list
log "Starting package list update..."
if apk update >> $LOGFILE 2>&1; then
    log "Package list update completed successfully."
else
    log "Package list update failed."
    send_email
    exit 1
fi

# Upgrade all installed packages
log "Starting package upgrade..."
if apk upgrade >> $LOGFILE 2>&1; then
    log "Package upgrade completed successfully."
else
    log "Package upgrade failed."
    send_email
    exit 1
fi

# Clean up
log "Cleaning up package cache..."
if apk cache clean >> $LOGFILE 2>&1; then
    log "Package cache cleaned successfully."
else
    log "Package cache clean failed."
    send_email
    exit 1
fi

log "System update and upgrade completed."
send_email
