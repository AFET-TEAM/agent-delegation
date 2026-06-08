# A-201: Hooks + Metrics Consolidated Analysis
**Agent:** Canan Birsen (T4 Lead Analyst)
**Date:** 2026-04-29
**Sources:** A-101 (hook scripts), A-301 (metrics deep-dive)

---

## Executive Summary

The enforcement hooks (block-console-log, secret-guard, sql-injection, etc.) are structurally sound with well-defined exit codes and mostly correct Bash compatibility. However, the metrics self-learning subsystem—which depends on those hooks—is operationally broken on macOS due to a cascading failure in `update-leaderboard.sh`. The hook exits silently before running any update logic, preventing name-pool score synchronization, blocking the `.session-complete` sentinel creation, and consequently disabling the entire pattern lifecycle coordination. Overlapping findings across both analyses reveal five distinct bugs in the metrics layer alone, plus six additional issues in the enforcement hooks. Combined severity assessment: **3 P0 (system-broken) issues, 6 P1 (major functionality gaps), 3 P2 (quality issues)**.

---

## P0 — System-Broken Issues

These prevent core functionality from operating on macOS (or any machine without Bash 4+).

### P0-1: update-leaderboard.sh Silent Exit on Bash 3.2 (M-001, F-104)
**Severity:** CRITICAL  
**Sources:** A-101 F-104, A-301 RCA-1, M-001  
**Component:** `update-leaderboard.sh`

The leaderboard update hook checks for Bash 4.0 at lines 6–10 and exits with `exit 0` if the version is less than 4. On macOS (default Bash 3.2), this exit 0 is executed **on every session end**, preventing all subsequent code from running.

```bash
if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "INFO: update-leaderboard.sh requires Bash 4+..." >&2
  exit 0  # Silent exit; no scores recorded, no sentinel written
fi
```

**Impact:**
- No leaderboard.md updates for any session (scores locked at 2026-04-22)
- No name-pool.md score synchronization (all agent scores remain 0)
- **No `.session-complete` sentinel file created** — blocks pattern-lifecycle coordination (M-009)
- Self-learning system is non-functional

**Evidence:**
- Confirmed: `bash --version` = GNU bash 3.2.57 (macOS default)
- Confirmed: `.session-complete` sentinel absent from `.claude/metrics/`
- Confirmed: leaderboard.md has a "Tech Debt" note (line 62) stating scores were manually written in 2026-04-22

**Fix Required:**
Rewrite `update-leaderboard.sh` to use POSIX-only Bash without associative arrays. Use `awk` or parallel indexed arrays to process session data. Remove the version check. Target: hook must succeed on Bash 3.2+.

---

### P0-2: name-pool.md AWK Column Mismatch (M-002, F-104)
**Severity:** CRITICAL  
**Sources:** A-301 RCA-1, M-002  
**Component:** `update-leaderboard.sh` function `update_namepool_scores()`

Even if the Bash 4 check were fixed, the function at lines 143–171 will not update name-pool.md scores due to an off-by-one error in the AWK column indices.

```bash
# Line 151: Extract Score from name-pool.md
OLD_SCORE=$(echo "$line" | awk -F'|' '{gsub(/^ +| +$/, "", $3); print $3}')

# name-pool.md schema: | ID | Name | Score | Sessions |
#                         $1   $2     $3      $4
# This extracts $3 = Name ("Taner Yilmaz"), not Score
```

The subsequent numeric guard at lines 156–161 checks if the extracted value is numeric:
```bash
if [[ "$OLD_SCORE" =~ ^-?[0-9]+$ ]]; then
  # Update block (never reached because "Taner Yilmaz" fails the regex)
```

**Impact:**
- All rows in name-pool.md are skipped; scores are never updated
- The numeric guard accidentally prevents data corruption while guaranteeing permanent stale state
- Score-weighted agent name selection (per CLAUDE.md §Step 0) always uses default (uniform random) selection

