#!/usr/bin/env bash
set -euo pipefail

PROJ="${CLAUDE_PROJECT_DIR:-.}"
PASS=0
WARN=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
warn() { echo "  ! $1"; WARN=$((WARN+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Claude Code Multi-Agent System — Install Verification"
echo "======================================================="

echo ""
echo "[ Runtime Dependencies ]"

if command -v node >/dev/null 2>&1; then
  NODE_VER=$(node -e "process.stdout.write(process.version.slice(1).split('.')[0])")
  [ "$NODE_VER" -ge 18 ] && ok "Node.js $(node --version)" || fail "Node.js v18+ required (found $(node --version))"
else
  fail "Node.js not found — install from https://nodejs.org"
fi

PYTHON_FOUND=false
for py in python3 python; do
  if command -v "$py" >/dev/null 2>&1; then
    PY_VER=$("$py" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null || true)
    PY_MAJOR=$(echo "$PY_VER" | cut -d. -f1)
    PY_MINOR=$(echo "$PY_VER" | cut -d. -f2)
    if [ "${PY_MAJOR:-0}" -ge 3 ] && [ "${PY_MINOR:-0}" -ge 10 ]; then
      ok "Python $PY_VER"
      PYTHON_FOUND=true
      break
    fi
  fi
done
[ "$PYTHON_FOUND" = false ] && warn "Python 3.10+ not found — graphify will not be available"

BASH_VER="${BASH_VERSINFO[0]:-0}"
if [ "$BASH_VER" -ge 4 ]; then
  ok "Bash $BASH_VERSION"
else
  warn "Bash 4+ recommended (found $BASH_VERSION) — leaderboard updates will be skipped. Install: brew install bash"
fi

command -v jq >/dev/null 2>&1 && ok "jq $(jq --version)" || warn "jq not found — hooks use grep fallback (install for better performance)"

command -v awk >/dev/null 2>&1 && ok "awk available" || fail "awk not found — required for hook scoring calculations"

if command -v flock >/dev/null 2>&1; then
  ok "flock available (atomic leaderboard writes)"
else
  warn "flock not found — using mkdir fallback for leaderboard locking (safe but less robust)"
fi

command -v graphify >/dev/null 2>&1 && ok "graphify available" || warn "graphify not found — T5 analysis will use direct file reads. Install: uv tool install 'graphifyy[all]'"

echo ""
echo "[ Hook Files ]"

HOOKS=(
  block-any-type.sh block-comments.sh block-console-log.sh secret-guard.sh
  analysis-scope-guard.sh figma-standards-guard.sh sql-injection-check.sh
  xss-prevention-check.sh path-traversal-check.sh cors-wildcard-check.sh
  field-injection-check.sh git-safety-check.sh context-mode-guard.sh
  review-tracker.sh self-learning-collector.sh graphify-rebuild.sh
  update-leaderboard.sh pattern-lifecycle.sh graphify-audit.sh
)
HOOKS_DIR="$PROJ/.claude/hooks"
for h in "${HOOKS[@]}"; do
  if [ -f "$HOOKS_DIR/$h" ]; then
    [ -x "$HOOKS_DIR/$h" ] && ok "$h" || fail "$h exists but not executable — run: chmod +x $HOOKS_DIR/$h"
  else
    fail "$h missing from $HOOKS_DIR"
  fi
done

echo ""
echo "[ Config Files ]"

JSON_CONFIGS=(
  ".claude/config/context-budget.json"
  ".claude/settings.json"
)
for f in "${JSON_CONFIGS[@]}"; do
  FPATH="$PROJ/$f"
  if [ -f "$FPATH" ]; then
    jq . "$FPATH" >/dev/null 2>&1 && ok "$f — valid JSON" || fail "$f — invalid JSON (run: jq . $FPATH)"
  else
    fail "$f missing"
  fi
done

MD_CONFIGS=(
  ".claude/config/tier-definitions.md"
  ".claude/config/context-budget.md"
  ".claude/config/hook-registry.md"
  ".claude/config/name-pool.md"
  ".claude/config/model-registry.md"
  ".claude/config/delegation-rules.md"
  ".claude/config/task-assignment-matrix.md"
)
for f in "${MD_CONFIGS[@]}"; do
  FPATH="$PROJ/$f"
  [ -f "$FPATH" ] && ok "$f" || fail "$f missing"
done

echo ""
echo "[ Metrics & Memory Directories ]"

DIRS=(
  ".claude/metrics"
  ".claude/memory/sessions"
  ".claude/memory/learned-patterns"
  ".claude/analysis/raw"
  ".claude/analysis/consolidated"
  ".claude/docs"
  ".claude/scripts"
)
for d in "${DIRS[@]}"; do
  [ -d "$PROJ/$d" ] && ok "$d/" || warn "$d/ not found — will be created on first use"
done

[ -f "$PROJ/.claude/metrics/fallback-log.md" ] && ok ".claude/metrics/fallback-log.md" || warn ".claude/metrics/fallback-log.md missing — run improvement plan P0.1 to create"

echo ""
echo "======================================================="
echo "Results: $PASS passed | $WARN warnings | $FAIL failed"
if [ "$FAIL" -gt 0 ]; then
  echo "RESULT: FAIL — $FAIL critical issue(s) must be resolved"
  exit 1
else
  echo "RESULT: PASS — system ready (review $WARN warning(s) above)"
  exit 0
fi
