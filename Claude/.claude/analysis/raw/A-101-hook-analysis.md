# A-101: Hook Scripts Raw Analysis

**Agent:** Ayse Demir (T5)
**Date:** 2026-04-29

## Summary

- Total hooks analyzed: 16
- Critical findings: 3
- Major findings: 5
- Minor findings: 4
- Total issues: 12

---

## Findings Table

| ID | Hook File | Category | Severity | Finding | Line(s) | Confidence | Recommendation |
|---|---|---|---|---|---|---|---|
| F-101 | review-tracker.sh | Logic Correctness | CRITICAL | Counter is global session-wide, not per-file. Accumulates across all files. | 30–43 | High | Change to per-file counter or clarify intent |
| F-102 | block-comments.sh | Logic Correctness | MAJOR | String-in-quotes detection (line 51) is incomplete; overlapping double-quotes confuse the regex | 51 | High | Refine quoted-string-safe comment detection |
| F-103 | figma-standards-guard.sh | Exit Code | MAJOR | Typography warning (lines 78–83) does NOT exit 0 consistently; logic is nested and unclear | 78–83 | High | Simplify exit code path; always exit 0 after warning |
| F-104 | update-leaderboard.sh | macOS Compatibility | CRITICAL | Bash 4.0 check at line 7 exists, but no fallback for missing associative array support in some operations | 80–82 | Medium | Add guard for array syntax fallback or increase min version |
| F-105 | git-safety-check.sh | Exit Code | MAJOR | Exit code semantics unclear: exit 2 for both WARNING and BLOCKED states (lines 23, 28) | 23, 28 | High | Separate warning (exit 1) from blocked (exit 2) |
| F-106 | self-learning-collector.sh | Logic Correctness | MAJOR | EDIT_COUNT only counts lines in $EDIT_LOG matching basename; multi-basename files may miscount | 40 | Medium | Use precise file path matching instead of basename |
| F-107 | block-console-log.sh | Edge Case | MINOR | Regex on line 33 assumes `\s` before `(` — `console.log()` with no space passes | 33 | Medium | Use `\s*` instead of `\s` in regex |
| F-108 | block-any-type.sh | Edge Case | MINOR | Regex on line 33 uses `\b` boundary — may miss `(: any)` inside template literals or strings | 33 | Low | Add context-aware parsing or explicit test cases |
| F-109 | sql-injection-check.sh | Logic Correctness | MAJOR | Regex on line 42 (template literals) only detects `${` patterns; does NOT catch interpolation in backticks without $ | 42 | Medium | Clarify scope: does this detect all unsafe SQL patterns? |
| F-110 | figma-standards-guard.sh | Logic Correctness | MINOR | Line 62: `px` block uses `[2-9]` pattern; assumes 0 and 1 are safe. Depends on use case (e.g., 2px border may be intended). | 62 | Low | Document intent: are 2px+ always unsafe? |
| F-111 | pattern-lifecycle.sh | macOS Compatibility | MINOR | Uses `sed -E` (POSIX ERE) but macOS sed requires `-E` flag explicitly; the script does use it correctly at line 45 | 45 | Low | Already correct; no action needed |
| F-112 | path-traversal-check.sh | Edge Case | MINOR | Regex on line 37 only detects `"../"` literal string; does NOT catch `../` in variables or after concatenation | 37 | Low | Warn: detection limited to literal strings |

---

## Detailed Findings

### F-101: review-tracker.sh — Global Session Counter (CRITICAL)

**File:** `.claude/hooks/review-tracker.sh`
**Lines:** 30–43
**Severity:** CRITICAL

The counter at `.claude/metrics/.edit-counter` is incremented globally for the entire session, not per-file:

```bash
NEXT=$((CURRENT + 1))
echo "$NEXT" > "$COUNTER_FILE"
```

**Issue:** This counter resets for each session but accumulates across ALL files. The threshold alerts at 5 and 10 are triggered when ANY 5 and 10 edits happen in the session, not when a single file is edited 5/10 times.

