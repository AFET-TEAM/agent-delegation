#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_lib.sh
source "$SCRIPT_DIR/_lib.sh"
read_hook_json

subagent_type="$(json_field .subagent_type)"
tier="$(json_field .metadata.tier)"
if [ -z "$tier" ]; then
  case "$subagent_type" in
    explore) tier="T5" ;;
    shell) tier="T2" ;;
    *) tier="T3" ;;
  esac
fi

msg="Subagent tier=${tier} type=${subagent_type}. Respect file ownership in Cursor/.cursor/config and analysis scope rules."
printf '%s\n' "{\"permission\":\"allow\",\"agent_message\":\"$msg\"}"
exit 0
