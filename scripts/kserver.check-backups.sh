#!/bin/bash

LOG="/var/log/kserver-backup-watchdog.log"
MAX_AGE=$((8 * 24 * 60 * 60))
NOW=$(date +%s)

echo "=== Backup watchdog: $(date) ===" >> "$LOG"

FAILED=0

for name in photos storage-files nas
do
    FILE="/var/lib/kserver-backups/${name}.last-success"

    if [ ! -f "$FILE" ]; then
        echo "WARNING: No successful backup recorded for $name" >> "$LOG"
        FAILED=1
        continue
    fi

    LAST=$(stat -c %Y "$FILE")
    AGE=$((NOW - LAST))

    if [ "$AGE" -gt "$MAX_AGE" ]; then
        echo "WARNING: $name backup is older than 8 days" >> "$LOG"
        FAILED=1
    else
        echo "OK: $name backup is recent" >> "$LOG"
    fi
done

if [ "$FAILED" -eq 0 ]; then
    echo "=== All backups OK ===" >> "$LOG"
    exit 0
else
    echo "=== BACKUP WATCHDOG FAILED ===" >> "$LOG"
    exit 1
fi
