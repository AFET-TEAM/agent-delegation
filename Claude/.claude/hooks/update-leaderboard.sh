#!/usr/bin/env bash
set -euo pipefail

: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

# Require Bash 4+ for associative arrays (macOS default is 3.2 — install via `brew install bash`)
if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "INFO: update-leaderboard.sh requires Bash 4+. macOS default is 3.2 — install via 'brew install bash' and update shebang to /opt/homebrew/bin/bash. Skipping leaderboard update." >&2
  exit 0
fi

SESSION_DIR="$CLAUDE_PROJECT_DIR/.claude/memory/sessions"
LEADERBOARD="$CLAUDE_PROJECT_DIR/.claude/metrics/leaderboard.md"
NAMEPOOL="$CLAUDE_PROJECT_DIR/.claude/config/name-pool.md"
SENTINEL="$CLAUDE_PROJECT_DIR/.claude/metrics/.session-complete"
LOCKFILE="$CLAUDE_PROJECT_DIR/.claude/metrics/.leaderboard.lock"

mkdir -p "$CLAUDE_PROJECT_DIR/.claude/metrics"

LATEST_SESSION=$(ls -t "$SESSION_DIR"/session-*.md 2>/dev/null | head -1 || true)
if [ -z "$LATEST_SESSION" ]; then
  echo "INFO: No session file found; skipping leaderboard update." >&2
  exit 0
fi

if command -v flock >/dev/null 2>&1; then
  exec 200>"$LOCKFILE"
  flock -n 200 || { echo "INFO: Leaderboard locked by another process; skipping." >&2; exit 0; }
else
  # macOS fallback: mkdir-based lock (atomic on POSIX filesystems)
  LOCKDIR="${LOCKFILE}.d"
  if ! mkdir "$LOCKDIR" 2>/dev/null; then
    echo "INFO: Leaderboard locked (mkdir fallback); skipping." >&2
    exit 0
  fi
  trap 'rmdir "$LOCKDIR" 2>/dev/null || true' EXIT
fi

extract_agent_performance() {
  local session_file="$1"
  awk '
    /^## Agent Performance/ { in_section=1; next }
    /^## / && in_section { in_section=0 }
    in_section { print }
  ' "$session_file"
}

compute_tier_multiplier() {
  local score="$1"
  if [ "$score" -ge 50 ]; then
    echo "2.0"
  elif [ "$score" -ge 20 ]; then
    echo "1.5"
  elif [ "$score" -ge 0 ]; then
    echo "1.0"
  elif [ "$score" -ge -20 ]; then
    echo "0.8"
  else
    echo "0.5"
  fi
}

score_tier_label() {
  local score="$1"
  if [ "$score" -ge 50 ]; then
    echo "S"
  elif [ "$score" -ge 20 ]; then
    echo "A"
  elif [ "$score" -ge 0 ]; then
    echo "B"
  elif [ "$score" -ge -20 ]; then
    echo "C"
  else
    echo "D"
  fi
}

PERF_SECTION=$(extract_agent_performance "$LATEST_SESSION")

declare -A SCORE_DELTAS
declare -A TASK_STATUS
declare -A TASK_REVIEW

while IFS= read -r line; do
  [[ "$line" != "|"* ]] && continue
  [[ "$line" == *"---"* ]] && continue
  [[ "$line" == *"Agent"*"Tier"* ]] && continue
  [[ "$line" == *"Name"*"Tier"* ]] && continue

  NAME=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $2); print $2}')
  STATUS=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $5); print $5}')
  REVIEW=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $6); print $6}')
  REVISIONS=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $8); print $8}')

  [ -z "$NAME" ] && continue
  [[ "$NAME" == *"---"* ]] && continue

  DELTA=0

  case "$STATUS" in
    completed)  DELTA=$((DELTA + 5)) ;;
    failed)     DELTA=$((DELTA - 5)) ;;
  esac

  case "$REVIEW" in
    first-pass)   DELTA=$((DELTA + 3)) ;;
    second-pass)  DELTA=$((DELTA + 1)) ;;
    "3+-rounds")  DELTA=$((DELTA - 3)) ;;
  esac

  if [[ "$REVISIONS" =~ ^[0-9]+$ ]] && [ "$REVISIONS" -ge 3 ]; then
    DELTA=$((DELTA - 3))
  fi

  SCORE_DELTAS["$NAME"]=$((${SCORE_DELTAS["$NAME"]:-0} + DELTA))
  TASK_STATUS["$NAME"]="${STATUS:-unknown}"
  TASK_REVIEW["$NAME"]="${REVIEW:-unknown}"
