# A-301: Metrics & Scoring System Deep Analysis
**Agent:** Taner Yilmaz (T3)
**Date:** 2026-04-29

## Executive Summary

The metrics and self-learning subsystem is structurally sound in design but functionally inert on macOS due to a cascading failure rooted in Bash 3.2 incompatibility. The `update-leaderboard.sh` hook exits silently on every invocation without performing any updates, which means name-pool.md scores are permanently stale, the `.session-complete` sentinel is never written, and the scoring system exists only on paper. Pattern lifecycle does run (proceeding without the sentinel) but fails to match any patterns because the keyword extraction strategy uses the full first sentence of the `## Error` section verbatim — a string that is never reproduced literally in session files. Token usage and agent performance tracking are exclusively manual with no automation gap detection. Five distinct, independent bugs span the four hooks; none are blocking at the code level but together they render the entire self-learning loop aspirational rather than operational.

---

## Root Cause Analysis

### RCA-1: Name-pool Score Desync

**Symptom:** All 20 entries in `name-pool.md` show `Score: 0, Sessions: 0`. `leaderboard.md` shows 8 agents with scores from 2026-04-22.

**Traced code path:**

The `update_namepool_scores()` function in `update-leaderboard.sh` (lines 143–171) reads each line of name-pool.md and attempts to match agent names. The match check is:

```bash
if echo "$line" | grep -qF "| $NAME |"; then
```

For a name-pool.md data row like `| 1 | Taner Yilmaz | 0 | 0 |`, this grep succeeds (the substring `| Taner Yilmaz |` is present). However, the subsequent score extraction at line 151 reads:

```bash
OLD_SCORE=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $3); print $3}')
```

In name-pool.md the table schema is `| ID | Name | Score | Sessions |`, meaning `$3` (awk field 3) is the **Name column** (`Taner Yilmaz`), not the score. The AWK column indices assume a leaderboard.md schema (`| Rank | Name | Score | Tier | Sessions | ...`) where Score is `$3`. For name-pool.md's 4-column schema, Score is `$4`.

The regex guard at line 153 then tests whether the extracted value is numeric:

```bash
if [[ "$OLD_SCORE" =~ ^-?[0-9]+$ ]]; then
```

`"Taner Yilmaz"` fails this test, so the update block is skipped entirely and the original line is written unchanged to the temp file. This guard accidentally prevents data corruption while simultaneously guaranteeing that scores can never be written.

**Conclusion:** `update_namepool_scores()` has been broken since it was written. Column indices `$3/$4` are off-by-one for the name-pool.md table format. Every agent in name-pool.md permanently reads as "score extraction failed" and is skipped.

**Secondary cause:** Even if the AWK were fixed, this code path is never reached on this machine. `update-leaderboard.sh` exits at line 9 (`exit 0`) because `BASH_VERSINFO[0]` is `3` (macOS 3.2), which is less than 4. Homebrew bash is not installed (`/opt/homebrew/bin/bash` does not exist). The `leaderboard.md` scores from 2026-04-22 were manually written by the Orchestrator, not by the hook (confirmed by the "Tech Debt" note at leaderboard.md line 62).

**Evidence files:**
- `.claude/hooks/update-leaderboard.sh` lines 7–10 (Bash version check), lines 143–171 (`update_namepool_scores`)
- `.claude/config/name-pool.md` lines 7–28 (4-column schema)
- `.claude/metrics/leaderboard.md` line 62 (Tech Debt note confirming manual update)
- Confirmed: `/usr/bin/env bash --version` = GNU bash 3.2.57 (arm64-apple-darwin25)
- Confirmed: No sentinel file at `.claude/metrics/.session-complete`

---

### RCA-2: Pattern Lifecycle Effectiveness

**Symptom:** Both learned patterns show `hit-count: 0, sessions-since-hit: 1` despite being derived from session 2026-04-22 events.

**Traced code path:**

