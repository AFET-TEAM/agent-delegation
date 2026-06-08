#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TARGET="$HOME/.local/bin"
mkdir -p "$TARGET"
ln -sf "$ROOT/bin/codex" "$TARGET/codex"
echo "Installed: $TARGET/codex -> $ROOT/bin/codex"
echo "Ensure $TARGET is in your PATH."
echo "Examples:"
echo "  codex pcd repo analizi"
echo "  codex caveman auth akisini kisalt"
echo "  codex approval-based live apply pipeline ekle x10"

echo "Optional shell integration:"
echo "  source $ROOT/.codex/runtime/shell_integration.sh"
echo "Then you can run: run "repo analizi x10""
