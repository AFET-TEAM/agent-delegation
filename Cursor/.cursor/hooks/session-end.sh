#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=_lib.sh
source "$SCRIPT_DIR/_lib.sh"
PKG="$(cursor_pkg_root)"
bash "$SCRIPT_DIR/update-leaderboard.sh" || true
bash "$SCRIPT_DIR/pattern-lifecycle.sh" || true
bash "$SCRIPT_DIR/graphify-audit.sh" "$PKG" || true
exit 0
