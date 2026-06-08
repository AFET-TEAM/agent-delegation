#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
if grep -RInE '\bconsole\.(log|warn|error|debug|info|table|trace|time)\b|\b(alert|confirm|prompt)[[:space:]]*\(' "$TARGET" 2>/dev/null; then
  echo "[block-console-log] BLOCKED: console/debug dialog usage detected." >&2
  exit 2
fi
exit 0
