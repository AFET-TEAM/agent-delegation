#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS="$ROOT/hooks"
PROMPT="${*:-}"

if [ -z "$PROMPT" ]; then
  echo "Usage: .cursor/wrappers/context-mode-wrapper.sh '<prompt>'" >&2
  exit 2
fi

printf '[wrapper] mode=context-mode\n'
printf '[wrapper] repo_root=%s\n' "$ROOT"
printf '[wrapper] prompt=%s\n' "$PROMPT"

bash "$HOOKS/context-mode-guard.sh" "$PROMPT" || {
  code=$?
  echo "[wrapper] blocked by context-mode-guard.sh (exit=$code)" >&2
  exit "$code"
}

bash "$HOOKS/graphify-audit.sh" "$ROOT" || true
bash "$HOOKS/git-safety-check.sh" "$PROMPT" || {
  code=$?
  echo "[wrapper] blocked by git-safety-check.sh (exit=$code)" >&2
  exit "$code"
}

cat <<EOF
[wrapper] Context Mode preflight complete.
[wrapper] Expectations:
- narrow with search first
- avoid broad recursive reads
- prefer summaries over raw dumps
- use Graphify only as a narrowing aid
- surface fallback/review/risk clearly

[wrapper] Recommended operator prompt:
/context-mode $PROMPT
EOF
