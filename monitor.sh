#!/bin/bash
# Monitoring script: logs disk, memory and CPU usage, warns if disk is almost full

LOG="$HOME/backup-monitor/logs/monitor.log"
THRESHOLD=80

DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
MEM=$(free -m | awk 'NR==2 {printf "%.0f", $3*100/$2}')
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')

echo "[$(date)] Disk: ${DISK}% | Memory: ${MEM}% | CPU: ${CPU}%" >> "$LOG"

if [ "$DISK" -gt "$THRESHOLD" ]; then
    echo "[$(date)] WARNING: Disk usage above ${THRESHOLD}%!" >> "$LOG"
fi
