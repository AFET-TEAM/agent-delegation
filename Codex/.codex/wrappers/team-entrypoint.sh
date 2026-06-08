#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS="$ROOT/hooks"
LOG_DIR="$ROOT/logs"
LOG_FILE="$LOG_DIR/wrapper-usage.log"
METRICS_FILE="$ROOT/metrics/wrapper-mode-counts.md"
STRICT_MODE="${CODEX_STRICT_DELEGATE:-0}"
MODE="${1:-}"
shift || true
PROMPT="${*:-}"
TS="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

mkdir -p "$LOG_DIR" 2>/dev/null || true
mkdir -p "$ROOT/metrics" 2>/dev/null || true

log_event() {
  printf '%s|mode=%s|prompt=%s\n' "$TS" "$MODE" "$PROMPT" >> "$LOG_FILE" 2>/dev/null || true
}

update_metrics() {
  python3 - <<PY2 2>/dev/null || true
from collections import Counter
from pathlib import Path
log = Path(r"$LOG_FILE")
out = Path(r"$METRICS_FILE")
if not log.exists():
    raise SystemExit(0)
counts = Counter()
for line in log.read_text(encoding='utf-8').splitlines():
    parts = line.split('|')
    for p in parts[1:]:
        if p.startswith('mode='):
            counts[p.split('=',1)[1]] += 1
lines = ['# Wrapper Mode Counts', '', '| Mode | Count |', '|---|---:|']
for mode, count in sorted(counts.items()):
    lines.append(f'| {mode} | {count} |')
out.write_text('\\n'.join(lines), encoding='utf-8')
PY2
}

lint_delegate_prompt() {
  case "$PROMPT" in
    *x2|*x3|*x4|*x5|*x7|*x10) return 0 ;;
    *)
      if [ "$STRICT_MODE" = "1" ]; then
        echo "[wrapper] BLOCKED: delegate prompt missing explicit xN suffix and strict mode is enabled." >&2
        exit 2
      fi
      echo "[wrapper] ADVISORY: delegate prompt has no explicit xN suffix; recommended form is '/delegate [task] xN'." >&2
      return 0
      ;;
  esac
}

if [ -z "$MODE" ] || [ -z "$PROMPT" ]; then
  cat >&2 <<EOF
Usage:
  ./bin/team pcd "<prompt>"
  ./bin/team context "<prompt>"
  ./bin/team graphify "<prompt>"
  ./bin/team delegate "<prompt>"
  ./bin/team review "<prompt>"
  ./bin/team caveman "<prompt>"
EOF
  exit 2
fi

printf '[wrapper] team-mode=%s\n' "$MODE"
printf '[wrapper] prompt=%s\n' "$PROMPT"

bash "$HOOKS/git-safety-check.sh" "$PROMPT" || { code=$?; echo "[wrapper] blocked by git-safety-check.sh (exit=$code)" >&2; exit "$code"; }

case "$MODE" in
  pcd)
    bash "$HOOKS/context-mode-guard.sh" "$PROMPT" || { code=$?; echo "[wrapper] blocked by context-mode-guard.sh (exit=$code)" >&2; exit "$code"; }
    log_event; update_metrics
    cat <<EOF
[wrapper] Recommended operator prompt:
/pcd $PROMPT
EOF
    ;;
  context)
    bash "$HOOKS/context-mode-guard.sh" "$PROMPT" || { code=$?; echo "[wrapper] blocked by context-mode-guard.sh (exit=$code)" >&2; exit "$code"; }
    log_event; update_metrics
    cat <<EOF
[wrapper] Recommended operator prompt:
/context-mode $PROMPT
EOF
    ;;
  graphify)
    bash "$HOOKS/context-mode-guard.sh" "$PROMPT" || { code=$?; echo "[wrapper] blocked by context-mode-guard.sh (exit=$code)" >&2; exit "$code"; }
    bash "$HOOKS/graphify-audit.sh" "$ROOT" || true
    log_event; update_metrics
    cat <<EOF
[wrapper] Recommended operator prompt:
/context-mode /graphify $PROMPT
EOF
    ;;
  delegate)
    bash "$HOOKS/context-mode-guard.sh" "$PROMPT" || { code=$?; echo "[wrapper] blocked by context-mode-guard.sh (exit=$code)" >&2; exit "$code"; }
    bash "$HOOKS/graphify-audit.sh" "$ROOT" || true
    lint_delegate_prompt
    log_event; update_metrics
    cat <<EOF
[wrapper] Recommended operator prompt:
/pcd /delegate $PROMPT
EOF
    echo
    python3 "$ROOT/scripts/delegation_plan.py" "$PROMPT"
    echo
    echo "[wrapper] launching local multi-agent runtime"
    python3 "$ROOT/runtime/orchestrate.py" "$PROMPT"
    ;;
  review)
    log_event; update_metrics
    cat <<EOF
[wrapper] Recommended operator prompt:
/review $PROMPT
EOF
    ;;
  caveman)
    log_event; update_metrics
    cat <<EOF
[wrapper] Recommended operator prompt:
/caveman $PROMPT
EOF
    ;;
  *)
    echo "Unknown mode: $MODE" >&2
    exit 2
    ;;
esac
