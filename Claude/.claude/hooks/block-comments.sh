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
  *.md|*.json|*.sh|*.yml|*.yaml|*.html|*.xml|*.svg|*.css)
    exit 0
    ;;
  *.spec.*|*.test.*|*.stories.*|*.config.*|*vite.config*|*vitest.config*|*tsconfig*|*eslint*|*prettier*)
    exit 0
    ;;
esac

if [ -z "$CONTENT" ]; then
  exit 0
fi

CLEANED=$(echo "$CONTENT" \
  | sed 's|https\?://[^ ]*||g' \
  | sed 's|/\*\*.*\*/||g' \
  | sed 's|eslint-disable[^ ]*||g' \
  | sed 's|prettier-ignore||g' \
  | sed 's|@ts-expect-error.*||g' \
  | sed 's|#!.*||g' \
  | sed 's|// *region\b.*||g' \
  | sed 's|// *endregion\b.*||g' \
)

# Detect inline comments but skip occurrences inside double-quoted strings
# Strategy: match // that is not preceded by a pattern of characters consistent with being inside a string.
# We detect lines where // appears outside of quoted context by checking the line does not have
# an odd number of double-quotes before the //.
if echo "$CLEANED" | grep -E '^\s*//[^/]|[^:]\s*//\s+[A-Za-z]' | grep -Ev '^[^"]*"[^"]*"[^"]*//|^[^"]*"[^"]*//[^"]*"' | grep -qE '^\s*//[^/]|[^:]\s*//\s+[A-Za-z]'; then
  echo "BLOCKED: Inline comments (//) are prohibited. Code must be self-documenting through clear naming. Remove the comment and make the code intention-revealing." >&2
  exit 2
fi

if echo "$CLEANED" | grep -qE '/\*[^*]' | grep -qvE '/\*\*'; then
  echo "BLOCKED: Block comments (/* */) are prohibited. Only JSDoc (/** */) on exported interfaces is allowed." >&2
  exit 2
fi

if echo "$CONTENT" | grep -qiE '\bTODO\b|\bFIXME\b|\bHACK\b|\bXXX\b'; then
  echo "BLOCKED: TODO/FIXME/HACK/XXX comments are prohibited. Track issues in your issue tracker, not in code." >&2
  exit 2
fi

exit 0
