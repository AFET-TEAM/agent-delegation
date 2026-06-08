#!/usr/bin/env bash
set -euo pipefail

PKG_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PROJ="${CURSOR_PKG_ROOT:-$PKG_ROOT}"
PASS=0
WARN=0
FAIL=0

ok()   { echo "  OK $1"; PASS=$((PASS+1)); }
warn() { echo "  WARN $1"; WARN=$((WARN+1)); }
fail() { echo "  FAIL $1"; FAIL=$((FAIL+1)); }

echo "Cursor Multi-Agent — Install Verification"
echo "=========================================="

echo ""
echo "[ Dependencies ]"
command -v python3 >/dev/null 2>&1 && ok "python3" || fail "python3 missing"
command -v node >/dev/null 2>&1 && ok "node" || warn "node missing (context-mode MCP)"
command -v jq >/dev/null 2>&1 && ok "jq" || warn "jq optional"

echo ""
echo "[ Hook Scripts ]"
HOOKS_DIR="$PROJ/.cursor/hooks"
REQUIRED=(
  block-console-log.sh block-any-type.sh block-comments.sh secret-guard.sh
  analysis-scope-guard.sh figma-standards-guard.sh pre-tool-use-write.sh
  before-shell-execution.sh before-submit-prompt.sh subagent-start.sh subagent-stop.sh
  session-end.sh git-safety-check.sh context-mode-guard.sh graphify-audit.sh
)
for h in "${REQUIRED[@]}"; do
  if [ -x "$HOOKS_DIR/$h" ]; then ok "$h"; else fail "$h"; fi
done

echo ""
echo "[ Config ]"
for f in delegation-rules.md tier-definitions.md context-budget.md model-registry.md; do
  [ -f "$PROJ/.cursor/config/$f" ] && ok "$f" || fail "$f"
done

echo ""
echo "[ Skills ]"
for s in caveman context-mode graphify clean-code test-gen; do
  [ -f "$PROJ/.cursor/skills/$s/SKILL.md" ] && ok "skill/$s" || fail "skill/$s"
done

echo ""
echo "[ Runtime ]"
python3 "$PROJ/.cursor/runtime/orchestrate.py" --plan-only "smoke test x5" >/dev/null 2>&1 && ok "orchestrate --plan-only x5" || fail "orchestrate --plan-only"
python3 "$PROJ/.cursor/scripts/delegation_plan.py" "smoke x5" >/dev/null 2>&1 && ok "delegation_plan x5" || fail "delegation_plan"
python3 "$PROJ/.cursor/scripts/prompt-router.py" "pcd smoke x3" 2>/dev/null | grep -q '"xn": "x3"' && ok "prompt-router pcd x3" || fail "prompt-router"

echo ""
echo "[ Wrappers ]"
for mode in pcd context graphify delegate review caveman; do
  "$PKG_ROOT/bin/team" "$mode" "verify $mode" >/dev/null 2>&1 && ok "team $mode (legacy)" || warn "team $mode (legacy optional)"
done

echo ""
echo "Summary: pass=$PASS warn=$WARN fail=$FAIL"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
