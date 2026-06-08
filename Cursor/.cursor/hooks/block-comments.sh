#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
if grep -RInE '(//|/\*|TODO|FIXME|HACK|XXX)' "$TARGET" --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' 2>/dev/null; then
  echo "[block-comments] BLOCKED: comment/TODO-like pattern detected in source files." >&2
  exit 2
fi
exit 0
