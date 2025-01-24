#!/bin/sh

LOGFILE="/var/log/auto-update.log"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

# Update the package list
log "Starting package list update..."
if apk update >> $LOGFILE 2>&1; then
    log "Package list update completed successfully."
else
    log "Package list update failed."
    exit 1
fi

# Upgrade all installed packages
log "Starting package upgrade..."
if apk upgrade >> $LOGFILE 2>&1; then
    log "Package upgrade completed successfully."
else
    log "Package upgrade failed."
    exit 1
fi

# Clean up
log "Cleaning up package cache..."
if apk cache clean >> $LOGFILE 2>&1; then
    log "Package cache cleaned successfully."
else
    log "Package cache clean failed."
    exit 1
fi

log "System update and upgrade completed."