`pattern-lifecycle.sh` does run. The sentinel wait at lines 14–17 times out after 5 seconds (no sentinel was written because `update-leaderboard.sh` exited early), and the script proceeds as designed per line 19–21 ("proceeding anyway"). It successfully reads `session-2026-04-22-cycle1.md`.

The keyword extraction at lines 84–85 calls `extract_keyword_from_section`, which returns the **first non-empty line** of the `## Error` section:

- `haiku-over-caution-hook-paths.md` Error section first line: `"Haiku-tier agents (T4, T5) self-block on enforcement-scoped paths when they encounter blocking hook code. They read the hook's \`exit 2\` logic, interpret the messages literally ("Only X can write here"), and refuse to attempt the write — even when the user/Orchestrator has explicitly assigned them the task. This led to 3 failed write attempts in session 2026-04-22, consuming ~150K tokens before escalation."`

- `macos-bash-compat.md` Error section first line: `"macOS default Bash is 3.2 (not upgradable by Apple due to GPLv3 licensing). Hooks written with Bash 4+ features fail at runtime:"`

The hit check at line 88 uses `grep -qF` (fixed-string, exact match) against the entire session file content:

```bash
if [ -n "$KEYWORD" ] && echo "$SESSION_CONTENT" | grep -qF "$KEYWORD" 2>/dev/null; then
```

**Result for haiku pattern:** The session file (session-2026-04-22-cycle1.md) contains the word "haiku" only in the Agent Performance table (model column: `haiku-then-sonnet`) and in the Notes section (`hook-paranoia saga (Ayse Demir 3x haiku retries...`). Neither contains the verbatim 200+ character keyword sentence. `grep -qF` returns non-zero. HIT=0.

**Result for macos-bash-compat pattern:** The session file contains no reference to macOS, Bash 3.2, or GPLv3 at all (confirmed via grep). HIT=0.

**Root cause:** The keyword strategy is fundamentally misaligned. Pattern files describe errors in verbose prose. Session files describe session outcomes in tabular/summary form. These two vocabularies never intersect verbatim. The design assumes session files will contain long error descriptions from the pattern's `## Error` section, but session files contain high-level summaries written by the Orchestrator, not the raw error text.

**Consequence:** Both patterns will have `sessions-since-hit` increment by 1 each session. At `sessions-since-hit >= 5 AND hit-count == 0` (archival threshold), they will be moved to `archive/` — 4 more sessions from now — having never triggered once.

**Secondary issue:** The `sessions-since-hit: 1` state confirms `pattern-lifecycle.sh` ran exactly once (for the 2026-04-22 session), incrementing from the initial value of 0. This is the only session that has occurred since these patterns were created.

---

### RCA-3: Self-learning Collector Accuracy

**T5 finding (F-106) verification:** Confirmed. `self-learning-collector.sh` at line 36 extracts:

```bash
BASENAME=$(basename "$FILE_PATH")
```

Line 40 counts edits using:

```bash
EDIT_COUNT=$(grep -c "|$BASENAME|" "$EDIT_LOG" 2>/dev/null || echo "0")
```

If `src/auth/index.ts` and `tests/auth/index.ts` are both edited, the edit log would contain:
```
timestamp|index.ts|src/auth/index.ts
timestamp|index.ts|tests/auth/index.ts
```

Both lines match `|index.ts|`, so `EDIT_COUNT` becomes 2 after only one file has been edited twice (or after the second distinct file has been edited once). A pattern file would be created incorrectly for the first file.

**Additional finding — pattern file proliferation bug:** The `PATTERN_ID` at line 46 is generated as `LP-$(date +%Y%m%d%H%M%S)`. This creates a unique ID per-second. If a file is edited at `10:01:00`, `LP-20260429100100.md` is created. If the same file is edited at `10:01:01` (EDIT_COUNT=3 at this point, still >= 2), `LP-20260429100101.md` is also created. The guard at line 49 (`if [ ! -f "$PATTERN_FILE" ]`) only checks for THIS second's ID, not whether a pattern for this file already exists. Each qualifying edit after the 2nd creates a new pattern file. A session with 10 edits to one file would generate up to 9 pattern files, none of which are semantically different.

