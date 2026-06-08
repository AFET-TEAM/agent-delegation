#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS="$ROOT/hooks"
PROMPT="${*:-}"
if [ -z "$PROMPT" ]; then
  echo "Usage: .codex/wrappers/context-graphify-wrapper.sh '<prompt>'" >&2
  exit 2
fi
printf '[wrapper] mode=context+graphify\n'
printf '[wrapper] repo_root=%s\n' "$ROOT" 
printf '[wrapper] prompt=%s\n' "$PROMPT" 

bash "$HOOKS/context-mode-guard.sh" "$PROMPT" || { code=$?; echo "[wrapper] blocked by context-mode-guard.sh (exit=$code)" >&2; exit "$code"; }
bash "$HOOKS/graphify-audit.sh" "$ROOT" || true
bash "$HOOKS/git-safety-check.sh" "$PROMPT" || { code=$?; echo "[wrapper] blocked by git-safety-check.sh (exit=$code)" >&2; exit "$code"; }

cat <<EOF
[wrapper] Context+Graphify preflight complete.
[wrapper] Expectations:
- narrow with search first
- use Graphify only to narrow hotspots
- avoid broad recursive reads
- prefer summary-first analysis
- verify critical claims on real files

[wrapper] Recommended operator prompt:
/context-mode /graphify $PROMPT
EOF
