#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
if grep -RInE 'Access-Control-Allow-Origin.*\*|origin[[:space:]]*:[[:space:]]*["'"'"']\*["'"'"']' "$TARGET" 2>/dev/null; then
  echo "[cors-wildcard-check] BLOCKED: wildcard CORS pattern detected." >&2
  exit 2
fi
exit 0
