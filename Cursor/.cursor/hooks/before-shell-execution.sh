#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_lib.sh
source "$SCRIPT_DIR/_lib.sh"
read_hook_json

command="$(json_field .command)"
if [ -z "$command" ]; then
  allow_response
  exit 0
fi

if ! bash "$SCRIPT_DIR/git-safety-check.sh" "$command"; then
  deny_response "Shell command blocked by git-safety-check"
  exit 2
fi

if ! bash "$SCRIPT_DIR/context-mode-guard.sh" "$command"; then
  deny_response "Shell command blocked by context-mode-guard"
  exit 2
fi

allow_response
exit 0
