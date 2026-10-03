#!/bin/bash

source /etc/kserver/backup.env

LOG="/var/log/kserver-backup-storage-files.log"
PUSH_URL="https://uptime.core-dna.com/api/push/8eQVSXIFQn"
BACKUP_DIR="/storage-files-deleted-$(date +%Y-%m-%d)"
SOURCE="/srv/dna-library/storage-files/"
PASS_FILE="/root/.rsync-nas-pass"

echo "=== Backup started: $(date) ===" >> "$LOG"

rsync -avh --no-owner --no-group --no-perms --delete \
  --backup --backup-dir="$BACKUP_DIR" \
  --password-file="$PASS_FILE" \
  "$SOURCE" \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/storage-files/" >> "$LOG" 2>&1

if [ $? -eq 0 ]; then
  echo "=== Backup completed successfully: $(date) ===" >> "$LOG"
  date > /var/lib/kserver-backups/storage-files.last-success
  curl -s "${PUSH_URL}?status=up&msg=Backup+OK" > /dev/null
else
  echo "=== Backup FAILED: $(date) ===" >> "$LOG"
  curl -s "${PUSH_URL}?status=down&msg=Backup+FAILED" > /dev/null
fi
