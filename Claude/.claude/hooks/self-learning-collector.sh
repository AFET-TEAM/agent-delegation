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

TRACKER_DIR="$CLAUDE_PROJECT_DIR/.claude/metrics"
EDIT_LOG="$TRACKER_DIR/.edit-log"

mkdir -p "$TRACKER_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BASENAME=$(basename "$FILE_PATH")

echo "$TIMESTAMP|$BASENAME|$FILE_PATH" >> "$EDIT_LOG"

EDIT_COUNT=$(grep -c "|$BASENAME|" "$EDIT_LOG" 2>/dev/null || echo "0")

if [ "$EDIT_COUNT" -ge 2 ]; then
  PATTERNS_DIR="$CLAUDE_PROJECT_DIR/.claude/memory/learned-patterns"
  mkdir -p "$PATTERNS_DIR"

  PATTERN_ID="LP-$(date +%Y%m%d%H%M%S)"
  PATTERN_FILE="$PATTERNS_DIR/$PATTERN_ID.md"

  if [ ! -f "$PATTERN_FILE" ]; then
    cat > "$PATTERN_FILE" << PATTERN_EOF
---
pattern-id: $PATTERN_ID
date: $TIMESTAMP
agent-tier: unknown
category: code-quality
severity: minor
hit-count: 0
last-triggered: null
sessions-since-hit: 0
---

## Error
Repeated edits detected in $BASENAME ($EDIT_COUNT edits).

## Fix
File: $FILE_PATH
Review changes made to this file and identify the root cause of repeated edits.

## Rule
Verify that changes to this file are complete and correct on the first attempt to avoid rework cycles.

## Context
Auto-detected — file edited $EDIT_COUNT times in this session.
PATTERN_EOF
    echo "INFO: Self-learning pattern recorded ($PATTERN_ID). File $BASENAME edited $EDIT_COUNT times — review for recurring mistakes." >&2
  fi
fi

exit 0