**Evidence:**
- Verified with live test: `echo "| Taner Yilmaz |" | awk -F'|' '{print $3}'` = `Taner Yilmaz` (off-by-one)
- name-pool.md table at lines 7–28 has 4 columns: `| Rank | Name | Score | Sessions |`
- Correct indices for name-pool.md: Score is `$4`, Sessions is `$5`
- Leaderboard.md uses different schema (Score at `$3`), explaining the confusion

**Fix Required:**
Lines 151, 156, 161: Change `$3` → `$4` for Score column, `$4` → `$5` for Sessions column in the `update_namepool_scores()` function.

---

### P0-3: Pattern Lifecycle Sentinel Coordination Missing (M-009)
**Severity:** CRITICAL  
**Sources:** A-301 RCA-2, M-009  
**Component:** `pattern-lifecycle.sh`

Because `update-leaderboard.sh` exits before line 220 (where the sentinel is written), the `.session-complete` sentinel file never exists. `pattern-lifecycle.sh` waits for this sentinel for 5 seconds, times out, and proceeds anyway (line 19). While it continues to run, it operates without proper synchronization.

**Impact:**
- No guarantee that leaderboard updates complete before pattern lifecycle begins
- Pattern lifecycle proceeds immediately regardless of whether metrics have been calculated
- Future pattern promotion/archival decisions are based on stale or incomplete session data
- Violates the self-learning protocol's sequential guarantee (pattern updates should happen AFTER scoring completes)

**Evidence:**
- File `.claude/metrics/.session-complete` confirmed absent
- `pattern-lifecycle.sh` lines 14–21 show sentinel wait + timeout proceed
- `update-leaderboard.sh` line 220 is unreachable on Bash 3.2

**Fix Required:**
Blocked by P0-1. Once `update-leaderboard.sh` is rewritten for POSIX Bash, ensure line 220 (or equivalent) creates the sentinel file before hook exit.

---

## P1 — Major Functionality Gaps

These degrade significant functionality but do not completely break the system.

### P1-1: Pattern Lifecycle Keyword Matching Never Triggers (M-003, F-102)
**Severity:** MAJOR  
**Sources:** A-301 RCA-2, M-003  
**Component:** `pattern-lifecycle.sh` function `extract_keyword_from_section()`

The keyword extraction strategy uses the full first-sentence of the `## Error` section from each pattern file verbatim. When searching for pattern hits in the session file, `pattern-lifecycle.sh` calls:

```bash
KEYWORD=$(extract_keyword_from_section "$PATTERN_FILE" "Error")  # Returns full paragraph
if [ -n "$KEYWORD" ] && echo "$SESSION_CONTENT" | grep -qF "$KEYWORD" 2>/dev/null; then
  HIT=1
fi
```

Example keywords extracted:
- **haiku-over-caution-hook-paths.md:** `"Haiku-tier agents (T4, T5) self-block on enforcement-scoped paths when they encounter blocking hook code. They read the hook's 'exit 2' logic, interpret the messages literally ("Only X can write here"), and refuse to attempt the write — even when the user/Orchestrator has explicitly assigned them the task. This led to 3 failed write attempts in session 2026-04-22, consuming ~150K tokens before escalation."` (180+ character sentence)
- **macos-bash-compat.md:** `"macOS default Bash is 3.2 (not upgradable by Apple due to GPLv3 licensing). Hooks written with Bash 4+ features fail at runtime:"`

Session files (e.g., session-2026-04-22-cycle1.md) contain high-level summaries and tables, **never** the verbose error description text. The session file may mention "haiku retries" or "hook-paranoia" conceptually, but never reproduces the 200-character sentence verbatim.

**Impact:**
- Both existing patterns show `hit-count: 0`, meaning they never triggered despite being derived from 2026-04-22 events
- Pattern hit-count will never increment regardless of whether the same issue recurs
- Pattern promotion (at `hit-count >= 3`) is impossible for any pattern
- Learned patterns will silently age out and be archived (at `sessions-since-hit >= 5`) without ever being promoted to permanent rules

