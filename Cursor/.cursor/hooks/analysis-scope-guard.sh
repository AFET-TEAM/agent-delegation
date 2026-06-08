#!/usr/bin/env bash
set -euo pipefail
FILE="${1:-}"
if [ -z "$FILE" ]; then exit 0; fi
case "$FILE" in
  *"/.cursor/analysis/raw/"*|*"/.cursor/analysis/consolidated/"*) exit 0 ;;
  *"/.cursor/analysis/"*) echo "[analysis-scope-guard] BLOCKED: write directly inside analysis root is not allowed." >&2; exit 2 ;;
esac
exit 0
