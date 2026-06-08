#!/usr/bin/env bash
set -euo pipefail
COMMAND="${1:-}"
if [ -z "$COMMAND" ]; then exit 0; fi
if echo "$COMMAND" | grep -Eq '\bgit (add|commit|push|pull|merge|rebase|reset|revert|stash|checkout -b|branch -d|branch -D)\b'; then
  echo "[git-safety-check] BLOCKED: explicit user git consent required." >&2
  exit 2
fi
exit 0
