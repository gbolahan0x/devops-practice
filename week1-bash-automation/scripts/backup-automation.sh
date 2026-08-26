#!/bin/bash

########################################################
# Back Up Automtion Script
# Purpose: Backup directories with roration
# Usage: ./backupautomation.sh [source_dir] [backup_dir]
########################################################

# Default Values
SOURCE_DIR="${1:-.}" # current diir if not specified
BACKUP_DIR="${2:~/backups}" # ~/backups if not specified
RETENTION_DAYS=7
MAX_BACKUPS=5

# Create backup file if not exist
mkdir -p "$BACKUP_DIR"

# Backup filename with timestamp
BACKUP_FILE="$BACKUP_DIR/backup-$(date +%Y%m%d-%H%M%S).tar.gz"

echo "Starting Backup......"
echo "Source: $SOURCE_DIR"
echo "Destination: $BACKUP_FILE"
echo ""

# Create the backup
if tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>/dev/null; then
	#Get the backup file
	SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
	echo "✓ Backup Successful!"
	echo " File: $(basename $BACKUP_FILE)"
	echo " Size: $SIZE"

	# Log the backup
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup Created: 
	$BACKUP_FILE (Size: $SIZE)" >> "$BACKUP_DIR/backup.log"
else
	echo "✗ Backup failed!"
	exit 1
fi


# clean up old backups (keep only last 5)
echo ""
echo "Cleaning up old backups....."

BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup-*.tar.gz 2>/dev/null | wc -l)

if [ $BACKUP_COUNT -gt $MAX_BACKUPS ]; then
	echo "Found $BACKUP_COUNT backups, Keeping last $MAX_BACKUPS ..."

	     #Remove oldest backups
	     ls -1t "$BACKUP_DIR"/backup-*tar.gz 2>/dev/null | tail -n +$((MAX_BACKUPS+1)) | while read old_backup; do
	     	echo "Removing: $(basename $old_backup)"
	     	rm -f "$old_backup"
	     done 
	 else
	 	echo "Backup Count: $BACKUP_COUNT/$MAX_BACKUPS (no cleanup needed)"
	 fi

	 echo ""
	 echo "Backup process completed!"
