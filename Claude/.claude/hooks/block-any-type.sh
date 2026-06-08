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
  *.spec.*|*.test.*|*.d.ts|*.md|*.json|*.sh|*.scss|*.css|*.yml|*.yaml|*.html|*.xml|*.svg)
    exit 0
    ;;
  *.config.*|*vite.config*|*vitest.config*|*tsconfig*|*eslint*|*prettier*)
    exit 0
    ;;
esac

if [ -z "$CONTENT" ]; then
  exit 0
fi

if echo "$CONTENT" | grep -qE ':\s*any\b|as\s+any\b|<any>|<any,'; then
  echo "BLOCKED: TypeScript 'any' type is prohibited. Use 'unknown' with type narrowing, or define a proper type/interface." >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '@ts-ignore|@ts-expect-error'; then
  echo "BLOCKED: @ts-ignore and @ts-expect-error are prohibited without a documented issue reference." >&2
  exit 2
fi

exit 0
