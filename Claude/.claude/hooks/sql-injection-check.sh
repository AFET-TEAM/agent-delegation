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

if [[ ! "$FILE_PATH" =~ \.(java|ts|js|kt)$ ]]; then exit 0; fi

if [ -z "$CONTENT" ]; then exit 0; fi

if echo "$CONTENT" | grep -qE '"(SELECT|INSERT|UPDATE|DELETE|WHERE|FROM|JOIN|UNION)[^"]*"\s*\+\s*[a-zA-Z]|[a-zA-Z]\s*\+\s*"[^"]*(WHERE|FROM|JOIN|UNION|INTO)[^"]*"'; then
  echo "BLOCKED [sql-injection-check]: SQL string concatenation detected in $FILE_PATH. Use parameterized queries only. See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE 'String\.format\(.*SELECT|String\.format\(.*INSERT|String\.format\(.*UPDATE|String\.format\(.*DELETE'; then
  echo "BLOCKED [sql-injection-check]: SQL string concatenation detected in $FILE_PATH. Use parameterized queries only. See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '"SELECT.*"\s*\+|"INSERT.*"\s*\+|"UPDATE.*"\s*\+|"DELETE.*"\s*\+'; then
  echo "BLOCKED [sql-injection-check]: SQL string concatenation detected in $FILE_PATH. Use parameterized queries only. See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '`[^`]*(SELECT|INSERT|UPDATE|DELETE|WHERE|FROM)[^`]*\$\{'; then
  echo "BLOCKED [sql-injection-check]: SQL injection risk — template literal with variable substitution in $FILE_PATH. Use parameterized queries only." >&2
  exit 2
fi

exit 0
