#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/memory/learned-patterns"
ARCHIVE="$DIR/archive"
if ! mkdir -p "$ARCHIVE" 2>/dev/null; then
  echo "[pattern-lifecycle] ADVISORY: archive directory not writable; skipping lifecycle persistence." >&2
  exit 0
fi
for f in "$DIR"/*.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  if [ "$base" = "_pattern-template.md" ]; then continue; fi
  hits=$(grep -E '^hit-count:' "$f" | awk '{print $2}' || echo 0)
  if [ "${hits:-0}" = "0" ]; then
    cp "$f" "$ARCHIVE/$base" 2>/dev/null || true
  fi
done
echo "[pattern-lifecycle] lifecycle scan complete. Archive: $ARCHIVE" >&2
exit 0
