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
  *.tsx|*.jsx)
    ;;
  *.ts)
    # For .ts files: only proceed if they import from antd or figma
    if ! echo "$CONTENT" | grep -qE "from\s+['\"]antd|from\s+['\"]figma"; then
      exit 0
    fi
    ;;
  *)
    exit 0
    ;;
esac

if [ -z "$CONTENT" ]; then
  exit 0
fi

# --- Existing checks ---

if echo "$CONTENT" | grep -qE 'style\s*=\s*\{\{'; then
  echo "BLOCKED: Inline styles (style={{}}) are prohibited. Use SCSS modules with BEM methodology or Ant Design theme tokens instead." >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '#[0-9a-fA-F]{3,8}[^a-zA-Z]'; then
  echo "BLOCKED: Hardcoded color values are prohibited. Use design tokens from _color.scss or theme.useToken() instead." >&2
  exit 2
fi

if echo "$CONTENT" | grep -qE '<div\s+onClick|<span\s+onClick|<div\s+onKeyDown'; then
  echo "BLOCKED: Interactive div/span elements are prohibited. Use semantic HTML (<button>, <a>) or Ant Design components (Button, Menu) instead." >&2
  exit 2
fi

# --- New checks (I-104) ---

# px→rem: Block CSS values with 2px+ in tsx/jsx/ts files. Allowed: 0px, 1px borders.
# Pattern matches 2-9px or 10+px to exclude 0 and 1.
if echo "$CONTENT" | grep -qE '\b([2-9]|[1-9][0-9]+)px\b'; then
  echo "BLOCKED: CSS px values (except 0px/1px) are prohibited. Convert to rem units. See .claude/rules/implementation.md" >&2
  exit 2
fi

# Ant Design mapping: warn on native HTML form elements if antd is not imported.
# Block only if antd import is missing in the file content.
if echo "$CONTENT" | grep -qE '<(button|select|input)\b'; then
  if ! echo "$CONTENT" | grep -qE "from\s+['\"]antd['\"]|from\s+['\"]antd/"; then
    echo "BLOCKED: Native HTML <button>, <select>, <input> elements detected without Ant Design import in $FILE_PATH. Use Ant Design Button, Select, Input components instead." >&2
    exit 2
  fi
fi

# Typography tokens: warn on hardcoded font properties outside design-token constants.
# Pattern catches font-size/weight/family with values not starting with a token reference ($, var, theme).
if echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*[^$v\{\s]' | grep -qvE 'font-(size|weight|family)\s*:\s*(var\(|theme\.)'; then
  if echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*[^$v\{\s]'; then
    if ! echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*(var\(|theme\.|\\$)'; then
      echo "WARNING: Hardcoded font-size/font-weight/font-family values detected in $FILE_PATH. Use design token constants (theme.useToken() or CSS variables). See .claude/rules/implementation.md" >&2
    fi
  fi
fi

# PascalCase frame names: if file imports from figma, verify React component names are PascalCase.
# Lower-priority warning only (exit 0 always).
if echo "$CONTENT" | grep -qE "from\s+['\"]figma/api"; then
  if echo "$CONTENT" | grep -qE 'const\s+[a-z][a-zA-Z0-9]*\s*=\s*\(|function\s+[a-z][a-zA-Z0-9]*\s*\('; then
    echo "WARNING: Figma-imported component names should be PascalCase in $FILE_PATH. Rename to avoid runtime issues." >&2
  fi
fi

exit 0