**Evidence:**
- Confirmed via grep: the 180-character haiku keyword does not appear in session-2026-04-22-cycle1.md
- Confirmed: pattern files use verbose prose; session files use tabular summaries — different vocabularies

**Fix Required:**
Add a `## Keywords` section to the pattern template (`.claude/memory/_pattern-template.md`) with 3–5 short, distinctive tokens (e.g., `haiku-self-block, enforcement-scoped, over-caution, hook-paranoia, blocked-write`). Update `pattern-lifecycle.sh` to split keywords by comma and check each independently with case-insensitive grep:

```bash
KEYWORDS=$(extract_keyword_from_section "$PATTERN_FILE" "Keywords")
for keyword in $(echo "$KEYWORDS" | tr ',' '\n'); do
  keyword=$(echo "$keyword" | xargs)  # trim whitespace
  if [ -n "$keyword" ] && echo "$SESSION_CONTENT" | grep -qiF "$keyword"; then
    HIT=1
    break
  fi
done
```

---

### P1-2: Self-Learning Collector Pattern Proliferation (M-004)
**Severity:** MAJOR  
**Sources:** A-301 RCA-3, M-004  
**Component:** `self-learning-collector.sh`

The pattern ID is generated per-second using `date +%Y%m%d%H%M%S`. If a file is edited multiple times within the same second, or edited across multiple seconds after crossing the threshold (2+ edits), a new pattern file is created for each second:

```bash
PATTERN_ID="LP-$(date +%Y%m%d%H%M%S)"   # Lines 46, unique per-second
PATTERN_FILE="$PATTERNS_DIR/$PATTERN_ID.md"
if [ ! -f "$PATTERN_FILE" ]; then
  # Create new pattern
fi
```

In a 10-edit session to one file:
- Edit 1: count=1, no pattern
- Edit 2: count=2, create LP-20260429100100.md
- Edit 3: count=3, create LP-20260429100101.md (new ID, new file)
- ...
- Edit 10: create LP-20260429100109.md (new ID, new file)

Result: 9 near-identical pattern files for one conceptual error.

**Impact:**
- Pattern table explodes; filesystem is littered with redundant files
- Pattern lifecycle must process dozens of identical entries
- No deduplication; wasteful storage and processing

**Evidence:**
- `PATTERN_ID` at line 46 uses timestamp with second granularity
- No check for existing patterns matching this file; only checks current-second ID

**Fix Required:**
Use a file-path-stable ID instead of timestamp:

```bash
PATTERN_ID="LP-$(echo "$FILE_PATH" | cksum | awk '{print $1}')"
```

This ensures the same file always gets the same pattern ID, and re-editing appends to the count without creating duplicate files.

---

### P1-3: Basename Collision in Edit Counting (M-005, F-106)
**Severity:** MAJOR  
**Sources:** A-101 F-106, A-301 RCA-3, M-005  
**Component:** `self-learning-collector.sh`

Edit count is based on basename-only matching:

```bash
BASENAME=$(basename "$FILE_PATH")          # Line 36: extracts "index.ts"
EDIT_COUNT=$(grep -c "|$BASENAME|" "$EDIT_LOG" 2>/dev/null || echo "0")  # Line 40
```

If both `src/auth/index.ts` and `tests/auth/index.ts` are edited, the edit log contains:
```
timestamp|index.ts|src/auth/index.ts
timestamp|index.ts|tests/auth/index.ts
```

Both match `|index.ts|`, conflating them as one file. After editing either file twice, the pattern fires for the other file (false positive).

**Impact:**
- False positives in pattern detection
- Unrelated files in different directories are conflated
- Pattern lifecycle triggered incorrectly for files not actually edited repeatedly

**Evidence:**
- Line 36: loses directory context by extracting basename only
- Line 40: grep matches both directory variants

**Fix Required:**
Use full file path in edit log matching:

