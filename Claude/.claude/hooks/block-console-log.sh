#!/usr/bin/env bash
set -euo pipefail

# Require CLAUDE_PROJECT_DIR
: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<<"$INPUT")
  CONTENT=$(jq -r '.tool_input.content // .tool_input.new_string // empty' <<<"$INPUT")
else
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | grep -o '"path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
  CONTENT=$(echo "$INPUT" | grep -o '"new_string"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$CONTENT" ]; then
    CONTENT=$(echo "$INPUT" | grep -o '"content"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
fi

case "$FILE_PATH" in
  *.spec.*|*.test.*|*.stories.*|*.md|*.json|*.sh|*.yml|*.yaml|*.html|*.xml|*.svg|*.css)
    exit 0
    ;;
  *.config.*|*vite.config*|*vitest.config*|*tsconfig*|*eslint*|*prettier*)
    exit 0
    ;;
esac

if [ -z "$CONTENT" ]; then
  exit 0
fi

if echo "$CONTENT" | grep -qE 'console\.(log|warn|error|debug|info|table|time|timeEnd|trace|dir|count|group|groupEnd|clear|assert|profile|profileEnd)\s*\('; then
  echo "BLOCKED: console.* statements are prohibited in production code. Use a structured logging service instead." >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '\balert\s*\(|\bconfirm\s*\(|\bprompt\s*\('; then
  echo "BLOCKED: alert(), confirm(), prompt() are prohibited. Use Ant Design Modal or notification instead." >&2
  exit 2
fi

exit 0