**Filter behavior confirmed:** Both hooks correctly filter out `.md`, `.json`, `.sh`, `.yml`, `.yaml` files and any paths under `.claude/` (lines 21–28). This means hooks and config files edited within the system (which is most of what the 2026-04-22 session edited) are silently excluded, and the self-learning collector never fires for those edits.

**Dual log file inconsistency:** `review-tracker.sh` writes to `.claude/metrics/.session-edits-YYYYMMDD.log` (line 32). `self-learning-collector.sh` reads from `.claude/metrics/.edit-log` (line 31). These are two separate files. The review tracker's session log is never read by the self-learning collector. The self-learning collector maintains its own log. This creates redundant logging with no cross-use.

---

### RCA-4: Review Tracker Counter Logic

**T5 finding (F-101) verification:** Confirmed. The counter at `.claude/metrics/.edit-counter` is a single integer file that accumulates across the entire session for all files combined.

```bash
COUNTER_FILE="$COUNTER_DIR/.edit-counter"   # Line 31
CURRENT=$(cat "$COUNTER_FILE")              # Line 37
NEXT=$((CURRENT + 1))                      # Line 38
echo "$NEXT" > "$COUNTER_FILE"             # Line 43
if [ "$NEXT" -eq 5 ]; then                 # Line 48
if [ "$NEXT" -eq 10 ]; then                # Line 52
```

The alerts fire when the **total session edit count reaches 5 or 10**, not when a single file is edited 5 or 10 times.

**Spec vs actual behavior:**
- `metrics-tracking.md` states: "Emits warnings at 5 and 10 edits **per file**"
- Actual behavior: Emits warnings at 5 and 10 edits **per session**

**Impact in a real coding session:** An agent that writes 3 new files (1 edit each) plus edits 2 existing files (1 edit each) would trigger the "5 edits reached, review recommended" warning — an irrelevant signal since no file was edited more than once.

**Counter reset:** The counter persists in `.edit-counter` between sessions (the file is never cleared). If session A ends at count 9 and session B begins, the first edit in session B will trigger the count-10 alert. There is no session-boundary reset mechanism.

---

### RCA-5: Token Usage and Agent Performance Gaps

**Token usage tracking:** `token-usage.md` has a structured session table (header at line 5) that is completely empty. The session data at lines 22–48 consists of manually written markdown sections added by the Orchestrator at session end (sessions 2026-04-17 and 2026-04-18). There is no hook, script, or automated mechanism that reads agent token consumption and populates this table. Token tracking is entirely manual and aspirational.

**Agent performance tracking:** `agent-performance.md` exhibits the same pattern. The "Session History" table at lines 13–16 is empty (header only). The two detailed session blocks below (lines 26–50) were manually written. The "Cumulative Statistics" table at lines 5–11 shows all zeros for all tiers. There is no hook that reads session files, parses agent performance, and updates these tables.

**Root cause:** Neither `update-leaderboard.sh` nor `pattern-lifecycle.sh` writes to `agent-performance.md` or `token-usage.md`. The leaderboard hook writes only to `leaderboard.md` and `name-pool.md`. There is no hook assigned to maintain these two files. This is a design gap — the session template (`_session-template.md`) defines the format, but no automation fills the tables.

**Compounding factor:** Even if automation existed, the session files themselves only contain "Estimated" vs "Actual" token comparisons manually written by the Orchestrator. Claude's actual API token consumption is not accessible from within the hooks (they have no API visibility). True token tracking would require a different data collection mechanism.

---

## Findings Table

