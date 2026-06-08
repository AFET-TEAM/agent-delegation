#!/usr/bin/env bash
set -euo pipefail
SCAN_ROOT="${1:-.}"
if [ -f "$SCAN_ROOT/graphify-out/.graphify-stale" ]; then
  echo "[graphify-audit] WARNING: graphify graph is marked stale." >&2
  exit 0
fi
if [ -f "$SCAN_ROOT/graphify-out/graph.json" ]; then
  MOD_TS=$(stat -f %m "$SCAN_ROOT/graphify-out/graph.json" 2>/dev/null || echo 0)
  NOW=$(date +%s)
  AGE=$((NOW - MOD_TS))
  if [ "$MOD_TS" -gt 0 ] && [ "$AGE" -gt 604800 ]; then
    echo "[graphify-audit] WARNING: graph.json older than 7 days." >&2
  fi
fi
exit 0
