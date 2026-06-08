#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
if grep -RInE '(SELECT|INSERT|UPDATE|DELETE).*(\+|\$\{|%s)' "$TARGET" 2>/dev/null; then
  echo "[sql-injection-check] WARNING/BLOCK: possible SQL string concatenation pattern detected." >&2
  exit 2
fi
exit 0
