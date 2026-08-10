#!/bin/bash

# Define paths relative to the current user's home directory
ARCHIVE_DIR="$HOME/archive"
BACKUP_DIR="$HOME/backup"
LOG_DIR="/var/log"
ARCHIVE_FILE="$ARCHIVE_DIR/log.tar"

echo "=========================================="
echo "      Automated Log Archival Script       "
echo "=========================================="

# 1. Ensure output directories exist
echo "[1/4] Preparing directories..."
mkdir -p "$ARCHIVE_DIR" "$BACKUP_DIR"

# Check if there are any .log files in /var/log
shopt -s nullglob
log_files=("$LOG_DIR"/*.log)
shopt -u nullglob

if [ ${#log_files[@]} -eq 0 ]; then
    echo "Error: No .log files found in $LOG_DIR to archive." >&2
    exit 1
fi

# 2. Archive files without path names and with verbose output
echo -e "\n[2/4] Archiving .log files from $LOG_DIR into $ARCHIVE_FILE..."
cd "$LOG_DIR" || exit 1
tar -cvf "$ARCHIVE_FILE" *.log
TAR_EXIT=$?
cd - > /dev/null || exit 1

if [ $TAR_EXIT -ne 0 ]; then
    echo "Error: Failed to create tar archive." >&2
    exit 1
fi

# 3. List the contents of the archive without extracting
echo -e "\n[3/4] Archive contents listing ($ARCHIVE_FILE):"
echo "------------------------------------------"
tar -tvf "$ARCHIVE_FILE"
echo "------------------------------------------"

# 4. Extract files to ~/backup
echo -e "\n[4/4] Extracting files to $BACKUP_DIR..."
tar -xvf "$ARCHIVE_FILE" -C "$BACKUP_DIR"
if [ $? -eq 0 ]; then
    echo -e "\nSUCCESS: Log archival and extraction complete!"
else
    echo "Error: Extraction failed." >&2
    exit 1
fi