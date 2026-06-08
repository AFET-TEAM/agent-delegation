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

if [[ ! "$FILE_PATH" =~ \.(java|kt|ts|js)$ ]]; then exit 0; fi

if [ -z "$CONTENT" ]; then exit 0; fi

# Match both quoted and unquoted wildcard origins
if echo "$CONTENT" | grep -qE 'setAllowedOrigins\(.*["'"'"']\*["'"'"']|allowedOrigins\s*[=:]\s*.*["'"'"']\*["'"'"']|origins\s*:\s*\[["'"'"']?\*["'"'"']?\]|allowedOrigins\(\[["'"'"']\*["'"'"']\]|origins?\s*[:=]\s*["'"'"']?\*["'"'"']?'; then
  echo "BLOCKED [cors-wildcard-check]: Wildcard CORS origin (*) detected in $FILE_PATH. Explicitly list allowed origins. See .claude/rules/backend-security.md" >&2
  exit 2
fi

exit 0
