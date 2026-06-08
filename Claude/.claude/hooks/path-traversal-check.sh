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

if [[ ! "$FILE_PATH" =~ \.(java|ts|js)$ ]]; then exit 0; fi

if [ -z "$CONTENT" ]; then exit 0; fi

if echo "$CONTENT" | grep -qE 'new File\([^)]*[Rr]equest\.|new File\([^)]*[Pp]aram'; then
  echo "BLOCKED [path-traversal-check]: Path traversal risk in $FILE_PATH. Validate and sanitize all file paths. See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE 'Paths\.get\([^)]*[Rr]equest\.|Paths\.get\([^)]*[Pp]aram'; then
  echo "BLOCKED [path-traversal-check]: Path traversal risk in $FILE_PATH. Validate and sanitize all file paths. See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '"\.\./'; then
  echo "BLOCKED [path-traversal-check]: Path traversal risk in $FILE_PATH. Validate and sanitize all file paths. See .claude/rules/backend-security.md" >&2
  exit 2
fi

# URL-encoded path traversal: %2e%2e/ or %2E%2E/ variants
if echo "$CONTENT" | grep -qiE '%2e%2e[/\\]'; then
  echo "BLOCKED [path-traversal-check]: URL-encoded path traversal detected in $FILE_PATH. Decode and validate all file paths. See .claude/rules/backend-security.md" >&2
  exit 2
fi

exit 0