```bash
EDIT_COUNT=$(grep -cF "|$FILE_PATH|" "$EDIT_LOG" 2>/dev/null || echo "0")
```

And update the edit log format in `review-tracker.sh` to include full path consistently.

---

### P1-4: Review Tracker Global Counter (M-006, F-101)
**Severity:** MAJOR  
**Sources:** A-101 F-101, A-301 RCA-4, M-006  
**Component:** `review-tracker.sh`

The counter at `.claude/metrics/.edit-counter` is incremented globally for the entire session, not per-file:

```bash
COUNTER_FILE="$COUNTER_DIR/.edit-counter"   # Single file for all edits
CURRENT=$(cat "$COUNTER_FILE")
NEXT=$((CURRENT + 1))
echo "$NEXT" > "$COUNTER_FILE"
if [ "$NEXT" -eq 5 ]; then
  echo "WARNING: 5 edits reached, review recommended" >&2
fi
```

**Spec vs. Actual:**
- **metrics-tracking.md states:** "Emits warnings at 5 and 10 edits **per file**"
- **Actual behavior:** Emits warnings at 5 and 10 edits **per session**

**Impact:**
- Users receive alerts at wrong times (after 5 total session edits, not 5 edits to one file)
- Review recommendation is misleading (suggests a file needs review when in fact many different files have been edited once each)
- No counter reset between sessions; session B starts with session A's counter value

**Evidence:**
- Single `.edit-counter` file used for all files
- Alerts fire at global thresholds 5 and 10
- No reset mechanism between sessions

**Fix Required:**
Implement per-file counter keyed on file path hash:

```bash
FILE_HASH=$(echo "$FILE_PATH" | md5sum | head -c8)
COUNTER_FILE="$COUNTER_DIR/.edit-counter-$FILE_HASH"
```

Add session-start reset: check if counter file is stale (older than session start timestamp) and clear it.

---

### P1-5: Exit Code Semantics Unclear in git-safety-check.sh (F-105)
**Severity:** MAJOR  
**Sources:** A-101 F-105  
**Component:** `git-safety-check.sh`

Two different git operation categories use exit code 2, but have different semantics:

```bash
# Destructive ops: should be WARNING (exit 1, allow user to confirm)
if echo "$COMMAND" | grep -qE 'git\s+(push|merge|rebase)'; then
  echo "WARNING: Destructive git operation..." >&2
  exit 2  # But exit 2 = BLOCKED, preventing confirmation flow
fi

# Write ops: should be BLOCKED (exit 2)
if echo "$COMMAND" | grep -qE 'git\s+(commit|add)'; then
  echo "BLOCKED: Git write operation..." >&2
  exit 2
fi
```

Per `.claude/rules/git-safety.md`, destructive ops require "explicit, unambiguous text consent," meaning users should be able to proceed after seeing the warning. But exit code 2 is a hard block.

**Impact:**
- User cannot attempt a push with explicit consent (hook blocks outright)
- Consent hierarchy is broken (destructive ops should allow user confirmation)

**Evidence:**
- Lines 22–25 use exit 2 for destructive ops (should be exit 1)
- Lines 27–30 use exit 2 for write ops (correct)
- Both use same exit code despite different semantics

**Fix Required:**
Separate exit codes:
- Destructive ops (push, merge, rebase): `exit 1` (warning, non-blocking)
- Write ops (commit, add): `exit 2` (blocked)

---

### P1-6: Token Usage and Agent Performance Tracking Fully Manual (M-008)
**Severity:** MAJOR  
**Sources:** A-301 RCA-5, M-008  
**Component:** `agent-performance.md`, `token-usage.md`

Neither file has any automation. The tables are structurally defined in the session template but are never populated.

- **token-usage.md** (lines 22–48): "Session History" table is empty; token data is manually written by Orchestrator
- **agent-performance.md** (lines 13–16): "Session History" table is empty; cumulative statistics show all zeros

No hook reads session files and updates these aggregate tables.

