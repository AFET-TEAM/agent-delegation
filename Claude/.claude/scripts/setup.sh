#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; exit 1; }

echo "Claude Code Multi-Agent System — Setup"
echo "======================================="

echo ""
echo "[ Bash Version Check ]"
if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
  warn "Bash ${BASH_VERSION:-<unknown>} detected. Bash 4+ is required for leaderboard updates."
  warn "macOS ships with Bash 3.2 (GPL-2 licensed). Install Bash 4+ via:"
  warn "  brew install bash"
  warn "  Then add /opt/homebrew/bin/bash to /etc/shells and set as default."
  warn "Without Bash 4+: leaderboard scores will NOT update. All other features work normally."
else
  ok "Bash $BASH_VERSION"
fi

if ! command -v node >/dev/null 2>&1; then
  fail "Node.js not found. Install from https://nodejs.org (v18+)"
fi
NODE_VER=$(node -e "process.stdout.write(process.version.slice(1).split('.')[0])")
[ "$NODE_VER" -ge 18 ] || fail "Node.js v18+ required (found v$NODE_VER)"
ok "Node.js v$(node --version | tr -d v)"

if ! command -v npx >/dev/null 2>&1; then
  fail "npx not found. Reinstall Node.js."
fi
ok "npx available"

echo ""
echo "Caching context-mode MCP package..."
npx --yes @context-mode/mcp@1.0.146 --version 2>/dev/null || true
ok "context-mode @1.0.146 cached"

echo ""
PYTHON_OK=false
for py in python3 python; do
  if command -v "$py" >/dev/null 2>&1; then
    PY_VER=$("$py" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    PY_MAJOR=$(echo "$PY_VER" | cut -d. -f1)
    PY_MINOR=$(echo "$PY_VER" | cut -d. -f2)
    if [ "$PY_MAJOR" -ge 3 ] && [ "$PY_MINOR" -ge 10 ]; then
      ok "Python $PY_VER"
      PYTHON_OK=true
      PYTHON_CMD="$py"
      break
    fi
  fi
done

if [ "$PYTHON_OK" = false ]; then
  warn "Python 3.10+ not found — graphify will not be available"
  warn "Install Python from https://python.org and re-run this script"
  echo ""
  echo "context-mode: ready | graphify: skipped (no Python)"
  exit 0
fi

echo ""
echo "Installing graphify..."
if command -v uv >/dev/null 2>&1; then
  uv tool install "graphifyy[all]" --quiet 2>&1 | tail -3
  ok "graphify installed via uv"
elif command -v pipx >/dev/null 2>&1; then
  pipx install "graphifyy[all]" --quiet 2>&1 | tail -3
  ok "graphify installed via pipx"
else
  "$PYTHON_CMD" -m pip install --quiet "graphifyy[all]"
  ok "graphify installed via pip"
fi

if command -v graphify >/dev/null 2>&1; then
  GRAPHIFY_VER=$(graphify --version 2>/dev/null || echo "unknown")
  ok "graphify $GRAPHIFY_VER verified"
else
  warn "graphify installed but not in PATH"
  warn "Add Python Scripts/bin directory to PATH"
fi

echo ""
echo "======================================="
ok "Setup complete"
echo ""
echo "  context-mode: /ctx in Claude Code"
echo "  graphify:     /graphify in Claude Code"
echo ""
echo "Quick test:"
echo "  npx @context-mode/mcp@1.0.146 --version"
echo "  graphify --version"
