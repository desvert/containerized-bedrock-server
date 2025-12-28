#!/usr/bin/env bash
# Make executable on your server

set -euo pipefail

BASE_DIR="${BASE_DIR:-$HOME/bedrock_server}"   # override if needed
BACKUP_DIR="${BACKUP_DIR:-$BASE_DIR/backups}"
CONTAINER="${CONTAINER:-mc-bedrock}"
DATE="$(date +%F_%H-%M)"
BACKUP_FILE="$BACKUP_DIR/bedrock-backup-$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"
cd "$BASE_DIR"

echo "[+] Requesting save hold..."
docker exec "$CONTAINER" send-command "save hold" >/dev/null

echo "[+] Querying save status..."
docker exec "$CONTAINER" send-command "save query" >/dev/null

# Give the server a moment to flush pending writes
sleep 5

echo "[+] Creating backup: $BACKUP_FILE"
tar -czf "$BACKUP_FILE" data

echo "[+] Resuming saves..."
docker exec "$CONTAINER" send-command "save resume" >/dev/null

echo "[+] Backup complete."
