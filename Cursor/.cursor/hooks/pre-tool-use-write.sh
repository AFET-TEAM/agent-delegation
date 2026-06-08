#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_lib.sh
source "$SCRIPT_DIR/_lib.sh"
read_hook_json

tool_name="$(json_field .tool_name)"
path="$(json_field .tool_input.path)"
contents="$(json_field .tool_input.contents)"

case "$tool_name" in
  Write|StrReplace|Edit|ApplyPatch) ;;
  *) allow_response; exit 0 ;;
esac

if [ -z "$path" ]; then
  allow_response
  exit 0
fi

run_on_target() {
  local hook="$1"
  if [ -x "$SCRIPT_DIR/$hook" ]; then
    bash "$SCRIPT_DIR/$hook" "$path" || return $?
  fi
  return 0
}

if [ -n "$contents" ]; then
  write_temp_from_contents "$contents" "$(basename "$path")"
  for hook in block-console-log.sh block-any-type.sh block-comments.sh secret-guard.sh sql-injection-check.sh xss-prevention-check.sh path-traversal-check.sh cors-wildcard-check.sh field-injection-check.sh figma-standards-guard.sh; do
    if ! bash "$SCRIPT_DIR/$hook" "$CURSOR_HOOK_TMP" 2>/dev/null; then
      rm -f "$CURSOR_HOOK_TMP"
      deny_response "Write blocked by $hook"
      exit 2
    fi
  done
  rm -f "$CURSOR_HOOK_TMP"
fi

for hook in analysis-scope-guard.sh; do
  if ! run_on_target "$hook"; then
    deny_response "Write blocked by $hook"
    exit 2
  fi
done

allow_response
exit 0
