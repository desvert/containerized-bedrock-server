#!/usr/bin/env bash
# This waits for the server to accept commands, then applies desired gamerules every time.

set -euo pipefail

CONTAINER="${CONTAINER:-mc-bedrock}"

# Wait up to ~120 seconds for server readiness
for _ in {1..60}; do
  if docker exec "$CONTAINER" send-command "list" >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

# Gamerules: safe to run repeatedly
docker exec "$CONTAINER" send-command "gamerule keepInventory true" >/dev/null
docker exec "$CONTAINER" send-command "gamerule mobGriefing false"  >/dev/null
docker exec "$CONTAINER" send-command "gamerule doFireTick false"   >/dev/null
docker exec "$CONTAINER" send-command "gamerule showCoordinates true" >/dev/null

# Optional: common family-friendly toggles
# docker exec "$CONTAINER" send-command "gamerule doDaylightCycle true" >/dev/null
# docker exec "$CONTAINER" send-command "gamerule playersSleepingPercentage 1" >/dev/null

echo "[+] Gamerules applied."
