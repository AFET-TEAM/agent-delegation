#!/usr/bin/env bash
set -euo pipefail
FILE="${1:-}"
if [ -z "$FILE" ]; then exit 0; fi
case "$FILE" in
  *.ts|*.tsx|*.js|*.jsx|*.java|*.kt|*.go|*.rs|*.py)
    ROOT="$(pwd)"
    if [ -d "$ROOT/graphify-out" ] && [ -f "$ROOT/graphify-out/graph.json" ]; then
      touch "$ROOT/graphify-out/.graphify-stale"
      echo "[graphify-rebuild] graph marked stale due to source change." >&2
    fi
    ;;
esac
exit 0
