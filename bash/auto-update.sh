#!/bin/sh

# Source environment variables from the configuration file
. /Users/mattwyen/github/scripts_snippets/bash/auto-update.env

LOGFILE="/var/log/auto-update.log"
EMAIL="${AUTO_UPDATE_EMAIL}"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

# Function to send email notification securely
send_email() {
    SUBJECT="Alpine Linux Auto-Update Script Completion"
    if [ -n "$EMAIL" ]; then
        cat $LOGFILE | msmtp --subject="$SUBJECT" "$EMAIL"
    else
        log "Email address not set. Skipping email notification."
    fi
}

# Ensure log file has restricted permissions
touch $LOGFILE
chmod 600 $LOGFILE

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
