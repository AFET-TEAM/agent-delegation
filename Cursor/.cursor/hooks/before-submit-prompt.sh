#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_lib.sh
source "$SCRIPT_DIR/_lib.sh"
read_hook_json

prompt="$(json_field .prompt)"
cursor_root="$(cursor_pkg_root)"
router="$cursor_root/scripts/prompt-router.py"

if [ ! -f "$router" ]; then
  printf '%s\n' '{}'
  exit 0
fi

result="$(python3 "$router" "$prompt" 2>/dev/null || echo '{}')"
state_file="$cursor_root/runtime/session-state.json"
mkdir -p "$cursor_root/runtime"
printf '%s\n' "$result" > "$state_file"

context="$(printf '%s' "$result" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("additional_context",""))' 2>/dev/null || true)"

if [ -n "$context" ]; then
  escaped="$(printf '%s' "$context" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
  printf '{"additional_context":%s}\n' "$escaped"
else
  printf '%s\n' '{}'
fi
exit 0