| ID | Component | Severity | Finding | Lines | Confidence | Fix |
|---|---|---|---|---|---|---|
| M-001 | update-leaderboard.sh + macOS Bash | CRITICAL | Hook exits silently on Bash 3.2 (macOS default); no updates ever execute | 7–10 | High — confirmed Bash 3.2 is active, no Homebrew bash | Install Homebrew bash or rewrite with POSIX-only primitives (parallel arrays) |
| M-002 | update-leaderboard.sh `update_namepool_scores()` | CRITICAL | AWK column indices off-by-one for name-pool.md schema; `$3` extracts Name instead of Score; numeric guard blocks all updates | 151, 156–161 | High — verified with live test: `OLD_SCORE` = "Taner Yilmaz", fails regex | Change `$3` → `$4` for Score, `$4` → `$5` for Sessions in `update_namepool_scores()` |
| M-003 | pattern-lifecycle.sh keyword strategy | MAJOR | Keywords are full-paragraph sentences from `## Error`; never appear verbatim in session files; hit-count will never increment | 84–88 | High — verified via grep; zero matches across all keywords | Change to short, unique identifiers: use `pattern-id` field or a dedicated `## Keywords` section with comma-separated tokens |
| M-004 | self-learning-collector.sh pattern proliferation | MAJOR | New pattern file created per-second; each edit after threshold 2+ creates a new LP-YYYYMMDDHHMMSS.md; session of 10 edits → 9 pattern files | 46–76 | High — ID is timestamp; no de-duplication per filepath across a session | Use filepath-stable ID: `PATTERN_ID="LP-$(echo "$FILE_PATH" | md5sum | head -c8)"` or check for existing patterns for this filepath |
| M-005 | self-learning-collector.sh basename collision | MAJOR | Basename-only matching conflates `src/index.ts` and `tests/index.ts`; false positives in edit counting | 36, 40 | High — confirmed by T5 analysis (F-106) | Replace `$BASENAME` with `$FILE_PATH` in edit log grep: `grep -c "|$FILE_PATH$"` |
| M-006 | review-tracker.sh global counter | MAJOR | Counter is session-global (all files), not per-file; alerts fire at wrong time; counter never resets between sessions | 31, 48, 52 | High — single `.edit-counter` file, no reset logic | Implement per-file counter: `COUNTER_FILE="$COUNTER_DIR/.edit-counter-$(echo "$FILE_PATH" \| md5sum \| head -c8)"` |
| M-007 | review-tracker.sh / self-learning-collector.sh dual logs | MINOR | Two separate log files for the same event stream; `.session-edits-YYYYMMDD.log` and `.edit-log`; neither reads the other | 32 (tracker), 31 (collector) | High — different filenames, no cross-reference | Consolidate to one log file, or explicitly document separation of concerns |
| M-008 | token-usage.md / agent-performance.md automation | MAJOR | No hook populates cumulative tables; data is entirely manual; tables are structurally empty | Files, no hook | High — hook registry has no assignment for these files | Create a post-session hook or extend `update-leaderboard.sh` to parse session files and update aggregate tables |
| M-009 | .session-complete sentinel never created | MAJOR | Sentinel absent from `.claude/metrics/`; created only by `update-leaderboard.sh` which exits early on macOS; pattern-lifecycle proceeds without it each session | update-leaderboard.sh line 220 | High — file confirmed absent | Blocked by M-001; resolving M-001 resolves this transitively |
| M-010 | leaderboard.md duplicate placeholder rows | MINOR | 5 rows with "(dup)" suffix and "—" values in Current Standings (lines 17–21); confuse name matching in hook | leaderboard.md 17–21 | High — confirmed by T5 (F-002) | Remove rows 17–21; they are annotation artifacts per the note at line 33 |

---

## Improvement Recommendations

### P0 — Fix before next session (system is broken without these)

**REC-1: Rewrite `update-leaderboard.sh` with POSIX-only Bash**

Replace all `declare -A` associative arrays with parallel indexed arrays or awk-based processing. Remove the Bash 4 check (no longer needed). This unblocks the entire metrics pipeline on macOS.

Approach: Use `awk` to process the session file's Agent Performance table directly, building name→delta pairs as pipe-delimited strings in a temp file, then process that file line-by-line with basic Bash string ops.

