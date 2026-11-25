# Backup & Monitor

Bash scripts that automate compressed backups and system monitoring on Linux, scheduled with cron.

## Features
- Compressed, timestamped backups (`tar.gz`)
- Automatic cleanup of backups older than 7 days
- Logs disk, memory and CPU usage
- Warning when disk usage goes above 80%
- Scheduled with cron

## Tools
Bash, cron, tar, Linux (Ubuntu)

## Usage
```bash
chmod +x backup.sh monitor.sh
./backup.sh
./monitor.sh
```

## Cron schedule
0 2 * * * /home/<user>/backup-monitor/backup.sh
*/30 * * * * /home/<user>/backup-monitor/monitor.sh


## Sample log output
(paste a few lines from logs/monitor.log here)
