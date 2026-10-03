#!/bin/bash

source /etc/kserver/backup.env

LOG="/var/log/kserver-backup-to-nas.log"
PUSH_URL="https://uptime.core-dna.com/api/push/dRDwIhPIPo"
PASS_FILE="/root/.rsync-nas-pass"

echo "=== Backup started: $(date) ===" >> "$LOG"

# Nextcloud data
BACKUP_DIR_NC="/kserver.backup.nextcloud-data-deleted-$(date +%Y-%m-%d)"
rsync -avh --no-owner --no-group --delete \
  --backup --backup-dir="$BACKUP_DIR_NC" \
  --password-file="$PASS_FILE" \
  /srv/dna-library/nextcloud-data/ \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/kserver.backup.nextcloud-data/" >> "$LOG" 2>&1
NC_STATUS=$?

# Immich data
BACKUP_DIR_IMMICH="/kserver.backup.immich-data-deleted-$(date +%Y-%m-%d)"
rsync -avh --no-owner --no-group --delete \
  --backup --backup-dir="$BACKUP_DIR_IMMICH" \
  --password-file="$PASS_FILE" \
  /srv/dna-library/immich-data/ \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/kserver.backup.immich-data/" >> "$LOG" 2>&1
IMMICH_STATUS=$?

if [ $NC_STATUS -eq 0 ] && [ $IMMICH_STATUS -eq 0 ]; then
  echo "=== Backup completed successfully: $(date) ===" >> "$LOG"
  date > /var/lib/kserver-backups/nas.last-success
  curl -s "${PUSH_URL}?status=up&msg=Nextcloud+and+Immich+OK" > /dev/null
else
  echo "=== Backup FAILED (nc=$NC_STATUS, immich=$IMMICH_STATUS): $(date) ===" >> "$LOG"
  curl -s "${PUSH_URL}?status=down&msg=Backup+FAILED" > /dev/null
fi
