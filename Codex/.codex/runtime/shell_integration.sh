# shellcheck shell=bash
# Source this file from your shell rc to enable prompt-first Codex routing.
# Example:
#   source /absolute/path/to/Codex/.codex/runtime/shell_integration.sh

_codex_repo_root() {
  if [ -n "${CODEX_REPO_ROOT:-}" ] && [ -d "$CODEX_REPO_ROOT" ]; then
    printf '%s\n' "$CODEX_REPO_ROOT"
    return 0
  fi
  local start="${PWD}"
  while [ "$start" != "/" ]; do
    if [ -f "$start/README.md" ] && [ -d "$start/.codex" ] && [ -x "$start/bin/codex" ]; then
      printf '%s\n' "$start"
      return 0
    fi
    start="$(dirname "$start")"
  done
  return 1
}

_codex_should_route() {
  case "$1" in
    pcd\ *|context\ *|graphify\ *|caveman\ *|review\ *|delegate\ *|apply\ *|rollback\ *|git\ *) return 0 ;;
    *\ x2|*\ x3|*\ x4|*\ x5|*\ x7|*\ x10|x2|x3|x4|x5|x7|x10) return 0 ;;
    *) return 1 ;;
  esac
}

codex_prompt() {
  local root
  root="$(_codex_repo_root)" || { echo "[codex] repo root not found" >&2; return 1; }
  CODEX_REPO_ROOT="$root" "$root/bin/codex" "$@"
}

# Optional convenience aliases
alias pcd='codex_prompt pcd'
alias context='codex_prompt context'
alias graphify='codex_prompt graphify'
alias caveman='codex_prompt caveman'
alias review='codex_prompt review'

# Main prompt-first function.
# Usage examples after sourcing:
#   run "repo analizi x10"
#   run "pcd repo analizi"
#   run "caveman auth akis ozeti"
run() {
  local prompt="$*"
  if [ -z "$prompt" ]; then
    echo "Usage: run \"<prompt>\"" >&2
    return 2
  fi
  if ! _codex_should_route "$prompt"; then
    echo "[codex] prompt not routed. Add a keyword like pcd/context/graphify/caveman/review or include xN." >&2
    return 2
  fi
  codex_prompt "$prompt"
}
