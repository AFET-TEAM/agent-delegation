#!/usr/bin/env bash
set -euo pipefail

: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

SENTINEL="$CLAUDE_PROJECT_DIR/.claude/metrics/.session-complete"
PATTERNS_DIR="$CLAUDE_PROJECT_DIR/.claude/memory/learned-patterns"
ARCHIVE_DIR="$PATTERNS_DIR/archive"
RULES_DIR="$CLAUDE_PROJECT_DIR/.claude/rules"
SESSION_DIR="$CLAUDE_PROJECT_DIR/.claude/memory/sessions"

mkdir -p "$ARCHIVE_DIR"

for i in 1 2 3 4 5; do
  [ -f "$SENTINEL" ] && break
  sleep 1
done

if [ ! -f "$SENTINEL" ]; then
  echo "INFO: Sentinel not found after wait; proceeding anyway." >&2
fi

LATEST_SESSION=$(ls -t "$SESSION_DIR"/session-*.md 2>/dev/null | head -1 || true)
if [ -z "$LATEST_SESSION" ]; then
  echo "INFO: No session file found; skipping pattern lifecycle." >&2
  exit 0
fi

SESSION_CONTENT=$(cat "$LATEST_SESSION")

extract_frontmatter_field() {
  local file="$1"
  local field="$2"
  grep -E "^${field}:" "$file" 2>/dev/null | head -1 | sed "s/^${field}:[[:space:]]*//" | tr -d '\r\n' || echo ""
}

update_frontmatter_field() {
  local file="$1"
  local field="$2"
  local value="$3"
  local tmpfile
  tmpfile=$(mktemp)

  if grep -qE "^${field}:" "$file"; then
    sed -E "s|^${field}:.*|${field}: ${value}|" "$file" > "$tmpfile"
  else
    awk -v f="$field" -v v="$value" '
      /^---$/ && !seen { seen=1; print; next }
      /^---$/ && seen  { print f ": " v; print; next }
      { print }
    ' "$file" > "$tmpfile"
  fi

  mv "$tmpfile" "$file"
}

extract_keyword_from_section() {
  local file="$1"
  local section="$2"
  awk -v sec="$section" '
    $0 ~ "^## " sec { in_section=1; next }
    /^## / && in_section { in_section=0 }
    in_section && NF > 0 { print; exit }
  ' "$file"
}

PROMOTED=0
ARCHIVED=0
UPDATED=0

for PATTERN_FILE in "$PATTERNS_DIR"/*.md; do
  [ -f "$PATTERN_FILE" ] || continue
  BASENAME=$(basename "$PATTERN_FILE")
  [[ "$BASENAME" == "_pattern-template.md" ]] && continue
  [[ "$BASENAME" == README* ]] && continue
  [[ "$BASENAME" == _* ]] && continue

  HIT_COUNT=$(extract_frontmatter_field "$PATTERN_FILE" "hit-count")
  [[ "$HIT_COUNT" =~ ^[0-9]+$ ]] || HIT_COUNT=0

  SESSIONS_SINCE_HIT=$(extract_frontmatter_field "$PATTERN_FILE" "sessions-since-hit")
  [[ "$SESSIONS_SINCE_HIT" =~ ^[0-9]+$ ]] || SESSIONS_SINCE_HIT=0

  KEYWORD=$(extract_keyword_from_section "$PATTERN_FILE" "Error")
  [ -z "$KEYWORD" ] && KEYWORD=$(extract_keyword_from_section "$PATTERN_FILE" "Hata")

  HIT=0
  if [ -n "$KEYWORD" ] && echo "$SESSION_CONTENT" | grep -qF "$KEYWORD" 2>/dev/null; then
    HIT=1
  fi

  if [ "$HIT" -eq 1 ]; then
    HIT_COUNT=$((HIT_COUNT + 1))
    SESSIONS_SINCE_HIT=0
    SESSION_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    update_frontmatter_field "$PATTERN_FILE" "hit-count" "$HIT_COUNT"
    update_frontmatter_field "$PATTERN_FILE" "sessions-since-hit" "$SESSIONS_SINCE_HIT"
    update_frontmatter_field "$PATTERN_FILE" "last-triggered" "$SESSION_DATE"
    UPDATED=$((UPDATED + 1))
  else
    SESSIONS_SINCE_HIT=$((SESSIONS_SINCE_HIT + 1))
    update_frontmatter_field "$PATTERN_FILE" "sessions-since-hit" "$SESSIONS_SINCE_HIT"
    UPDATED=$((UPDATED + 1))
  fi

  if [ "$HIT_COUNT" -ge 3 ]; then
    CATEGORY=$(extract_frontmatter_field "$PATTERN_FILE" "category")
    [ -z "$CATEGORY" ] && CATEGORY="general"
    CATEGORY=$(echo "$CATEGORY" | tr -cs 'a-zA-Z0-9-' '-' | sed 's/-*$//')

    LEARNED_FILE="$RULES_DIR/learned-${CATEGORY}.md"
    PATTERN_MARKER="<!-- pattern: $BASENAME -->"

    if ! grep -qF "$PATTERN_MARKER" "$LEARNED_FILE" 2>/dev/null; then
      {
        if [ ! -f "$LEARNED_FILE" ]; then
          echo "# Learned Rules: $CATEGORY"
          echo ""
          echo "Auto-promoted patterns that triggered 3+ times."
          echo ""
        fi
        echo "$PATTERN_MARKER"
        echo ""
        echo "## Pattern: $BASENAME"
        echo ""
        cat "$PATTERN_FILE"
        echo ""
      } >> "$LEARNED_FILE"
      echo "INFO: Promoted $BASENAME to $LEARNED_FILE (hit-count: $HIT_COUNT)" >&2
      PROMOTED=$((PROMOTED + 1))
    fi
  fi

  if [ "$SESSIONS_SINCE_HIT" -ge 5 ] && [ "$HIT_COUNT" -eq 0 ]; then
    mv "$PATTERN_FILE" "$ARCHIVE_DIR/"
    echo "INFO: Archived stale pattern (0 hits in $SESSIONS_SINCE_HIT sessions): $BASENAME" >&2
    ARCHIVED=$((ARCHIVED + 1))
  fi
done

echo "INFO: Pattern lifecycle complete — updated: $UPDATED, promoted: $PROMOTED, archived: $ARCHIVED" >&2

exit 0
