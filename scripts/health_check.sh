#!/usr/bin/env bash
set -euo pipefail

CONTAINER="${CONTAINER:-mc-bedrock}"

echo "[*] Container status:"
docker ps --filter "name=^/${CONTAINER}$" --format '  - {{.Names}}: {{.Status}}'

echo "[*] Server players:"
docker exec "$CONTAINER" send-command "list" || true
