#!/bin/bash

# 1. Enable Strict Mode (Stop immediately on errors, unset variables, or pipe failures)
set -euo pipefail

# Directory & File Configuration
BACKUP_DIR="/backup"
SOURCE="/var/www"
TARGET_FILE="$BACKUP_DIR/web.tar.gz"

# Use Process ID ($$) for a unique temporary file to prevent race conditions
TEMP_FILE="$BACKUP_DIR/web.tar.gz.tmp.$$"

# 2. Check if script is executed as root (required for systemctl restart)
if [[ $EUID -ne 0 ]]; then
   echo "[ERROR] This script must be run as root!" >&2
   exit 1
fi

# 3. Check if the source directory exists
if [[ ! -d "$SOURCE" ]]; then
    echo "[ERROR] Source directory $SOURCE not found!" >&2
    exit 1
fi

# 4. Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

echo "[INFO] Starting backup process to temporary file: $TEMP_FILE"

# 5. Execute backup using a temporary file
if tar -czf "$TEMP_FILE" "$SOURCE"; then
    echo "[INFO] Backup successfully created in temporary file. Moving to final target..."
    
    # Atomic Move: Replaces the old file with the new file instantaneously
    mv "$TEMP_FILE" "$TARGET_FILE"
    echo "[SUCCESS] Backup completed: $TARGET_FILE"
    
    # Restart Nginx ONLY if backup creation and file rename succeeded
    echo "[INFO] Restarting Nginx..."
    systemctl restart nginx
    echo "[SUCCESS] Nginx restarted successfully."
else
    echo "[ERROR] Backup FAILED! Aborting process." >&2
    
    # Remove ONLY the incomplete/corrupted temporary file
    if [[ -f "$TEMP_FILE" ]]; then
        echo "[INFO] Cleaning up incomplete temporary file ($TEMP_FILE)..."
        rm -f "$TEMP_FILE"
    fi
    
    echo "[INFO] Existing backup file (if any) remains safe and untouched."
    exit 1
fi