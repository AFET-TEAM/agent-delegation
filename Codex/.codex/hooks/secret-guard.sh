#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
PATTERN='(api[_-]?key|secret|token|password|client[_-]?secret)\s*[:=]\s*["'"'"'][^"'"'"']+["'"'"']'
if grep -RInE "$PATTERN" "$TARGET" 2>/dev/null; then
  echo "[secret-guard] BLOCKED: possible hardcoded secret pattern found." >&2
  exit 2
fi
exit 0
