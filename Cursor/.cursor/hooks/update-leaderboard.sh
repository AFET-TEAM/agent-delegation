#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LB="$ROOT/metrics/leaderboard.md"
LOG="$ROOT/metrics/.leaderboard-update.log"
if [ ! -f "$LB" ]; then
  echo "[update-leaderboard] leaderboard file missing." >&2
  exit 0
fi
if ! touch "$LOG" 2>/dev/null; then
  echo "[update-leaderboard] ADVISORY: update log not writable; skipping persistence." >&2
  exit 0
fi
printf '%s leaderboard refresh placeholder
' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$LOG"
echo "[update-leaderboard] leaderboard update placeholder recorded." >&2
exit 0
