#!/usr/bin/env bash
cursor_pkg_root() {
  if [ -n "${CURSOR_PKG_ROOT:-}" ]; then
    printf '%s' "$CURSOR_PKG_ROOT"
    return 0
  fi
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  printf '%s' "$(cd "$script_dir/.." && pwd)"
}

cursor_host_root() {
  if [ -n "${CURSOR_HOST_ROOT:-}" ]; then
    printf '%s' "$CURSOR_HOST_ROOT"
    return 0
  fi
  local pkg
  pkg="$(cursor_pkg_root)"
  if [ -d "$pkg/../../.git" ] || [ -f "$pkg/../../package.json" ]; then
    printf '%s' "$(cd "$pkg/../.." && pwd)"
    return 0
  fi
  printf '%s' "$(cd "$pkg/.." && pwd)"
}

read_hook_json() {
  HOOK_JSON="$(cat)"
  export HOOK_JSON
}

json_field() {
  local field="$1"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$HOOK_JSON" | jq -r "$field // empty"
    return 0
  fi
  python3 - <<'PY' "$field"
import json, os, sys
field = sys.argv[1]
data = json.loads(os.environ.get("HOOK_JSON", "{}"))
parts = field.split(".")
cur = data
for part in parts:
    if isinstance(cur, dict):
        cur = cur.get(part, "")
    else:
        cur = ""
        break
print(cur if cur is not None else "")
PY
}

write_temp_from_contents() {
  local contents="$1"
  local suffix="${2:-tmp}"
  CURSOR_HOOK_TMP="$(mktemp "/tmp/cursor-hook-XXXXXX.${suffix}")"
  printf '%s' "$contents" > "$CURSOR_HOOK_TMP"
  export CURSOR_HOOK_TMP
}

allow_response() {
  printf '%s\n' '{"permission":"allow"}'
}

deny_response() {
  local message="$1"
  printf '%s\n' "{\"permission\":\"deny\",\"user_message\":\"$message\",\"agent_message\":\"$message\"}"
}