done <<< "$PERF_SECTION"

if [ ${#SCORE_DELTAS[@]} -eq 0 ]; then
  echo "INFO: No agent performance rows found in session; skipping leaderboard update." >&2
  touch "$SENTINEL"
  exit 0
fi

SESSION_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_ID=$(basename "$LATEST_SESSION" .md)

{
  echo ""
  echo "### Session End: $SESSION_DATE ($SESSION_ID)"
  echo ""
  echo "| Name | Score Delta | Status | Review |"
  echo "|------|-------------|--------|--------|"
  for NAME in "${!SCORE_DELTAS[@]}"; do
    DELTA="${SCORE_DELTAS[$NAME]}"
    PREFIX=""
    [ "$DELTA" -gt 0 ] && PREFIX="+"
    echo "| $NAME | ${PREFIX}${DELTA} | ${TASK_STATUS[$NAME]:-unknown} | ${TASK_REVIEW[$NAME]:-unknown} |"
  done
} >> "$LEADERBOARD"

update_namepool_scores() {
  local tmpfile
  tmpfile=$(mktemp)

  while IFS= read -r line; do
    MATCHED=0
    for NAME in "${!SCORE_DELTAS[@]}"; do
      if echo "$line" | grep -qF "| $NAME |"; then
        OLD_SCORE=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $3); print $3}')
        OLD_SESSIONS=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $4); print $4}')
        if [[ "$OLD_SCORE" =~ ^-?[0-9]+$ ]]; then
          NEW_SCORE=$((OLD_SCORE + SCORE_DELTAS[$NAME]))
          NEW_SESSIONS=$((${OLD_SESSIONS:-0} + 1))
          echo "$line" | awk -F'|' -v ns="$NEW_SCORE" -v nsess="$NEW_SESSIONS" '{
            OFS="|"
            $3=" " ns " "
            $4=" " nsess " "
            print
          }' >> "$tmpfile"
          MATCHED=1
        fi
        break
      fi
    done
    [ "$MATCHED" -eq 0 ] && echo "$line" >> "$tmpfile"
  done < "$NAMEPOOL"

  mv "$tmpfile" "$NAMEPOOL"
}

update_leaderboard_scores() {
  local tmpfile
  tmpfile=$(mktemp)

  while IFS= read -r line; do
    MATCHED=0
    for NAME in "${!SCORE_DELTAS[@]}"; do
      if echo "$line" | grep -qF "| $NAME |"; then
        OLD_SCORE=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $3); print $3}')
        OLD_SESSIONS=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $5); print $5}')
        OLD_TASKS=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $6); print $6}')
        if [[ "$OLD_SCORE" =~ ^-?[0-9]+$ ]]; then
          NEW_SCORE=$((OLD_SCORE + SCORE_DELTAS[$NAME]))
          NEW_SESSIONS=$((${OLD_SESSIONS:-0} + 1))
          NEW_TASKS=$((${OLD_TASKS:-0} + 1))
          NEW_TIER=$(score_tier_label "$NEW_SCORE")
          TASK_OK="${TASK_STATUS[$NAME]:-unknown}"
          if [ "$TASK_OK" = "completed" ]; then
            SR_NUM=$((NEW_TASKS > 0 ? 100 : 0))
          else
            SR_NUM=0
          fi
          echo "$line" | awk -F'|' -v ns="$NEW_SCORE" -v nt="$NEW_TIER" -v nsess="$NEW_SESSIONS" -v ntasks="$NEW_TASKS" '{
            OFS="|"
            $3=" " ns " "
            $4=" " nt " "
            $5=" " nsess " "
            $6=" " ntasks " "
            print
          }' >> "$tmpfile"
          MATCHED=1
        fi
        break
      fi
    done
    [ "$MATCHED" -eq 0 ] && echo "$line" >> "$tmpfile"
  done < "$LEADERBOARD"

  mv "$tmpfile" "$LEADERBOARD"
}

update_namepool_scores
update_leaderboard_scores

AGENT_COUNT=${#SCORE_DELTAS[@]}
echo "INFO: Leaderboard updated with $AGENT_COUNT agent(s)' score deltas." >&2

touch "$SENTINEL"

exit 0
