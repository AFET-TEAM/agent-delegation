#!/usr/bin/env bash
set -euo pipefail
FILE="${1:-unknown}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$ROOT/metrics/edit-counts.log"
if ! touch "$LOG" 2>/dev/null; then
  echo "[review-tracker] ADVISORY: metrics log not writable in current environment; skipping persistence." >&2
  exit 0
fi
printf '%s|%s
' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "$FILE" >> "$LOG"
COUNT=$(grep -c "|$FILE$" "$LOG" 2>/dev/null || true)
if [ "$COUNT" -ge 5 ]; then
  echo "[review-tracker] NOTICE: $FILE edited $COUNT times. Review for churn/rework." >&2
fi
exit 0