**Impact:**
- Token usage tracking is aspirational (no data)
- Agent performance metrics are not accumulated across sessions
- Leaderboard scoring has no observability of actual token cost per agent
- Historical data is not preserved

**Evidence:**
- Hook registry has no assignment for these files
- `update-leaderboard.sh` writes only to `leaderboard.md` and `name-pool.md`
- `pattern-lifecycle.sh` writes only to learned patterns

**Fix Required:**
Extend `update-leaderboard.sh` or create a new post-session hook to parse completed session files and populate:
1. `agent-performance.md` Session History table (one row per completed session)
2. `agent-performance.md` Cumulative Statistics table (per-tier aggregate)

Note: True token tracking requires API visibility; session files contain estimated/actual comparisons, but Claude's actual token consumption is not accessible from hooks.

---

## P2 — Quality Issues

These are correctness and logic problems that don't break core flow but degrade quality.

### P2-1: block-comments.sh Quoted-String Detection Incomplete (F-102)
**Severity:** MINOR  
**Sources:** A-101 F-102  
**Component:** `block-comments.sh`

The regex chain attempts to filter out `//` inside quotes by checking complex patterns, but handles overlapping quotes incorrectly:

```bash
echo "$CLEANED" | grep -E '^\s*//[^/]|[^:]\s*//\s+[A-Za-z]' | \
  grep -Ev '^[^"]*"[^"]*"[^"]*//|^[^"]*"[^"]*//[^"]*"' | \
  grep -qE '^\s*//[^/]|[^:]\s*//\s+[A-Za-z]'
```

Cannot reliably handle:
- Escaped quotes: `\"string with \" quote\"`
- Triple-quoted/template literals with backticks
- Mixed single and double quotes

**Impact:**
- False positives: legitimate inline comments in quoted strings may be blocked
- False negatives: comments in complex string contexts may slip through
- Edge cases in template literals not covered

**Evidence:**
- Line 51: regex assumes balanced quotes
- No special handling for escape sequences or template literals

**Fix Required:**
Refine quoted-string filtering by pre-parsing template literals and strings, or accept and document the limitation. Consider using a `prettier-ignore` escape hatch for legitimate cases.

---

### P2-2: figma-standards-guard.sh Typography Logic Nested and Unclear (F-103)
**Severity:** MINOR  
**Sources:** A-101 F-103  
**Component:** `figma-standards-guard.sh`

Typography check at lines 78–83 uses nested if-statements with confusing logic:

```bash
if echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*[^$v\{\s]' | \
   grep -qvE 'font-(size|weight|family)\s*:\s*(var\(|theme\.)'; then
  if echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*[^$v\{\s]'; then
    if ! echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*(var\(|theme\.|\\$)'; then
      echo "WARNING: ..." >&2
    fi
  fi
fi
```

Creates a logical triple-negative: "If matches AND NOT safe AND NOT safe_explicitly — warn." Redundant and error-prone.

**Impact:**
- Code is hard to understand and maintain
- Exit code path is unclear (always exits 0, despite warning)
- Future maintainers may break the logic

**Evidence:**
- Lines 78–83 use pipe operators combining multiple greps
- Lines 80–81 re-check same pattern and invert safe-pattern check
- Triple negative is logically confusing

**Fix Required:**
Simplify to one clear condition:

```bash
if echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*[^$v\{\s]' && \
   ! echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*(var\(|theme\.|\\$)'; then
  echo "WARNING: ..." >&2
fi
exit 0
```

---

### P2-3: sql-injection-check.sh Template Literal Pattern Incomplete (F-109)
**Severity:** MINOR  
**Sources:** A-101 F-109  
**Component:** `sql-injection-check.sh`

Template literal check only detects `${}` interpolation, missing concatenation patterns:

