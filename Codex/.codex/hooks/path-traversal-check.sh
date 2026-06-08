#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
if grep -RInE '(join|resolve)[[:space:]]*\(.*(req\.|request\.|input|param|query)' "$TARGET" 2>/dev/null; then
  echo "[path-traversal-check] WARNING/BLOCK: possible untrusted path composition detected." >&2
  exit 2
fi
exit 0
