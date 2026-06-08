#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-.}"
if grep -RInE '@Autowired|@Inject[[:space:]]+private' "$TARGET" 2>/dev/null; then
  echo "[field-injection-check] BLOCKED: field injection pattern detected." >&2
  exit 2
fi
exit 0