```bash
if echo "$CONTENT" | grep -qE '`[^`]*(SELECT|INSERT|UPDATE|DELETE|WHERE|FROM)[^`]*\$\{'; then
  echo "BLOCKED: SQL injection risk..." >&2
  exit 2
fi
```

Does NOT catch:
```javascript
const sql = `SELECT * FROM users WHERE id = ` + userId  // NOT detected
let query = baseSql + `SELECT ...`                       // Partially detected
```

**Impact:**
- Incomplete SQL injection detection; dangerous patterns slip through
- False confidence in security hook coverage

**Evidence:**
- Line 42 regex: only detects `${` syntax
- No detection of `+` concatenation within or around backticks

**Fix Required:**
Add another check for backtick + concatenation:

```bash
if echo "$CONTENT" | grep -qE '`[^`]*(SELECT|INSERT|UPDATE|DELETE|WHERE|FROM)[^`]*[+"]|\+[^`]*(SELECT|INSERT|UPDATE|DELETE|WHERE|FROM)'; then
  echo "BLOCKED: SQL injection risk in concatenated template literal..." >&2
  exit 2
fi
```

---

## Consolidated Findings Table

| ID | Component | Severity | Finding (merged) | Sources | Fix Required |
|---|---|---|---|---|---|
| F-101/M-006 | review-tracker.sh | P1-MAJOR | Global session counter (all files), not per-file; alerts fire at wrong time; counter never resets between sessions | A-101 F-101, A-301 M-006 | Implement per-file counter with hash-based IDs; reset at session start |
| F-102 | block-comments.sh | P2-MINOR | Quoted-string detection incomplete; overlapping quotes, escaped quotes, template literals not handled correctly | A-101 F-102 | Refine quoted-string filtering or accept/document limitation; `prettier-ignore` escape hatch |
| F-103 | figma-standards-guard.sh | P2-MINOR | Typography check uses nested if-conditions with confusing triple-negative logic; exit code path unclear | A-101 F-103 | Simplify to single-condition if-statement; clarify exit 0 always |
| F-104/M-001 | update-leaderboard.sh | P0-CRITICAL | Bash 4.0 check exists but falls back to silent exit 0 on macOS 3.2; no updates execute; blocks entire metrics pipeline | A-101 F-104, A-301 M-001 | Rewrite with POSIX-only Bash (parallel arrays, awk); remove version check |
| F-105 | git-safety-check.sh | P1-MAJOR | Exit code 2 used for both WARNING (destructive ops) and BLOCKED (write ops); breaks consent hierarchy | A-101 F-105 | Separate: exit 1 for destructive ops, exit 2 for write ops |
| F-106/M-005 | self-learning-collector.sh | P1-MAJOR | Basename-only matching conflates `src/index.ts` and `tests/index.ts`; false positives in edit counting | A-101 F-106, A-301 M-005 | Use full file path in edit log grep: `grep -c "\|$FILE_PATH\|"` |
| M-002 | update-leaderboard.sh `update_namepool_scores()` | P0-CRITICAL | AWK column indices off-by-one for name-pool.md schema; `$3` extracts Name instead of Score | A-301 M-002 | Change `$3` → `$4` for Score, `$4` → `$5` for Sessions |
| M-003 | pattern-lifecycle.sh | P1-MAJOR | Keywords are full-paragraph sentences from `## Error`; never appear verbatim in session files; hit-count never increments | A-301 M-003 | Add `## Keywords` section to pattern template; split by comma and check each independently |
| M-004 | self-learning-collector.sh | P1-MAJOR | Pattern file created per-second; each edit after threshold creates new LP-YYYYMMDDHHMMSS.md; 10 edits → 9 files | A-301 M-004 | Use file-path-stable ID: `LP-$(echo $FILE_PATH \| cksum \| awk '{print $1}')` |
| M-008 | agent-performance.md, token-usage.md | P1-MAJOR | No hook populates aggregate tables; data is entirely manual; tables structurally empty | A-301 M-008 | Extend `update-leaderboard.sh` to parse session files and populate Session History + Cumulative Statistics |
| M-009 | pattern-lifecycle.sh | P0-CRITICAL | Sentinel `.session-complete` never created (update-leaderboard.sh exits early); pattern coordination broken | A-301 M-009 | Blocked by M-001; resolving P0-1 resolves this transitively |
| F-109 | sql-injection-check.sh | P2-MINOR | Template literal check only detects `${}`; misses concatenation patterns with `+` | A-101 F-109 | Add pattern check for backtick + concatenation: `\`.*[+-].*\`` |

---

## Fix Roadmap (ordered by dependency and impact)

### Phase 1: Unblock the Metrics Pipeline (P0 fixes)

**Fix 1: Rewrite `update-leaderboard.sh` for POSIX Bash (P0-1)**
- **Status:** Blocking all downstream metrics
- **Effort:** High (significant rewrite)
- **Approach:** Replace `declare -A` arrays with awk-based processing or parallel indexed arrays; remove Bash 4 version check
- **Impact:** Enables leaderboard updates, sentinel creation, pattern-lifecycle coordination

**Fix 2: Correct AWK Column Indices in `update_namepool_scores()` (P0-2)**
- **Status:** Blocking name-pool score sync (depends on Fix 1)
- **Effort:** Low (4-line change)
- **Lines:** Change `$3` → `$4`, `$4` → `$5` in lines 151, 156, 161
- **Prerequisite:** Fix 1 must complete first

**Fix 3: Ensure Sentinel File Created (P0-3)**
- **Status:** Blocking pattern-lifecycle coordination (depends on Fix 1)
- **Effort:** Very Low (already in code, just needs Bash rewrite)
- **Lines:** `update-leaderboard.sh` line 220 (or equivalent after rewrite)
- **Prerequisite:** Fix 1 must complete first

### Phase 2: Restore Self-Learning Pipeline (P1 fixes)

**Fix 4: Redesign Pattern Keyword Matching (P1-1)**
- **Status:** Blocking pattern hit-counting
- **Effort:** Medium (template + hook changes)
- **Approach:** Add `## Keywords` section to pattern template; update `pattern-lifecycle.sh` to split keywords and check each independently
- **Prerequisites:** None (can proceed in parallel with Phase 1)
- **Impact:** Enables pattern promotion to permanent rules

**Fix 5: Fix Pattern ID Generation (P1-2)**
- **Status:** Blocking deduplicated pattern creation
- **Effort:** Low (one-line change in `self-learning-collector.sh` line 46)
- **Approach:** Use `cksum` hash of file path instead of timestamp
- **Prerequisites:** None
- **Impact:** Prevents pattern file proliferation

**Fix 6: Fix Basename Collision in Edit Counting (P1-3)**
- **Status:** Blocking accurate self-learning signals
- **Effort:** Low (one-line change in `self-learning-collector.sh` line 40)
- **Approach:** Use full `$FILE_PATH` instead of `$BASENAME`
- **Prerequisites:** None
- **Impact:** Eliminates false positives in pattern detection

**Fix 7: Fix Review Tracker Per-File Counter (P1-4)**
- **Status:** Advisory (currently gives misleading alerts)
- **Effort:** Medium (hash-keyed counter system)
- **Approach:** Use file-path hash for counter filename; reset at session start
- **Prerequisites:** None
- **Impact:** Users get accurate edit-count alerts per file

**Fix 8: Separate Git Safety Exit Codes (P1-5)**
- **Status:** Blocking git consent hierarchy
- **Effort:** Low (two-line change in `git-safety-check.sh`)
- **Approach:** Exit 1 for destructive ops, exit 2 for write ops
- **Prerequisites:** None
- **Impact:** Restores user ability to confirm destructive operations

**Fix 9: Implement Automation for Agent Performance Tables (P1-6)**
- **Status:** Blocking observability of agent metrics
- **Effort:** High (new hook or hook extension)
- **Approach:** Extend `update-leaderboard.sh` to parse session files and populate `agent-performance.md` and `token-usage.md`
- **Prerequisites:** Fix 1 (metrics pipeline must work first)
- **Impact:** Enables historical tracking of agent performance

### Phase 3: Quality Improvements (P2 fixes)

**Fix 10: Simplify figma-standards-guard.sh Typography Logic (P2-1)**
- **Status:** Quality only; logic works but is confusing
- **Effort:** Low (simplify nested ifs)
- **Lines:** 78–83

**Fix 11: Improve block-comments.sh Quoted-String Detection (P2-2)**
- **Status:** Quality only; false positives possible
- **Effort:** Medium-High (requires deeper regex work or pre-parsing)
- **Approach:** Add escaped-quote and backtick handling, or accept/document limitation

**Fix 12: Complete sql-injection-check.sh Pattern Coverage (P2-3)**
- **Status:** Security quality; incomplete detection
- **Effort:** Low (add concatenation pattern check)
- **Lines:** 42, add new grep for `+` concatenation

### Execution Order Summary

1. **Fix 1** (POSIX Bash rewrite) — unblocks 2, 3, 9
2. **Fixes 2, 3** (AWK columns, sentinel) — dependent on 1
3. **Fixes 4, 5, 6, 7, 8** (self-learning + alerts) — can run in parallel with 1
4. **Fix 9** (agent performance tables) — depends on 1
5. **Fixes 10, 11, 12** (quality) — independent, low priority

---

## Severity Summary

| Priority | Count | Components | Fix Complexity |
|----------|-------|------------|---|
| P0 (System-Broken) | 3 | update-leaderboard.sh (2), pattern-lifecycle.sh (1) | High (1 rewrite), Very Low (2 line changes) |
| P1 (Major Gaps) | 6 | self-learning (3), metrics (2), git-safety (1) | Medium (2), Low (4) |
| P2 (Quality) | 3 | figma-guard (1), block-comments (1), sql-inject (1) | Low-Medium |
| **Total** | **12** | **9 files** | **Mixed** |

---

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| P0 fixes introduce regression in macOS testing | **High** | Metrics pipeline breaks worse | Require macOS Bash 3.2 testing before merge; add CI check for Bash version compatibility |
| Pattern keyword redesign does not match existing sessions | **Medium** | Existing patterns never promote | Review historical session files before finalizing keywords; test with session-2026-04-22 |
| Pattern ID hash collision (unlikely but possible) | **Very Low** | Duplicate pattern IDs | Use SHA256 hash instead of cksum for collision resistance |
| Self-learning collector still filters hooks/config (.claude/ paths) | **Low** | System edits not tracked | This is by design; document clearly |

---

## Sources

- `.claude/hooks/review-tracker.sh` (lines 30–43, 48, 52)
- `.claude/hooks/self-learning-collector.sh` (lines 36, 40, 46, 49–76)
- `.claude/hooks/update-leaderboard.sh` (lines 6–10, 80–82, 143–171, 220)
- `.claude/hooks/pattern-lifecycle.sh` (lines 14–21, 84–88)
- `.claude/hooks/block-comments.sh` (line 51)
- `.claude/hooks/figma-standards-guard.sh` (lines 62, 78–83)
- `.claude/hooks/git-safety-check.sh` (lines 22–29)
- `.claude/hooks/sql-injection-check.sh` (line 42)
- `.claude/config/name-pool.md` (lines 7–28)
- `.claude/metrics/leaderboard.md` (line 62)
- `.claude/metrics/agent-performance.md` (lines 5–16)
- `.claude/metrics/token-usage.md` (lines 5, 22–48)
- A-101: Hook Scripts Raw Analysis (Ayse Demir, T5)
- A-301: Metrics & Scoring System Deep Analysis (Taner Yilmaz, T3)
- CLAUDE.md §Self-Learning Protocol, §Step 0 (agent name selection)
- `.claude/rules/git-safety.md` (consent rules)
- `.claude/rules/metrics-tracking.md` (hook responsibilities)
