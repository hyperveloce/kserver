#!/bin/bash

source /etc/kserver/backup.env

LOG="/var/log/kserver-backup-to-nas.log"
PUSH_URL="https://uptime.core-dna.com/api/push/dRDwIhPIPo"
PASS_FILE="/root/.rsync-nas-pass"

echo "=== Backup started: $(date) ===" >> "$LOG"

# ------------------------------------------------------------
# Nextcloud data
# Existing backup: destructive sync with deleted-file retention
# ------------------------------------------------------------

BACKUP_DIR_NC="/kserver.backup.nextcloud-data-deleted-$(date +%Y-%m-%d)"

rsync -avh --no-owner --no-group --delete \
  --backup --backup-dir="$BACKUP_DIR_NC" \
  --password-file="$PASS_FILE" \
  /srv/dna-library/nextcloud-data/ \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/kserver.backup.nextcloud-data/" >> "$LOG" 2>&1

NC_STATUS=$?

# ------------------------------------------------------------
# Immich data
# Existing backup: destructive sync with deleted-file retention
# ------------------------------------------------------------

BACKUP_DIR_IMMICH="/kserver.backup.immich-data-deleted-$(date +%Y-%m-%d)"

rsync -avh --no-owner --no-group --delete \
  --backup --backup-dir="$BACKUP_DIR_IMMICH" \
  --password-file="$PASS_FILE" \
  /srv/dna-library/immich-data/ \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/kserver.backup.immich-data/" >> "$LOG" 2>&1

IMMICH_STATUS=$?

# ------------------------------------------------------------
# Appdata
# New backup: NON-DESTRUCTIVE
# ------------------------------------------------------------

rsync -avh --no-owner --no-group --no-perms \
  --password-file="$PASS_FILE" \
  /srv/appdata/ \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/kserver.backup.appdata/" >> "$LOG" 2>&1

APPDATA_STATUS=$?

# ------------------------------------------------------------
# Databases
# New backup: NON-DESTRUCTIVE
# ------------------------------------------------------------

rsync -avh --no-owner --no-group --no-perms \
  --password-file="$PASS_FILE" \
  /srv/databases/ \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/kserver.backup.databases/" >> "$LOG" 2>&1

DATABASES_STATUS=$?

# ------------------------------------------------------------
# Database dumps
# New backup: NON-DESTRUCTIVE
# ------------------------------------------------------------

rsync -avh --no-owner --no-group --no-perms \
  --password-file="$PASS_FILE" \
  /srv/backups/database-dumps/ \
  "rsync://${NAS_USER}@${NAS_HOST}/${NAS_MODULE}/kserver.backup.database-dumps/" >> "$LOG" 2>&1

DUMPS_STATUS=$?

# ------------------------------------------------------------
# Overall result
# ------------------------------------------------------------

if [ "$NC_STATUS" -eq 0 ] && \
   [ "$IMMICH_STATUS" -eq 0 ] && \
   [ "$APPDATA_STATUS" -eq 0 ] && \
   [ "$DATABASES_STATUS" -eq 0 ] && \
   [ "$DUMPS_STATUS" -eq 0 ]; then

    echo "=== Backup completed successfully: $(date) ===" >> "$LOG"
    date > /var/lib/kserver-backups/nas.last-success

    curl -s "${PUSH_URL}?status=up&msg=All+NAS+backups+OK" > /dev/null

else

    echo "=== Backup FAILED (nc=$NC_STATUS, immich=$IMMICH_STATUS, appdata=$APPDATA_STATUS, databases=$DATABASES_STATUS, dumps=$DUMPS_STATUS): $(date) ===" >> "$LOG"

    curl -s "${PUSH_URL}?status=down&msg=NAS+backup+FAILED" > /dev/null
fi
