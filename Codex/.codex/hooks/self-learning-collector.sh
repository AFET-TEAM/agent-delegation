#!/usr/bin/env bash
set -euo pipefail
FILE="${1:-unknown}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TRACK="$ROOT/metrics/rework.log"
PATTERN_DIR="$ROOT/memory/learned-patterns"
if ! mkdir -p "$PATTERN_DIR" 2>/dev/null; then
  echo "[self-learning-collector] ADVISORY: learned-patterns directory not writable; skipping persistence." >&2
  exit 0
fi
if ! touch "$TRACK" 2>/dev/null; then
  echo "[self-learning-collector] ADVISORY: metrics log not writable; skipping persistence." >&2
  exit 0
fi
printf '%s|%s
' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "$FILE" >> "$TRACK"
COUNT=$(grep -c "|$FILE$" "$TRACK" 2>/dev/null || true)
if [ "$COUNT" -ge 2 ]; then
  OUT="$PATTERN_DIR/LP-$(date +%Y-%m-%d-%H%M%S)-$(basename "$FILE" | tr ' ' '-').md"
  cat > "$OUT" <<PATTERN
---
pattern-id: $(basename "$OUT" .md)
category: general
hit-count: $COUNT
last-triggered: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
sessions-since-hit: 0
created: $(date +%Y-%m-%d)
source: automated-rework-detector
---

# Learned Pattern

## Error
Repeated edits detected for $FILE.

## Fix
Review why this file required repeated intervention and whether task split, unclear ownership, or missing validation caused churn.

## Rule
When the same file changes repeatedly in one initiative, increase review rigor and reduce ambiguity before further edits.

## Context
File: $FILE
PATTERN
fi
exit 0
