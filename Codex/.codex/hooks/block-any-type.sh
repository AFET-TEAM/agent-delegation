#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
if grep -RInE '(:[[:space:]]*any\b|<any>|\bany\[\]|@ts-ignore|@ts-expect-error)' "$TARGET" 2>/dev/null; then
  echo "[block-any-type] BLOCKED: any/@ts-ignore pattern detected." >&2
  exit 2
fi
exit 0
