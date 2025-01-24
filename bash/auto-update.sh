#!/bin/sh

# Path to the environment configuration file
ENV_FILE="/etc/auto-update.env"

# Function to create the .env file if it doesn't exist
create_env_file() {
    if [ ! -f "$ENV_FILE" ]; then
        cat <<EOF > "$ENV_FILE"
AUTO_UPDATE_EMAIL=""
ENABLE_SMTP="false"

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

# Function to validate email address format
validate_email() {
    if echo "$1" | grep -E -q "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"; then
        return 0
    else
        return 1
    fi
}

# Function to validate SMTP settings
validate_smtp_settings() {
    if [ "$ENABLE_SMTP" = "true" ]; then
        if [ -z "$SMTP_SERVER" ] || [ -z "$SMTP_PORT" ] || [ -z "$SMTP_USER" ] || [ -z "$SMTP_PASSWORD" ]; then
            return 1
        fi
        if ! echo "$SMTP_PORT" | grep -E -q "^[0-9]+$"; then
            return 1
        fi
    fi
    return 0
}

# Function to send email notification securely
send_email() {
    SUBJECT="Alpine Linux Auto-Update Script Completion"
    if validate_smtp_settings; then
        cat $LOGFILE | msmtp --host="$SMTP_SERVER" --port="$SMTP_PORT" --auth=on --user="$SMTP_USER" --passwordeval="echo $SMTP_PASSWORD" --tls=on --tls-starttls=on --subject="$SUBJECT" "$EMAIL"
    else
        log "SMTP settings are not valid or SMTP is disabled. Skipping email notification."
    fi
}

# Ensure log file has restricted permissions
touch $LOGFILE
chmod 600 $LOGFILE

# Create the .env file if it doesn't exist
create_env_file

# Validate email address
if ! validate_email "$EMAIL"; then
    log "Invalid email address: $EMAIL"
    exit 1
fi

# Validate SMTP settings
if ! validate_smtp_settings; then
    log "Invalid SMTP settings."
    exit 1
fi

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
