#!/usr/bin/env bash
set -euo pipefail

PKG_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
HOST_ROOT="${1:-$(cd "$PKG_ROOT/.." && pwd)}"

echo "[setup] Cursor package: $PKG_ROOT"
echo "[setup] Host project: $HOST_ROOT"

mkdir -p "$HOST_ROOT/.cursor"

if [ ! -f "$HOST_ROOT/AGENTS.md" ]; then
  cp "$PKG_ROOT/AGENTS.md" "$HOST_ROOT/AGENTS.md"
  echo "[setup] Installed AGENTS.md"
else
  echo "[setup] AGENTS.md exists — merge Cursor/AGENTS.md sections manually if needed"
fi

for item in hooks rules skills agents config contracts instructions checklists templates memory metrics analysis todo docs logs graphify-out runtime scripts wrappers; do
  src="$PKG_ROOT/.cursor/$item"
  dest="$HOST_ROOT/.cursor/$item"
  if [ -e "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    if [ -d "$src" ]; then
      rsync -a "$src/" "$dest/" 2>/dev/null || cp -R "$src/." "$dest/"
    else
      cp "$src" "$dest"
    fi
  fi
done

if [ -f "$PKG_ROOT/.cursor/mcp.json" ]; then
  if [ ! -f "$HOST_ROOT/.cursor/mcp.json" ]; then
    cp "$PKG_ROOT/.cursor/mcp.json" "$HOST_ROOT/.cursor/mcp.json"
  else
    echo "[setup] .cursor/mcp.json exists — merge context-mode server manually"
  fi
fi

HOOKS_JSON="$HOST_ROOT/.cursor/hooks.json"
if [ -f "$PKG_ROOT/.cursor/hooks.json" ]; then
  sed "s|Cursor/.cursor/|.cursor/|g" "$PKG_ROOT/.cursor/hooks.json" > "$HOOKS_JSON"
  chmod +x "$HOST_ROOT/.cursor/hooks/"*.sh 2>/dev/null || true
  echo "[setup] Installed hooks.json (paths -> .cursor/)"
fi

if command -v node >/dev/null 2>&1; then
  echo "[setup] Node $(node --version) — context-mode MCP available via npx"
else
  echo "[setup] WARN: Node 18+ required for context-mode MCP"
fi

if command -v graphify >/dev/null 2>&1; then
  echo "[setup] graphify CLI found"
else
  echo "[setup] WARN: graphify not installed — graphify will degrade to semantic search"
fi

echo "[setup] Done. Run: Cursor/bin/verify or $HOST_ROOT/.cursor/scripts/verify-install.sh"
