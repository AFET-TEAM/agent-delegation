#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
if grep -RInE 'dangerouslySetInnerHTML|innerHTML[[:space:]]*=|\beval[[:space:]]*\(' "$TARGET" 2>/dev/null; then
  echo "[xss-prevention-check] BLOCKED: unsafe HTML/eval pattern detected." >&2
  exit 2
fi
exit 0
