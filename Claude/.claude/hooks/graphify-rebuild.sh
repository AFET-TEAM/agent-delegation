#!/usr/bin/env bash
set -euo pipefail

: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)
else
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | grep -o '"path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
fi

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

case "$FILE_PATH" in
  */.claude/*)
    exit 0
    ;;
  */graphify-out/*)
    exit 0
    ;;
  *.md|*.json)
    exit 0
    ;;
esac

case "$FILE_PATH" in
  *.py|*.ts|*.tsx|*.js|*.jsx|*.java|*.kt|*.go|*.rs|*.rb|*.cs|*.cpp|*.c|*.h|*.scala|*.php)
    ;;
  *)
    exit 0
    ;;
esac

CODEBASE_ROOT=$(dirname "$FILE_PATH")

GRAPHIFY_OUT=""
SEARCH_DIR="$CODEBASE_ROOT"
for i in $(seq 1 5); do
  if [ -d "$SEARCH_DIR/graphify-out" ]; then
    GRAPHIFY_OUT="$SEARCH_DIR/graphify-out"
    break
  fi
  PARENT=$(dirname "$SEARCH_DIR")
  if [ "$PARENT" = "$SEARCH_DIR" ]; then
    break
  fi
  SEARCH_DIR="$PARENT"
done

if [ -n "$GRAPHIFY_OUT" ] && [ -f "$GRAPHIFY_OUT/graph.json" ]; then
  touch "$GRAPHIFY_OUT/.graphify-stale"
fi

exit 0