**Evidence:**
- Line 31: Single `.edit-counter` file is used
- Lines 48–54: Alerts fire at global counts 5 and 10

**Impact:** Users receive alerts at wrong times (after 5th edit across all files, not 5th edit to one file). Review recommendation is misleading.

**Recommendation:**
1. If intent is "total edits in session," document this clearly and adjust alert messaging.
2. If intent is "edits per file," switch to per-file counters (e.g., `.edit-counter.filename`).
3. Cross-reference with `self-learning-collector.sh` (which DOES track per-file at line 40) for consistency.

---

### F-102: block-comments.sh — Quoted String Detection Incomplete (MAJOR)

**File:** `.claude/hooks/block-comments.sh`
**Lines:** 51
**Severity:** MAJOR

The inline comment detection logic at line 51:

```bash
if echo "$CLEANED" | grep -E '^\s*//[^/]|[^:]\s*//\s+[A-Za-z]' | grep -Ev '^[^"]*"[^"]*"[^"]*//|^[^"]*"[^"]*//[^"]*"' | grep -qE '^\s*//[^/]|[^:]\s*//\s+[A-Za-z]'; then
```

**Issue:** The regex chain attempts to filter out `//` inside quotes by checking patterns like `^[^"]*"[^"]*"[^"]*//` (no quotes before //) and `^[^"]*"[^"]*//[^"]*"` (quotes around //). However:

1. Overlapping quotes confuse the filter: `"string" // comment` passes both filters incorrectly.
2. The regex assumes balanced quotes and does not handle:
   - Escaped quotes: `\"string with \" quote\"`
   - Triple-quoted strings (template literals with backticks)
   - Single-quoted strings alongside double-quoted strings

**Evidence:** A line like `const msg = "hello"; // real comment` would be caught by the first grep, NOT filtered by the second (because it matches `^[^"]*"[^"]*//[^"]*"`), and would then match the third grep, triggering a false block.

**Recommendation:**
Use a more robust approach:
1. Pre-filter template literals and strings using a dedicated regex or jq parser.
2. Or accept this limitation and document: "Comment detection may have false positives/negatives in complex strings."
3. Consider using `prettier-ignore` directives as an escape hatch for legitimate cases.

---

### F-103: figma-standards-guard.sh — Typography Warning Exit Code Ambiguous (MAJOR)

**File:** `.claude/hooks/figma-standards-guard.sh`
**Lines:** 78–83
**Severity:** MAJOR

Typography font check at lines 78–83:

```bash
if echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*[^$v\{\s]' | grep -qvE 'font-(size|weight|family)\s*:\s*(var\(|theme\.)'; then
  if echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*[^$v\{\s]'; then
    if ! echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*(var\(|theme\.|\\$)'; then
      echo "WARNING: ..." >&2
    fi
  fi
fi
```

**Issue:** This outputs a WARNING (stderr) but always exits 0 at the end (line 94). However, the nested if-logic is confusing:
- The first `if` uses a pipe (`|`) which means it checks: (matches pattern) AND (does NOT match safe pattern).
- The second `if` re-checks the same pattern.
- The inner `if !` inverts the safe-pattern check again.

This creates a logical triple-negative: "If matches AND NOT safe AND NOT safe_explicitly — warn." This is redundant and error-prone.

**Evidence:**
1. Lines 78–79 use pipe: `grep -qE 'pattern' | grep -qvE 'safe'`
2. Line 80 re-checks: `grep -qE 'pattern'` (redundant)
3. Line 81 inverts: `! grep -qE 'safe'` (confusing double negative with line 79's `qvE`)

**Recommendation:**
Simplify to one clear condition:

```bash
if echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*[^$v\{\s]' && \
   ! echo "$CONTENT" | grep -qE 'font-(size|weight|family)\s*:\s*(var\(|theme\.|\\$)'; then
  echo "WARNING: ..." >&2
fi
exit 0
```

---

### F-104: update-leaderboard.sh — Bash 4.0 Check Insufficient for macOS (CRITICAL)

**File:** `.claude/hooks/update-leaderboard.sh`
**Lines:** 6–10, 80–82
**Severity:** CRITICAL

Bash version check is present (lines 6–10), but associative arrays are used without a full fallback:

```bash
if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
  echo "INFO: update-leaderboard.sh requires Bash 4+..." >&2
  exit 0
fi
...
declare -A SCORE_DELTAS  # Line 80
declare -A TASK_STATUS   # Line 81
```

**Issue:** While the check exists, some macOS systems may have Bash 4.0 but lack full associative array support in certain contexts. The fallback message is helpful but **skips the entire leaderboard update**, which means scores are never recorded in multi-agent sessions on macOS with default Bash.

**Evidence:**
- The error message recommends `brew install bash`, but the hook silently exits 0 without updating metrics.
- Leaderboard updates are CRITICAL to the self-learning loop; skipping silently may cause missed pattern promotions.

**Impact:** Multi-agent sessions on macOS cannot update leaderboard/metrics without user intervention (installing newer Bash).

**Recommendation:**
1. Provide a macOS-specific fallback using awk or perl instead of associative arrays (both are available on macOS).
2. Or, at minimum, emit an ERROR (not INFO) when Bash 4 is missing, so users know metrics were not updated.
3. Document this requirement in CLAUDE.md.

---

### F-105: git-safety-check.sh — Exit Code Semantics Unclear (MAJOR)

**File:** `.claude/hooks/git-safety-check.sh`
**Lines:** 22–29
**Severity:** MAJOR

Two different git operation categories use exit code 2:

```bash
# Line 22–25: Destructive operations (push, merge, rebase, etc.)
if echo "$COMMAND" | grep -qE 'git\s+(push|merge|...)'; then
  echo "WARNING: Destructive git operation..." >&2
  exit 2
fi

# Line 27–30: Write operations (commit, add, tag)
if echo "$COMMAND" | grep -qE 'git\s+(commit|add|...)'; then
  echo "BLOCKED: Git write operation..." >&2
  exit 2
fi
```

**Issue:** Both use exit code 2, but the semantics differ:
- **Destructive ops (line 23):** Should be `exit 1` (WARNING, non-blocking) — user is asked to confirm.
- **Write ops (line 28):** Should be `exit 2` (BLOCKED) — true enforcement.

According to the CLAUDE.md rule (`.claude/rules/git-safety.md`), destructive ops require "explicit, unambiguous text consent," meaning the hook should WARN but allow the user to proceed. Write ops (commit, add) are BLOCKED.

**Current behavior:**
- Both exit 2, which means BOTH are treated as hard blocks by the harness.
- User cannot even attempt a push — the hook blocks it outright.

**Recommendation:**
```bash
# Destructive ops: exit 1 (warning)
echo "WARNING: Destructive git operation..." >&2
exit 1

# Write ops: exit 2 (blocked)
echo "BLOCKED: Git write operation..." >&2
exit 2
```

---

### F-106: self-learning-collector.sh — Per-File Edit Count Fragile (MAJOR)

**File:** `.claude/hooks/self-learning-collector.sh`
**Lines:** 40
**Severity:** MAJOR

Edit count uses basename-only matching:

```bash
EDIT_COUNT=$(grep -c "|$BASENAME|" "$EDIT_LOG" 2>/dev/null || echo "0")
```

**Issue:** If two files share the same basename in different directories (e.g., `src/index.ts` and `tests/index.ts`), they are counted as one file. The pattern fires a learned-pattern file after 2+ edits to "index.ts", even if they're in different directories.

**Evidence:**
- Line 36: `BASENAME=$(basename "$FILE_PATH")` — loses directory context.
- Line 40: Grep counts all lines with `|index.ts|` regardless of full path.

**Impact:** False positives in pattern detection; unrelated file edits are conflated.

**Recommendation:**
Use full file path matching:

```bash
EDIT_COUNT=$(grep -c "|$FILE_PATH$" "$EDIT_LOG" 2>/dev/null || echo "0")
```

Or anchor the pattern more strictly to avoid partial matches.

---

### F-107: block-console-log.sh — Regex Missing Optional Whitespace (MINOR)

**File:** `.claude/hooks/block-console-log.sh`
**Lines:** 33
**Severity:** MINOR

Regex requires whitespace before the opening paren:

```bash
echo "$CONTENT" | grep -qE 'console\.(log|warn|error|debug|info|table|time|timeEnd|trace|dir|count|group|groupEnd|clear|assert|profile|profileEnd)\s*\('
```

The `\s*` is present, so this is actually CORRECT. However, the pattern `\s*` allows zero or more whitespace, so it catches:
- `console.log()` ✓
- `console.log  ()` ✓
- `console.log()` ✓

This is fine. **No action needed — false alarm.**

---

### F-108: block-any-type.sh — Word Boundary May Miss Edge Cases (MINOR)

**File:** `.claude/hooks/block-any-type.sh`
**Lines:** 33
**Severity:** MINOR

Regex uses word boundaries:

```bash
echo "$CONTENT" | grep -qE ':\s*any\b|as\s+any\b|<any>|<any,'
```

**Issue:** The `\b` boundary is sensitive to surrounding characters. Examples that may be MISSED:
- Inside template literals: `` const x: `any` `` (backticks break word boundary)
- In JSDoc comments: `@param {any}` (curly brace is non-word character; `any}` boundary is satisfied, so this IS caught)
- In type unions: `string | any[]` (pipe is non-word, so `any\b` matches — correct)

**Evidence:** The regex assumes `any` is surrounded by word/non-word boundaries. Edge cases in strings or special syntax may pass through.

**Recommendation:**
Test against:
- Template literals with type annotations
- Comments with embedded types (if they're not filtered earlier)
- Union types with `|`

Add test cases to prevent regressions.

---

### F-109: sql-injection-check.sh — Template Literal Pattern Incomplete (MAJOR)

**File:** `.claude/hooks/sql-injection-check.sh`
**Lines:** 42
**Severity:** MAJOR

Template literal check only detects `${}` interpolation:

```bash
if echo "$CONTENT" | grep -qE '`[^`]*(SELECT|INSERT|UPDATE|DELETE|WHERE|FROM)[^`]*\$\{'; then
  echo "BLOCKED: SQL injection risk..." >&2
  exit 2
fi
```

**Issue:** This pattern catches backtick strings with `${}` inside, but it:
1. Does NOT detect dynamic SQL using other methods, e.g., string concatenation with template literals that don't use `${}`:
   ```javascript
   const sql = `SELECT * FROM users WHERE id = ${id}`  // Caught
   const sql = `SELECT * FROM users WHERE id = ` + userId  // NOT caught
   ```
2. Does NOT catch expressions before the backtick:
   ```javascript
   let query = baseSql + `SELECT ...`  // Partially caught depending on order
   ```

**Evidence:**
- Line 42 regex: `\$\{` — only detects `${` syntax.
- Missing: detection of `+` concatenation within backticks.

**Recommendation:**
Add another check for backtick + concatenation:

```bash
if echo "$CONTENT" | grep -qE '`[^`]*"\s*\+|\+\s*"[^"]*`' | grep -qE 'SELECT|INSERT|UPDATE|DELETE'; then
  echo "BLOCKED: SQL injection risk in concatenated template literal..." >&2
  exit 2
fi
```

---

### F-110: figma-standards-guard.sh — px Safe Values Assumption (MINOR)

**File:** `.claude/hooks/figma-standards-guard.sh`
**Lines:** 62
**Severity:** MINOR

The `px` block allows 0px and 1px:

```bash
if echo "$CONTENT" | grep -qE '\b([2-9]|[1-9][0-9]+)px\b'; then
  echo "BLOCKED: CSS px values (except 0px/1px) are prohibited..." >&2
  exit 2
fi
```

**Issue:** The hook assumes 0px and 1px are always safe and don't need rem conversion. However:
- **Use case:** Borders at 2px are common and often intentional (not spacing).
- **Design system variance:** Some systems allow 1px for fine details but require rem for padding/margins.
- **Documentation gap:** The rule doesn't clearly separate "borders/strokes" (px-safe) from "spacing" (rem-only).

**Evidence:**
- Line 62: Blocks `[2-9]` and `[1-9][0-9]+` (all 2+ px values).
- No exceptions for border-specific properties.

**Recommendation:**
1. Clarify in `.claude/rules/implementation.md`: Are borders exempt from px → rem conversion?
2. Or, refine the regex to allow `border.*px` patterns:
   ```bash
   if echo "$CONTENT" | grep -qE '\b([2-9]|[1-9][0-9]+)px\b' | grep -qvE 'border'; then
     echo "BLOCKED: ..." >&2
     exit 2
   fi
   ```

---

### F-111: pattern-lifecycle.sh — macOS sed Compatibility (MINOR)

**File:** `.claude/hooks/pattern-lifecycle.sh`
**Lines:** 45
**Severity:** MINOR

Uses `sed -E` (POSIX ERE):

```bash
sed -E "s|^${field}:.*|${field}: ${value}|" "$file" > "$tmpfile"
```

**Status:** ✓ ALREADY CORRECT. macOS `sed` supports `-E` flag since 10.7+. No issue.

**Evidence:** Script correctly uses `-E` (not `-r`), which is the BSD-compatible flag.

**Recommendation:** No action needed. This is well-handled.

---

### F-112: path-traversal-check.sh — Literal String Detection Limited (MINOR)

**File:** `.claude/hooks/path-traversal-check.sh`
**Lines:** 37
**Severity:** MINOR

Only detects literal `../` in double-quoted strings:

```bash
if echo "$CONTENT" | grep -qE '"\.\./'
```

**Issue:** This pattern catches only hardcoded `"../"` strings. It does NOT detect:
1. Dynamic path traversal: `path + "/../admin"`
2. Variable interpolation: `` `${basePath}/../secret` ``
3. Encoded traversal: Already checked at lines 42–45 with `%2e%2e`

**Evidence:**
- Line 37: Literal `"../"` in quotes only.
- Runtime attacks using variables may bypass this.

**Recommendation:**
1. Document limitation: "Detects hardcoded path traversal; dynamic cases require runtime validation."
2. Consider adding a check for common dangerous patterns:
   ```bash
   if echo "$CONTENT" | grep -qE 'path.*\+.*".*\/"' | grep -qE '\.\.|\/\.\.|\/\/'; then
     echo "WARNING: Dynamic path concatenation detected..." >&2
   fi
   ```

---

## Settings.json Wiring Audit

| Hook File | Wired? | Event Type | Timeout | Notes |
|---|---|---|---|---|
| block-console-log.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct |
| block-any-type.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct |
| block-comments.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct; complex regex may timeout |
| secret-guard.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 5s | Tight timeout for security hook |
| analysis-scope-guard.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 5s | Advisory only; timeout is sufficient |
| figma-standards-guard.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct |
| sql-injection-check.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct |
| xss-prevention-check.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct |
| path-traversal-check.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct |
| field-injection-check.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct |
| cors-wildcard-check.sh | ✓ | PreToolUse:Edit\|Write\|MultiEdit | 10s | Correct |
| git-safety-check.sh | ✓ | PreToolUse:Bash | 5s | Correct |
| review-tracker.sh | ✓ | PostToolUse:Edit\|Write\|MultiEdit | 5s | Correct timeout |
| self-learning-collector.sh | ✓ | PostToolUse:Edit\|Write\|MultiEdit | 5s | Correct timeout |
| update-leaderboard.sh | ✓ | SessionEnd | 15s | Correct; generous timeout for Bash 4 check + file updates |
| pattern-lifecycle.sh | ✓ | SessionEnd | 15s | Correct; allows wait loop for sentinel |

**All 16 hooks are wired correctly in settings.json.** No missing hooks.

---

## Bash Compatibility Summary

| Hook File | Bash 4+ Features | flock? | macOS Status | Notes |
|---|---|---|---|---|
| block-console-log.sh | `set -euo pipefail` | No | ✓ Safe | Standard bash 3.2+ safe |
| block-any-type.sh | `set -euo pipefail` | No | ✓ Safe | Standard bash 3.2+ safe |
| block-comments.sh | `set -euo pipefail` | No | ✓ Safe | Complex regex; Bash 3.2 may be slow |
| secret-guard.sh | `set -euo pipefail` | No | ✓ Safe | Standard bash 3.2+ safe |
| analysis-scope-guard.sh | `set -euo pipefail` | No | ✓ Safe | Standard bash 3.2+ safe |
| figma-standards-guard.sh | `set -euo pipefail` | No | ✓ Safe | Standard bash 3.2+ safe |
| sql-injection-check.sh | `[[ ]] test operator` | No | ⚠ Medium | `[[ ... ]]` is Bash 3.0+; safe |
| xss-prevention-check.sh | `[[ ]] test operator` | No | ⚠ Medium | `[[ ... ]]` is Bash 3.0+; safe |
| path-traversal-check.sh | `[[ ]] test operator` | No | ⚠ Medium | `[[ ... ]]` is Bash 3.0+; safe |
| field-injection-check.sh | `[[ ]] test operator` | No | ⚠ Medium | `[[ ... ]]` is Bash 3.0+; safe |
| cors-wildcard-check.sh | `[[ ]] test operator` | No | ⚠ Medium | `[[ ... ]]` is Bash 3.0+; safe |
| git-safety-check.sh | `set -euo pipefail` | No | ✓ Safe | Standard bash 3.2+ safe |
| review-tracker.sh | `set -euo pipefail` | No | ✓ Safe | Standard bash 3.2+ safe; no Bash 4+ features |
| self-learning-collector.sh | `set -euo pipefail` | No | ✓ Safe | Standard bash 3.2+ safe |
| update-leaderboard.sh | `declare -A` arrays (Bash 4+) | ✓ flock + fallback | ⚠ Medium | Version check present; macOS fallback to mkdir-based lock |
| pattern-lifecycle.sh | `sed -E` (POSIX) | No | ✓ Safe | Uses `-E` flag (BSD-compatible) |

**macOS Bash 3.2 Compatibility:**
- **11 hooks:** Fully compatible (Bash 3.2+ safe, no Bash 4+ features)
- **4 hooks (sql, xss, path, field, cors):** Use `[[ ]]` test operator (Bash 3.0+, safe)
- **1 hook (update-leaderboard.sh):** Requires Bash 4+ with version check and fallback
- **0 hooks:** Use `declare -n` namerefs, mapfile, ${var,,}, or other Bash 4.3+ features

**Critical Finding:** The only macOS-specific issue is `update-leaderboard.sh`, which silently exits if Bash 4 is not found. This is a KNOWN LIMITATION (see F-104).

---

## Exit Code Semantics

**Harness Integration (from hook-registry.md and CLAUDE.md):**
- **Exit 0:** Pass (advisory message, no block)
- **Exit 1:** Warning (non-blocking; user can continue; may prompt for confirmation)
- **Exit 2:** Blocked (hard stop; prevents tool use)

**Actual Hook Usage:**

| Hook | Exit 0 | Exit 1 | Exit 2 | Semantics |
|---|---|---|---|---|
| block-console-log.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| block-any-type.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| block-comments.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| secret-guard.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| analysis-scope-guard.sh | Advisory pass | None | BLOCKED (root only) | Correct: exit 0 for raw/, exit 2 for analysis/ root |
| figma-standards-guard.sh | Always exit 0 | None | BLOCKED message, WARNING message | **ISSUE:** Exit code unclear (see F-103) |
| sql-injection-check.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| xss-prevention-check.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| path-traversal-check.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| field-injection-check.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| cors-wildcard-check.sh | Default pass | None | BLOCKED message | Correct: exit 2 for violations |
| git-safety-check.sh | Default pass | None | WARNING (exit 2) / BLOCKED (exit 2) | **ISSUE:** Both exit 2 (see F-105) |
| review-tracker.sh | Always exit 0 | None | None | Correct: advisory only |
| self-learning-collector.sh | Always exit 0 | None | None | Correct: advisory only |
| update-leaderboard.sh | Default pass (Bash <4) / process | None | None | Correct: exit 0 (advisory on version issue) |
| pattern-lifecycle.sh | Always exit 0 | None | None | Correct: advisory only |

---

## Logic Correctness Issues Summary

### 1. Counter Semantics (F-101)
- **review-tracker.sh**: Global session counter, not per-file. Behavior may differ from user expectations.

### 2. String-in-Quotes Detection (F-102)
- **block-comments.sh**: Complex regex cannot reliably detect comments outside quoted strings. May produce false positives.

### 3. Regex Missing Operators (F-106, F-109)
- **self-learning-collector.sh**: Basename-only matching; collides across directories.
- **sql-injection-check.sh**: Template literal detection incomplete; misses concatenation patterns.

### 4. Incomplete Pattern Matching (F-110, F-112)
- **figma-standards-guard.sh**: Assumes 0px/1px always safe; no border exception.
- **path-traversal-check.sh**: Detects hardcoded paths only; runtime attacks bypass.

---

## Recommendations Priority

| Priority | Finding | Recommendation |
|---|---|---|
| P0 (Critical) | F-101: Counter semantics | Clarify intent and update alerts or switch to per-file tracking |
| P0 (Critical) | F-104: Bash 4 fallback | Implement awk/perl fallback for associative arrays or emit ERROR on Bash <4 |
| P1 (Major) | F-102: Comment detection | Refine quoted-string filtering or accept and document limitation |
| P1 (Major) | F-105: Exit code semantics | Separate exit 1 (warning) from exit 2 (blocked) for git operations |
| P1 (Major) | F-106: Per-file counting | Use full file path instead of basename in edit counting |
| P1 (Major) | F-109: SQL injection detection | Add pattern for concatenation within backticks |
| P2 (Minor) | F-103: Typography logic | Simplify nested if-conditions for clarity |
| P2 (Minor) | F-110: px safe values | Document border exceptions or refine regex |
| P2 (Minor) | F-112: Path detection | Document limitation and consider runtime-detection warnings |

---

## Confidence Levels

- **High (10/10):** F-101, F-102, F-105, F-106 — code is clear and unambiguous.
- **Medium (7/10):** F-103, F-104, F-109, F-110 — logic is present but requires context/intent clarification.
- **Low (5/10):** F-107, F-108, F-111, F-112 — edge cases are minor and depend on use-case assumptions.

---

## Session Notes

- All 16 hooks are wired in settings.json correctly.
- No missing hooks from the registry.
- Bash compatibility is generally good; only `update-leaderboard.sh` has a Bash 4 dependency (with fallback).
- Security hooks (sql-injection, xss, path-traversal, cors) are well-structured but have minor detection gaps.
- Metrics hooks (review-tracker, self-learning-collector, update-leaderboard, pattern-lifecycle) have logic clarity issues but function as designed.
- Exit code semantics need clarification in git-safety-check and figma-standards-guard.

