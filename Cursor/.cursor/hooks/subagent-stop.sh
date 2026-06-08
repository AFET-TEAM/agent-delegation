#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_lib.sh
source "$SCRIPT_DIR/_lib.sh"
read_hook_json

pkg="$(cursor_pkg_root)"
run_root="$(ls -dt "$pkg/runtime/runs"/* 2>/dev/null | head -1 || true)"
if [ -z "$run_root" ] || [ ! -f "$run_root/manifest.json" ]; then
  printf '%s\n' '{}'
  exit 0
fi

agent_id="$(json_field .agent_id)"
next_step="$(python3 - <<'PY' "$run_root" "$agent_id"
import json, sys
from pathlib import Path
run_root, agent_id = Path(sys.argv[1]), sys.argv[2]
manifest = json.loads((run_root / 'manifest.json').read_text(encoding='utf-8'))
order = manifest.get('spawn_order', [])
try:
    idx = order.index(agent_id)
except ValueError:
    print('')
    raise SystemExit(0)
if idx + 1 < len(order):
    nxt = order[idx + 1]
    print(f'Spawn next Task from spawn-packets/{nxt}.md then collect review artifacts.')
else:
    print('All spawn packets complete. Run review chain and update session metrics.')
PY
)"

if [ -n "$next_step" ]; then
  printf '%s\n' "{\"followup_message\":\"$next_step\"}"
else
  printf '%s\n' '{}'
fi
exit 0