Expected impact: Leaderboard updates execute on every session end. Sentinel file is created. Pattern lifecycle runs with accurate coordination. Name-pool scores start accumulating.

**REC-2: Fix `update_namepool_scores()` AWK column indices**

In `update-leaderboard.sh`, lines 151 and 156–161:
- `$3` should be `$4` for Score extraction (name-pool.md column 4)
- `$4` should be `$5` for Sessions extraction (name-pool.md column 5)
- AWK update block: `$4=" " ns " "` and `$5=" " nsess " "` (not `$3` and `$4`)

Expected impact: name-pool.md scores update correctly after each session, enabling score-weighted agent selection.

### P1 — Fix in next cycle (self-learning loop is broken without these)

**REC-3: Redesign pattern keyword matching**

Current strategy (verbatim first-line of `## Error`) fails because session files never reproduce error descriptions verbatim.

Recommended approach: Add a `## Keywords` section to the pattern template with 3–5 short, distinctive tokens (e.g., for haiku-over-caution: `haiku-self-block, enforcement-scoped, over-caution`). Update `pattern-lifecycle.sh` to split keywords by comma and check each independently with `grep -qi` (case-insensitive). A match on ANY keyword triggers `HIT=1`.

Alternative simpler approach: Match against the `pattern-id` field value in session "Learned Patterns" sections. The session file already lists pattern IDs at lines 56–61.

Expected impact: Both existing patterns would trigger immediately since the session file mentions "hook-paranoia" and "haiku retries" (concepts matching haiku-over-caution keywords) and the macos pattern is referenced in the 2026-04-22 leaderboard Tech Debt note.

**REC-4: Fix self-learning-collector pattern proliferation**

Replace timestamp-based PATTERN_ID with a file-path-stable ID. Check whether a pattern for this specific file already exists before creating a new one.

```bash
PATTERN_ID="LP-$(echo "$FILE_PATH" | cksum | awk '{print $1}')"
PATTERN_FILE="$PATTERNS_DIR/$PATTERN_ID.md"
```

With a stable ID, re-editing the file appends to the count but does not create duplicate pattern files.

**REC-5: Fix basename collision in self-learning-collector**

Line 40: Change `grep -c "|$BASENAME|"` to `grep -c "|$FILE_PATH|"` (or anchor: `grep -cF "|$FILE_PATH|"`). Update line 38 to use full path in the delimiter format for consistent matching.

### P2 — Housekeeping and observability

**REC-6: Fix review-tracker per-file counter**

Switch from a single `.edit-counter` to a per-file counter keyed on file path hash. Reset counters at session start (on first use per file). Alert message should name the specific file.

**REC-7: Implement automated aggregate table updates**

Extend `update-leaderboard.sh` (or create a new hook) to parse completed session files and update:
- `agent-performance.md` Session History table (one row per session)
- `agent-performance.md` Cumulative Statistics table (per-tier aggregate)

Token usage data can only be manually entered (API consumption is not hook-visible), but the session performance data is fully machine-readable from the session template.

**REC-8: Remove duplicate rows from leaderboard.md**

Delete lines 17–21 (the "(dup)" artifact rows). These serve no operational purpose and could confuse future name-matching logic if the hook is ever updated to write to leaderboard.md by name lookup.

**REC-9: Add `.edit-counter` reset on session start**

Add a mechanism to reset the global edit counter when a new session begins. One approach: store the session start timestamp in `.edit-counter-session`, and reset `.edit-counter` if the session timestamp changes. Alternatively, rename the counter file with a date suffix (matching the `.session-edits-YYYYMMDD.log` pattern already in use).

**REC-10: Consolidate edit log files**

Merge `.session-edits-YYYYMMDD.log` (review-tracker) and `.edit-log` (self-learning-collector) into one log format. Both write `timestamp|identifier|filepath`; the only difference is the counter in one vs basename in the other. A shared log simplifies both hooks and enables future cross-hook analytics.
