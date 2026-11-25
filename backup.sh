#!/bin/bash
# Backup script: compresses a folder and removes backups older than 7 days

SOURCE="$HOME/important-files"
DEST="$HOME/backup-monitor/backups"
LOG="$HOME/backup-monitor/logs/backup.log"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
FILE="$DEST/backup_$DATE.tar.gz"

if tar -czf "$FILE" "$SOURCE" 2>/dev/null; then
    echo "[$(date)] SUCCESS: Backup created at $FILE" >> "$LOG"
else
    echo "[$(date)] ERROR: Backup failed" >> "$LOG"
    exit 1
fi

# Delete backups older than 7 days
find "$DEST" -name "backup_*.tar.gz" -mtime +7 -delete
echo "[$(date)] Old backups cleaned up" >> "$LOG"
