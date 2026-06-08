#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_lib.sh
source "$SCRIPT_DIR/_lib.sh"
read_hook_json

path="$(json_field .tool_input.path)"
if [ -n "$path" ] && [ -f "$path" ]; then
  bash "$SCRIPT_DIR/review-tracker.sh" "$path" || true
  bash "$SCRIPT_DIR/self-learning-collector.sh" "$path" || true
  bash "$SCRIPT_DIR/graphify-rebuild.sh" "$(cursor_pkg_root)" || true
fi

printf '%s\n' '{}'
exit 0
