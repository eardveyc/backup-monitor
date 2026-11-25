#!/bin/bash
# Installs the backup & monitor scripts for a given user and sets up cron jobs.
# Usage (as root): ./install.sh [username]     (default: agnessgirl)
set -e

[ "$(id -u)" -eq 0 ] || { echo "Please run as root"; exit 1; }

USER_NAME="${1:-agnessgirl}"
HOME_DIR="/home/$USER_NAME"
APP_DIR="$HOME_DIR/backup-monitor"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing packages"
apt-get update -qq
apt-get install -y cron procps

echo "==> Creating user $USER_NAME (if missing)"
id "$USER_NAME" &>/dev/null || useradd -m -s /bin/bash "$USER_NAME"

echo "==> Copying scripts"
mkdir -p "$APP_DIR"/{backups,logs} "$HOME_DIR/important-files"
if [ "$SRC_DIR" != "$APP_DIR" ]; then
    cp "$SRC_DIR/backup.sh" "$SRC_DIR/monitor.sh" "$APP_DIR/"
fi
chmod +x "$APP_DIR/backup.sh" "$APP_DIR/monitor.sh"
chown -R "$USER_NAME:$USER_NAME" "$HOME_DIR"

echo "==> Setting up cron jobs"
EXISTING=$(crontab -u "$USER_NAME" -l 2>/dev/null || true)
{
  echo "$EXISTING" | grep -v -e "$APP_DIR/backup.sh" -e "$APP_DIR/monitor.sh" | grep -v '^$' || true
  echo "0 2 * * * $APP_DIR/backup.sh"
  echo "*/30 * * * * $APP_DIR/monitor.sh"
} | crontab -u "$USER_NAME" -

echo "==> Starting cron"
systemctl enable --now cron 2>/dev/null || service cron start 2>/dev/null || true

echo "Done. Check with: crontab -u $USER_NAME -l"
