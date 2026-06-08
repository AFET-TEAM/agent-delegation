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

if [[ ! "$FILE_PATH" =~ \.(ts|tsx|js|jsx|java)$ ]]; then exit 0; fi

if [ -z "$CONTENT" ]; then exit 0; fi

if echo "$CONTENT" | grep -qE 'innerHTML\s*='; then
  echo "BLOCKED [xss-prevention-check]: XSS vector detected in $FILE_PATH. Use safe DOM APIs or HtmlUtils.htmlEscape(). See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE 'dangerouslySetInnerHTML'; then
  echo "BLOCKED [xss-prevention-check]: XSS vector detected in $FILE_PATH. Use safe DOM APIs or HtmlUtils.htmlEscape(). See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '\.html\([^)]*req\.'; then
  echo "BLOCKED [xss-prevention-check]: XSS vector detected in $FILE_PATH. Use safe DOM APIs or HtmlUtils.htmlEscape(). See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE 'document\.write\('; then
  echo "BLOCKED [xss-prevention-check]: XSS vector detected in $FILE_PATH. Use safe DOM APIs or HtmlUtils.htmlEscape(). See .claude/rules/backend-security.md" >&2
  exit 2
fi

# Block any insertAdjacentHTML usage regardless of argument type
if echo "$CONTENT" | grep -qE 'insertAdjacentHTML\('; then
  echo "BLOCKED [xss-prevention-check]: insertAdjacentHTML() is prohibited in $FILE_PATH. Use textContent or safe DOM APIs instead. See .claude/rules/backend-security.md" >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '\beval\s*\(|new\s+Function\s*\('; then
  echo "BLOCKED [xss-prevention-check]: eval() / new Function() is a XSS vector in $FILE_PATH. Avoid dynamic code evaluation." >&2
  exit 2
fi

exit 0
