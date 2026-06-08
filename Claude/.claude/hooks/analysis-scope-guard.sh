#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | grep -o '"path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
fi

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

case "$FILE_PATH" in
  */.claude/analysis/raw/*)
    echo "ADVISORY: Writing to analysis/raw/ — T5 Analyst is the expected writer (Orchestrator enforces tier ownership at delegation time)." >&2
    exit 0
    ;;
  */.claude/analysis/consolidated/*)
    echo "ADVISORY: Writing to analysis/consolidated/ — T4 Lead Analyst is the expected writer (Orchestrator enforces tier ownership at delegation time)." >&2
    exit 0
    ;;
  */.claude/analysis/*)
    echo "BLOCKED: Writing to analysis/ root is not allowed. Use analysis/raw/ (T5) or analysis/consolidated/ (T4) subdirectories." >&2
    exit 2
    ;;
esac

exit 0
