#!/usr/bin/env bash
set -euo pipefail

: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)
else
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | grep -o '"path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
fi

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

case "$FILE_PATH" in
  *.md|*.json|*.sh|*.yml|*.yaml)
    exit 0
    ;;
  */.claude/*)
    exit 0
    ;;
esac

COUNTER_DIR="$CLAUDE_PROJECT_DIR/.claude/metrics"
COUNTER_FILE="$COUNTER_DIR/.edit-counter"
SESSION_LOG="$COUNTER_DIR/.session-edits-$(date +%Y%m%d).log"

mkdir -p "$COUNTER_DIR"

if [ -f "$COUNTER_FILE" ]; then
  CURRENT=$(cat "$COUNTER_FILE")
  NEXT=$((CURRENT + 1))
else
  NEXT=1
fi

echo "$NEXT" > "$COUNTER_FILE"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "$TIMESTAMP|$NEXT|$FILE_PATH" >> "$SESSION_LOG"

if [ "$NEXT" -eq 5 ]; then
  echo "INFO: 5 edits reached in this session. Review recommended before proceeding." >&2
fi

if [ "$NEXT" -eq 10 ]; then
  echo "INFO: 10 edits reached in this session. Comprehensive review strongly recommended. Consider dispatching T4 Lead Analyst for structure validation." >&2
fi

exit 0
