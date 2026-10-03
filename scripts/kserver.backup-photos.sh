#!/bin/bash

source /etc/kserver/backup.env

LOG="/var/log/kserver-backup-photos.log"
PUSH_URL="https://uptime.core-dna.com/api/push/FVSjwJIHLw"
BACKUP_DIR="/photos-videos-deleted-$(date +%Y-%m-%d)"
SOURCE="/srv/dna-library/photos-videos/"
PASS_FILE="/root/.rsync-nas-pass"

echo "=== Backup started: $(date) ===" >> "$LOG"

rsync -avh --no-owner --no-group --delete \
  --backup --backup-dir="$BACKUP_DIR" \
  --password-file="$PASS_FILE" \
  "$SOURCE" \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/photos-videos/" >> "$LOG" 2>&1

if [ $? -eq 0 ]; then
  echo "=== Backup completed successfully: $(date) ===" >> "$LOG"
  date > /var/lib/kserver-backups/photos.last-success
  curl -s "${PUSH_URL}?status=up&msg=Backup+OK" > /dev/null
else
  echo "=== Backup FAILED: $(date) ===" >> "$LOG"
  curl -s "${PUSH_URL}?status=down&msg=Backup+FAILED" > /dev/null
fi
