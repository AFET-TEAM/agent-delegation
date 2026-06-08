# Improvement Plan — Sprint 2026-05-21

**Author**: Enis Sait Erken (T2 Staff Engineer)
**Session**: 2026-05-21-deep-analysis-html-docs-x10
**Task**: G05
**Source**: G03-gap-priority-matrix.md + G01-deep-system-audit.md
**Status**: Ready for T3-A and T3-B execution

---

## Architectural Decisions

### Decision 1: T3 Budget Canonical Value

**Chosen**: **5K** (from `context-budget.json`)

**Rationale**: `context-budget.json` is the machine-readable file parsed by hooks and validators at runtime. `tier-definitions.md` shows the PCD token budget as "4K" in a prose table that covers PCD context files — a different dimension than `max_tokens_per_task`. The JSON value of 5000 represents the actual task token ceiling used by the pre-spawn validator. Aligning to 4K would under-budget T3 agents given observed session token usage. The inconsistency is a labeling error in `tier-definitions.md` (it says "4K PCD tokens" but that column means PCD file token budget, not per-task ceiling). **Action**: Update `tier-definitions.md` column header and prose to clarify that PCD Tokens ≠ `max_tokens_per_task`, and add a note that the machine-readable value is in `context-budget.json`. No change to `context-budget.json`.

**Files affected**:
- `.claude/config/tier-definitions.md` — add footnote clarifying PCD Tokens vs task ceiling
- `.claude/config/context-budget.md` — update T3 summary line from "4K PCD tokens" to "5K task ceiling / 4K PCD tokens"

---

### Decision 2: Tier Multiplier Scale

**Chosen**: **Option A — Update hook to return decimals**

**Rationale**: The `name-pool.md` documentation is the user-facing reference. Users reading the docs see `x2.0, x1.5, x1.0, x0.8, x0.5`. The hook's integer scale (`20, 15, 10, 8, 5`) is an internal implementation detail that contradicts this. Integer weights produce the same *relative* selection probability, but the value mismatch causes confusion when operators audit the `compute_tier_multiplier()` function against the docs. Since the formula in `name-pool.md` is `final_weight = max(score + 101, 1) * tier_multiplier`, returning decimals directly from the function is the clearest fix. The arithmetic works identically — floating-point multiplication in bash via `awk`.

**Files affected**:
- `.claude/hooks/update-leaderboard.sh` — convert `compute_tier_multiplier()` to return decimals; update weight multiplication to use `awk`

---

### Decision 3: Bash 4+ Requirement

**Chosen**: **Option B — Warning + graceful degradation with documented limitations**

**Rationale**: `update-leaderboard.sh` already implements graceful degradation (exit 0 with INFO message). The current behavior is correct. The problem is *discoverability*: the warning appears only in the hook's stderr at session end, not during setup. The fix is to surface the requirement prominently in `setup.sh` (a loud `warn` instead of silent omission) and in `GETTING_STARTED.md`. Making setup exit on Bash <4 would break CI/CD pipelines and container environments where users may intentionally run without leaderboard support. Option B preserves that flexibility while removing the "silent skip" UX confusion.

**Files affected**:
- `.claude/scripts/setup.sh` — add explicit Bash version check with `warn` output and install link
- `.claude/docs/GETTING_STARTED.md` — document limitation in Prerequisites section

---

## P0 Tasks — Sprint Must-Have

### P0.1: Create `.claude/metrics/fallback-log.md`

**Owner**: T3-A
**Estimated Tokens**: ~1K
**Dependencies**: None

**Exact content to create**:

```markdown
# Model Fallback Log

Referenced by: `.claude/config/model-registry.md:45`

## Format

Each fallback event is logged as a table row below. The Orchestrator or hook writes entries when a model fallback occurs.

| Date | Session | Agent | Tier | Primary Model | Fallback Model | Reason |
|------|---------|-------|------|---------------|----------------|--------|
```

**File path**: `/Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/metrics/fallback-log.md`

**Verification**:
```bash
ls .claude/metrics/fallback-log.md
grep "Primary Model" .claude/metrics/fallback-log.md
grep "model-registry.md" .claude/metrics/fallback-log.md
```

Expected: file exists, header row present, back-reference to model-registry.md present.

---

### P0.2: Create `.claude/skills/test-gen/SKILL.md`

**Owner**: T3-A
**Estimated Tokens**: ~2K
**Dependencies**: None

**Note**: The `test-gen` directory already exists but is empty. Create `SKILL.md` inside it.

**Exact content to create**:

```markdown
---
name: test-gen
description: Generate test suites from implementation files. Supports Jest, Vitest, and pytest. Produces AAA-structured tests covering happy path, error paths, and edge cases.
---

# Test Generation Skill

## Purpose

Generates test suites for existing implementation files. Takes one or more source files as input and produces corresponding test files following the AAA (Arrange-Act-Assert) pattern.

## Activation

Use this skill via the T3 MidCoder agent when:
- A new feature or service has been implemented without tests
- An existing module needs test coverage increased
- The task explicitly requests test generation

## Supported Frameworks

| Framework | Language | Config Detection |
|-----------|----------|-----------------|
| Jest | TypeScript / JavaScript | `jest.config.*` or `"jest"` in `package.json` |
| Vitest | TypeScript / JavaScript | `vitest.config.*` or `"vitest"` in `package.json` |
| pytest | Python | `pytest.ini`, `pyproject.toml [tool.pytest]`, or `setup.cfg [tool:pytest]` |

## Usage

### Trigger Phrase

Ask the Orchestrator or T3 agent:
```
"Generate tests for src/features/user/user-service.ts"
"Add test coverage for the auth module"
"Write tests for UserRepository"
```

### What Gets Generated

For each source file, the skill produces:

1. **Unit tests** — covering each exported function/class method
2. **Error path tests** — for every `catch` block and thrown error
3. **Edge case tests** — boundary values, null/undefined inputs, empty collections

### Output Location

Tests are co-located with the source file:
- `src/features/user/user-service.ts` → `src/features/user/user-service.test.ts`
- `src/features/user/user-repository.ts` → `src/features/user/user-repository.test.ts`

For Python:
- `src/services/user_service.py` → `tests/test_user_service.py`

## Test Structure (TypeScript/Jest/Vitest)

Generated tests follow the pattern from `.claude/rules/implementation.md`:

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should return created user when input is valid', async () => {
      // Arrange
      const repository = createMockUserRepository();
      const service = new UserService(repository);
      const input = buildValidUserInput();

      // Act
      const result = await service.createUser(input);

      // Assert
      expect(result.email).toBe(input.email);
    });

    it('should throw ValidationError when email is already taken', async () => {
      // Arrange
      const repository = createMockUserRepository({
        findByEmail: async () => buildExistingUser(),
      });
      const service = new UserService(repository);

      // Act & Assert
      await expect(service.createUser(buildValidUserInput())).rejects.toThrow(ValidationError);
    });
  });
});
```

## Naming Convention

Test function naming follows: `should [expected behavior] when [condition]`

Examples:
- `should return null when user not found`
- `should throw ValidationError when email format is invalid`
- `should call repository.save with correct user data when input is valid`

## Quality Checklist

Before marking test generation complete:

- [ ] Every exported function/method has at least one test
- [ ] Every error path (catch block, thrown error) has a test
- [ ] Factory functions used for test data (no inline object literals)
- [ ] Mocks placed at the boundary (repository, HTTP client), not internal functions
- [ ] Test file passes the test runner with zero failures
- [ ] No `console.log` in test files
- [ ] No `any` type in test files

## Limitations

- Does not generate integration tests (those require environment setup)
- Does not generate snapshot tests for React components (use Storybook for visual regression)
- Does not infer business rules from comments — reads only the actual function signatures and code paths

## References

- `.claude/rules/implementation.md` §Test Writing Guide — AAA pattern, naming convention, rules
- `.claude/rules/code-review.md` §Testing — review checklist for tests
```

**File path**: `/Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/skills/test-gen/SKILL.md`

**Verification**:
```bash
ls .claude/skills/test-gen/SKILL.md
grep "Jest\|Vitest\|pytest" .claude/skills/test-gen/SKILL.md
grep "should.*when" .claude/skills/test-gen/SKILL.md
```

Expected: file exists, all 3 frameworks mentioned, naming convention example present.

---

### P0.3: Create `.claude/docs/hook-exit-codes.md`

**Owner**: T3-A
**Estimated Tokens**: ~2K
**Dependencies**: None

**Note**: Verify against `block-console-log.sh` (uses exit 0 and exit 2) before writing. File confirmed absent from `.claude/docs/`.

**Exact content to create**:

```markdown
# Hook Exit Code Semantics

Referenced by hooks in `.claude/hooks/` and monitored by Claude Code harness.

## Exit Code Reference

| Exit Code | Meaning | Claude Code Action | When Used |
|-----------|---------|-------------------|-----------|
| `0` | PASS | Allow the tool call to proceed | Hook ran successfully; no violation detected |
| `1` | ERROR | Report hook error; tool call may proceed (non-blocking) | Hook script itself failed (missing dependency, parse error) |
| `2` | BLOCK | Block the tool call; show error message to agent | Violation detected; operation must not proceed |

## Semantics Detail

### Exit 0 — PASS

The hook completed without finding a violation. The pending tool call (Edit, Write, Bash, etc.) is allowed to proceed.

Used when:
- Content was scanned and no prohibited patterns found
- The file type is exempt (e.g., `.md`, `.sh`, `.json` for `block-console-log.sh`)
- No relevant content was provided in the tool input

### Exit 1 — ERROR

The hook script encountered an internal error (e.g., `jq` not found, invalid JSON input, required environment variable missing). This exit code signals a hook infrastructure problem, not a code violation. Claude Code treats this as non-blocking by default — the tool call proceeds, but the hook failure is reported.

Used when:
- `jq` parse fails on malformed input
- `CLAUDE_PROJECT_DIR` is not set (though most hooks use `set -euo pipefail` which triggers before exit 1)
- A dependency command is missing

> **Note**: Due to `set -euo pipefail` in most hooks, unhandled errors exit with code 1. Operators should check stderr output for the `BLOCKED:` prefix to distinguish code violations (exit 2) from hook errors (exit 1).

### Exit 2 — BLOCK

The hook detected a policy violation in the pending operation. Claude Code blocks the tool call and displays the hook's stderr output as an error message to the agent.

Used when:
- `console.log` or `console.*` statement detected in non-exempt file
- `any` TypeScript type detected
- SQL string concatenation detected
- Hardcoded secret or credential detected
- Prohibited git operation attempted without consent

## Per-Hook Exit Code Usage

| Hook | Exit 0 Condition | Exit 2 Condition |
|------|-----------------|-----------------|
| `block-console-log.sh` | File type exempt OR no `console.*` found | `console.*` or `alert/confirm/prompt` found |
| `block-any-type.sh` | No `: any` or `@ts-ignore` found | `: any` or `@ts-ignore` detected |
| `block-comments.sh` | No inline comments found | `//`, `/* */`, `TODO`, `FIXME` detected |
| `secret-guard.sh` | No credential patterns found | API key, password, token patterns detected |
| `sql-injection-check.sh` | No string concatenation in SQL | SQL built via string concat/format |
| `xss-prevention-check.sh` | No unsafe HTML patterns found | `innerHTML`, `dangerouslySetInnerHTML`, `eval` detected |
| `path-traversal-check.sh` | No unsanitized path operations | `..` in user-controlled path operations |
| `cors-wildcard-check.sh` | No `*` CORS origin | Wildcard origin configured |
| `field-injection-check.sh` | No `@Autowired` on fields | `@Autowired` field injection found |
| `figma-standards-guard.sh` | No hardcoded px/hex/inline styles | Design token violations found |
| `analysis-scope-guard.sh` | Within allowed scope | Write to `.claude/analysis/` root (T1-T3) |
| `git-safety-check.sh` | Safe read-only git op OR consent present | Destructive git op without explicit consent |
| `context-mode-guard.sh` | No denied paths or exfiltration tools | Access to `~/.ssh/`, `.env`, denied network targets |

## Stderr Output Format

When a hook exits 2, it writes a `BLOCKED:` prefixed message to stderr:

```
BLOCKED: console.* statements are prohibited in production code. Use a structured logging service instead.
```

When a hook exits 1 (error), it writes an `INFO:` or `ERROR:` prefixed message:

```
INFO: update-leaderboard.sh requires Bash 4+. macOS default is 3.2 — install via 'brew install bash'. Skipping leaderboard update.
```

## Adding a New Hook

When writing a new hook, follow this exit code contract:

```bash
#!/usr/bin/env bash
set -euo pipefail

: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

# Parse tool input...
CONTENT=$(...)

# Exempt file types
case "$FILE_PATH" in
  *.md|*.json|*.sh) exit 0 ;;
esac

# Check for violation
if echo "$CONTENT" | grep -qE 'prohibited_pattern'; then
  echo "BLOCKED: Description of what was blocked and why." >&2
  exit 2
fi

exit 0
```

Key rules:
- Always exit 0 at the end (explicit PASS)
- Always exit 2 for violations (never exit 1 for policy blocks)
- Always write `BLOCKED:` prefix on stderr for exit 2
- Always write `INFO:` or `WARN:` prefix on stderr for informational messages

## References

- `.claude/config/hook-registry.md` — complete list of all 19 hooks
- `.claude/rules/backend-security.md` §Enforcement Hooks — security hook registry
- CLAUDE.md §Enforcement Layers — overall enforcement architecture
```

**File path**: `/Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/docs/hook-exit-codes.md`

**Verification**:
```bash
ls .claude/docs/hook-exit-codes.md
grep "Exit Code 0\|Exit 0\|PASS" .claude/docs/hook-exit-codes.md
grep "Exit Code 2\|Exit 2\|BLOCK" .claude/docs/hook-exit-codes.md
grep "BLOCKED:" .claude/docs/hook-exit-codes.md
```

Expected: file exists, all 3 exit codes documented, per-hook table present, BLOCKED: format documented.

---

### P0.4: Align T3 Budget Documentation (Decision 1 Implementation)

**Owner**: T3-A
**Estimated Tokens**: ~1K
**Dependencies**: Decision 1 (resolved above — 5K canonical in JSON)

**File 1**: `.claude/config/tier-definitions.md`

Current line 23 (T3 row):
```
| T3 MidCoder | 4 | 6 | 3 | 4K | Full |
```

Change "4K" in the PCD Tokens column to "5K*" and add a footnote after the table:

```
> **\*T3 PCD Tokens**: The "4K" figure in earlier documentation referred to PCD context file budget. The machine-readable `max_tokens_per_task` for T3 is **5000** as defined in `context-budget.json`. For task ceiling purposes, use the JSON value. PCD token budget (for context files only) remains 4K.
```

**Exact edit — add after the Tier Token Budget table (after line 25 in tier-definitions.md)**:

```markdown
> **T3 Note**: `max_tokens_per_task` in `context-budget.json` is 5000 (5K). The "4K" column above represents PCD (Project Context Document) file token budget — a separate constraint. For task overflow checks, the binding value is the JSON `max_tokens_per_task`.
```

**File 2**: `.claude/config/context-budget.md`

Current line 12:
```
- **T3 MidCoder**: Up to 4K PCD tokens, 6 context files
```

Change to:
```
- **T3 MidCoder**: Up to 5K task tokens (`max_tokens_per_task` in context-budget.json), 4K PCD tokens, 6 context files
```

**Verification**:
```bash
grep "T3\|MidCoder" .claude/config/context-budget.md
grep "T3 Note\|5000\|5K" .claude/config/tier-definitions.md
grep "5K\|5000" .claude/config/context-budget.json
```

Expected: context-budget.md T3 line shows "5K task tokens", tier-definitions.md has clarifying note, JSON unchanged at 5000.

---

### P0.5: Fix Tier Multiplier Scale in `update-leaderboard.sh` (Decision 2 Implementation)

**Owner**: T3-A
**Estimated Tokens**: ~2K
**Dependencies**: None (arithmetic outcome identical; only representation changes)

**File**: `.claude/hooks/update-leaderboard.sh`

**Current `compute_tier_multiplier()` function (lines 48–61)**:
```bash
compute_tier_multiplier() {
  local score="$1"
  if [ "$score" -ge 50 ]; then
    echo "20"
  elif [ "$score" -ge 20 ]; then
    echo "15"
  elif [ "$score" -ge 0 ]; then
    echo "10"
  elif [ "$score" -ge -20 ]; then
    echo "8"
  else
    echo "5"
  fi
}
```

**Replace with** (decimal output, awk-based weight multiplication):
```bash
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
```

**Important**: The function output is used as a multiplier in weight calculation. Search for all usages of `compute_tier_multiplier` in the script and ensure any arithmetic that multiplies by the output uses `awk` for floating-point math rather than bash integer arithmetic. Check for any line like:

```bash
WEIGHT=$(( ... * MULTIPLIER ))
```

If present, change to:
```bash
WEIGHT=$(awk "BEGIN { printf \"%.4f\", ($BASE_WEIGHT) * ($MULTIPLIER) }")
```

**Verification**:
```bash
grep "compute_tier_multiplier" .claude/hooks/update-leaderboard.sh
grep "2\.0\|1\.5\|1\.0\|0\.8\|0\.5" .claude/hooks/update-leaderboard.sh
shellcheck .claude/hooks/update-leaderboard.sh
```

Expected: function returns decimal values matching name-pool.md table, shellcheck passes with no errors.

---

## P1 Tasks — Sprint Should-Have

### P1.1: Add `graphify-rebuild.sh` to `hook-registry.md` Main Table

**Owner**: T3-A
**Estimated Tokens**: ~1K
**Dependencies**: None

**Note**: `graphify-rebuild.sh` currently appears only in the PostToolUse section note at line 54. It IS already listed in the PostToolUse:Edit/Write/MultiEdit table (line 34). Reading the current file confirms it is present in the main table. **Re-verify before editing**: if it is already in the table, this task is a no-op. If the note was the only mention, add to the table.

**Current state confirmed** (from hook-registry.md read):
```
| graphify-rebuild.sh | Mark graphify graph as stale when source files change | graphify-out/.graphify-stale (in analyzed codebase) |
```

This entry IS in the PostToolUse table at line 34. The audit finding (I-009) said it was "only in Note" — this appears to be a false finding or was corrected already. **T3-A should verify by reading `.claude/config/hook-registry.md` line 34 before making any change.**

If line 34 already contains `graphify-rebuild.sh`, mark P1.1 as complete with no edits needed.

If it is absent from the table, add this row to the PostToolUse:Edit/Write/MultiEdit table:
```markdown
| graphify-rebuild.sh | Mark graphify graph as stale when source files change | graphify-out/.graphify-stale (in analyzed codebase) |
```

**Verification**:
```bash
grep "graphify-rebuild" .claude/config/hook-registry.md
```

Expected: exactly one occurrence in the PostToolUse table (not just in the Note).

---

### P1.2: Create `.claude/docs/GETTING_STARTED.md`

**Owner**: T3-B
**Estimated Tokens**: ~4K

**Scope**: 250–400 lines. New user onboarding guide covering the full 6-step workflow with a concrete example session.

**Required sections** (T3-B to produce verbatim content):

1. **Prerequisites** — Node 18+, Python 3.10+ (for graphify), Bash 4+ (for leaderboard), jq, awk
2. **Installation** — `bash .claude/scripts/setup.sh` and what it does
3. **First Session** — Run a simple x2 session step by step
4. **Understanding the Tiers** — T1–T5 in plain language with use cases
5. **xN Parameter Guide** — When to use x2 vs x5 vs x10; cost vs depth tradeoff
6. **The Review Chain** — What happens after coding agents finish; how escalation works
7. **Session Output** — What to expect: Performance Report, session file, learned patterns
8. **Bash 4+ Setup on macOS** — `brew install bash` + shebang note; consequence if skipped (leaderboard silently skips)
9. **Troubleshooting Quick Reference** — Top 5 errors and how to fix them (links to full TROUBLESHOOTING.md once created)

**File path**: `/Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/docs/GETTING_STARTED.md`

**Verification**:
```bash
wc -l .claude/docs/GETTING_STARTED.md
grep "Bash 4\|brew install bash" .claude/docs/GETTING_STARTED.md
grep "Prerequisites\|Installation\|First Session\|Tier\|xN\|Review Chain" .claude/docs/GETTING_STARTED.md
```

Expected: 250–400 lines, all required section headers present, Bash 4+ macOS instructions included.

---

### P1.3: Create `.claude/scripts/verify-install.sh`

**Owner**: T3-A
**Estimated Tokens**: ~3K
**Dependencies**: All P0 config tasks should be complete so the script can reference the correct file set

**Required checks** (script must implement all):

1. All 19 hook files exist and are executable (`chmod +x` verified)
2. All config JSON files are valid JSON (using `jq .` test)
3. Node.js version >= 18
4. Python 3.10+ (optional; warn if absent)
5. `jq` available
6. `awk` available
7. `flock` available OR mkdir-lock fallback documented
8. `CLAUDE_PROJECT_DIR` environment variable is set
9. All 19 hooks listed in hook-registry.md have corresponding files
10. `graphify` command available (optional; warn if absent)
11. Bash version >= 4 (warn if not; explain leaderboard impact)

**Output format**: Each check prints `✓ pass` or `✗ FAIL` or `! warn` with a message. Exit code: 0 if all required checks pass (warns are non-fatal), 1 if any required check fails.

**Exact skeleton to implement**:

```bash
#!/usr/bin/env bash
set -euo pipefail

PROJ="${CLAUDE_PROJECT_DIR:-.}"
PASS=0
WARN=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
warn() { echo "  ! $1"; WARN=$((WARN+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Claude Code Multi-Agent System — Install Verification"
echo "======================================================="

echo ""
echo "[ Runtime Dependencies ]"

# Node.js
if command -v node >/dev/null 2>&1; then
  NODE_VER=$(node -e "process.stdout.write(process.version.slice(1).split('.')[0])")
  [ "$NODE_VER" -ge 18 ] && ok "Node.js $(node --version)" || fail "Node.js v18+ required (found $(node --version))"
else
  fail "Node.js not found — install from https://nodejs.org"
fi

# Python
PYTHON_FOUND=false
for py in python3 python; do
  if command -v "$py" >/dev/null 2>&1; then
    PY_VER=$("$py" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null || true)
    PY_MAJOR=$(echo "$PY_VER" | cut -d. -f1)
    PY_MINOR=$(echo "$PY_VER" | cut -d. -f2)
    if [ "${PY_MAJOR:-0}" -ge 3 ] && [ "${PY_MINOR:-0}" -ge 10 ]; then
      ok "Python $PY_VER"
      PYTHON_FOUND=true
      break
    fi
  fi
done
[ "$PYTHON_FOUND" = false ] && warn "Python 3.10+ not found — graphify will not be available"

# Bash version
BASH_VER="${BASH_VERSINFO[0]:-0}"
if [ "$BASH_VER" -ge 4 ]; then
  ok "Bash $BASH_VERSION"
else
  warn "Bash 4+ recommended (found $BASH_VERSION) — leaderboard updates will be skipped. Install: brew install bash"
fi

# jq
command -v jq >/dev/null 2>&1 && ok "jq $(jq --version)" || warn "jq not found — hooks use grep fallback (install for better performance)"

# awk
command -v awk >/dev/null 2>&1 && ok "awk available" || fail "awk not found — required for hook scoring calculations"

# flock
if command -v flock >/dev/null 2>&1; then
  ok "flock available (atomic leaderboard writes)"
else
  warn "flock not found — using mkdir fallback for leaderboard locking (safe but less robust)"
fi

# graphify
command -v graphify >/dev/null 2>&1 && ok "graphify available" || warn "graphify not found — T5 analysis will use direct file reads. Install: uv tool install 'graphifyy[all]'"

echo ""
echo "[ Hook Files ]"

HOOKS=(
  block-any-type.sh block-comments.sh block-console-log.sh secret-guard.sh
  analysis-scope-guard.sh figma-standards-guard.sh sql-injection-check.sh
  xss-prevention-check.sh path-traversal-check.sh cors-wildcard-check.sh
  field-injection-check.sh git-safety-check.sh context-mode-guard.sh
  review-tracker.sh self-learning-collector.sh graphify-rebuild.sh
  update-leaderboard.sh pattern-lifecycle.sh graphify-audit.sh
)
HOOKS_DIR="$PROJ/.claude/hooks"
for h in "${HOOKS[@]}"; do
  if [ -f "$HOOKS_DIR/$h" ]; then
    [ -x "$HOOKS_DIR/$h" ] && ok "$h" || fail "$h exists but not executable — run: chmod +x $HOOKS_DIR/$h"
  else
    fail "$h missing from $HOOKS_DIR"
  fi
done

echo ""
echo "[ Config Files ]"

JSON_CONFIGS=(
  ".claude/config/context-budget.json"
)
for f in "${JSON_CONFIGS[@]}"; do
  FPATH="$PROJ/$f"
  if [ -f "$FPATH" ]; then
    jq . "$FPATH" >/dev/null 2>&1 && ok "$f — valid JSON" || fail "$f — invalid JSON (run: jq . $FPATH)"
  else
    fail "$f missing"
  fi
done

MD_CONFIGS=(
  ".claude/config/tier-definitions.md"
  ".claude/config/context-budget.md"
  ".claude/config/hook-registry.md"
  ".claude/config/name-pool.md"
  ".claude/config/model-registry.md"
  ".claude/config/delegation-rules.md"
  ".claude/config/task-assignment-matrix.md"
)
for f in "${MD_CONFIGS[@]}"; do
  FPATH="$PROJ/$f"
  [ -f "$FPATH" ] && ok "$f" || fail "$f missing"
done

echo ""
echo "[ Metrics & Memory Directories ]"

DIRS=(
  ".claude/metrics"
  ".claude/memory/sessions"
  ".claude/memory/learned-patterns"
  ".claude/analysis/raw"
  ".claude/analysis/consolidated"
  ".claude/docs"
  ".claude/scripts"
)
for d in "${DIRS[@]}"; do
  [ -d "$PROJ/$d" ] && ok "$d/" || warn "$d/ not found — will be created on first use"
done

# fallback-log.md check
[ -f "$PROJ/.claude/metrics/fallback-log.md" ] && ok ".claude/metrics/fallback-log.md" || warn ".claude/metrics/fallback-log.md missing — run improvement plan P0.1 to create"

echo ""
echo "======================================================="
echo "Results: $PASS passed | $WARN warnings | $FAIL failed"
if [ "$FAIL" -gt 0 ]; then
  echo "RESULT: FAIL — $FAIL critical issue(s) must be resolved"
  exit 1
else
  echo "RESULT: PASS — system ready (review $WARN warning(s) above)"
  exit 0
fi
```

**File path**: `/Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/scripts/verify-install.sh`

**Post-creation**:
```bash
chmod +x .claude/scripts/verify-install.sh
shellcheck .claude/scripts/verify-install.sh
```

**Verification**:
```bash
shellcheck .claude/scripts/verify-install.sh
bash .claude/scripts/verify-install.sh
```

Expected: shellcheck passes, script runs without syntax errors, produces pass/warn/fail output for each check.

---

### P1.4: Document Bash 4+ Requirement in `setup.sh`

**Owner**: T3-B
**Estimated Tokens**: ~1K
**Dependencies**: None

**File**: `.claude/scripts/setup.sh`

**Current behavior**: setup.sh does not check Bash version. The Bash 4+ requirement only surfaces at session end when `update-leaderboard.sh` runs and prints an INFO message to stderr.

**Add after the shebang and before the first `echo` statement** (after line 11, the `fail()` function definition):

```bash
echo ""
echo "[ Bash Version Check ]"
BASH_VER="${BASH_VERSINFO[0]:-0}"
if [ "$BASH_VER" -ge 4 ]; then
  ok "Bash $BASH_VERSION"
else
  warn "Bash ${BASH_VERSION:-<unknown>} detected. Bash 4+ is required for leaderboard updates."
  warn "macOS ships with Bash 3.2 (GPL-2 licensed). Install Bash 4+ via:"
  warn "  brew install bash"
  warn "  Then add /opt/homebrew/bin/bash to /etc/shells and set as default."
  warn "Without Bash 4+: leaderboard scores will NOT update. All other features work normally."
fi
```

**Verification**:
```bash
grep "Bash Version\|BASH_VERSINFO\|brew install bash" .claude/scripts/setup.sh
bash -n .claude/scripts/setup.sh
```

Expected: Bash version check present, script syntax is valid (`-n` flag), brew install bash instruction included.

---

### P1.5: Clarify T5 File Size Limit in `analyst.md`

**Owner**: T3-A
**Estimated Tokens**: ~1K
**Dependencies**: None

**File**: `.claude/agents/analyst.md`

**Current text** (lines 156–159):
```
| Reading files >10KB | ctx_execute with file read script |
```

This is already in the Tool Selection Rules table and is prescriptive. The issue identified in G01 (U-008) is that `context-mode-usage.md` uses "should" language while `analyst.md` uses "Use This" (imperative). The inconsistency should be resolved by adding a CRITICAL CONSTRAINT note.

**Add after the Tool Selection Rules table** (after line 159 in analyst.md):

```markdown
### File Size Enforcement

**Files exceeding 10KB MUST NOT be loaded directly into context for analysis purposes.**

This is a hard constraint, not a recommendation. When a file you need to analyze exceeds 10KB:

1. Use `ctx_execute_file(filePath, "shell", "wc -l < $FILE_CONTENT_PATH")` to measure
2. If >10KB, use `ctx_execute_file` to run targeted analysis (line counts, pattern searches, jq queries)
3. Only use Read for files you are editing (Write permission required for that use case)

**Exception**: T3 MidCoder agents using Read on files they own for editing purposes. T5 Analysts have no edit permissions outside `.claude/analysis/raw/` and therefore this exception does not apply to T5.
```

**Verification**:
```bash
grep "10KB\|MUST NOT\|hard constraint" .claude/agents/analyst.md
```

Expected: explicit "MUST NOT" language present, hard constraint stated clearly, exception for T3 edit use case documented.

---

## P2 Tasks — Defer If Running Long

These are T3-B tasks after P1 completion. Brief specs only.

### P2.1: Create `.claude/docs/TROUBLESHOOTING.md`

**Owner**: T3-B | **Estimated Tokens**: ~3K

Create a 250–350 line guide covering the top 8 failure scenarios operators encounter:

1. `update-leaderboard.sh requires Bash 4+` — what it means, how to install, what breaks without it
2. `flock: command not found` — Linux vs macOS; mkdir fallback explanation
3. `jq: command not found` — impact (grep fallback used), install instructions
4. Hook blocks legitimate code — how to identify which hook fired, how to check exit code, escalation path
5. `active-plan.md` corrupted — recovery: delete file, Orchestrator creates fresh on next session
6. `graphify-out/.graphify-stale` never cleared — manual fix: `rm graphify-out/.graphify-stale`
7. Pattern lifecycle not running — check `settings.json` for SessionEnd hook wiring
8. Leaderboard scores stuck at 0 — dependency on Bash 4+; check sentinel file at `.claude/metrics/.session-complete`

**File path**: `.claude/docs/TROUBLESHOOTING.md`

---

### P2.2: Create `.claude/docs/FAQ.md`

**Owner**: T3-B | **Estimated Tokens**: ~3K

Create a 300–400 line FAQ with 12–15 Q&A pairs covering:

- What is the difference between x2 and x10 mode?
- When should I use T3 vs T2 for a task?
- What happens during the review chain?
- How do learned patterns get promoted to rules?
- What does `revision_attempts` mean and when does it reset?
- What is the difference between `context-mode` and `graphify`?
- How do I add a custom hook?
- Why does the leaderboard not update on macOS?
- What is caveman mode?
- How do I view agent performance metrics?
- Can agents communicate with each other directly?
- What happens if an agent exceeds its token budget?

**File path**: `.claude/docs/FAQ.md`

---

### P2.3: Fix Rule Count in `CLAUDE.md`

**Owner**: T3-B | **Estimated Tokens**: ~200 tokens

**Note**: CLAUDE.md says "15 standard files" in the Key Configuration Files table. Actual count is 19 (verified by G01 audit). This is a 2-minute edit.

**File**: `CLAUDE.md` Key Configuration Files table row for `.claude/rules/*.md`

Find the row:
```
| `.claude/rules/*.md` | Coding standards (15 files) |
```

Change to:
```
| `.claude/rules/*.md` | Coding standards (19 files) |
```

**Verification**:
```bash
ls .claude/rules/*.md | wc -l
grep "rules/\*\.md" CLAUDE.md
```

Expected: `ls` count matches number in CLAUDE.md.

---

### P2.4: Create `.claude/docs/ARCHITECTURE.md`

**Owner**: T3-B | **Estimated Tokens**: ~4K

Create a 400–500 line architecture reference with ASCII/Mermaid diagrams for:

1. **Tier Hierarchy Diagram** — Orchestrator at top, T1–T5 below with model labels
2. **Review Chain Flow** — T5 → T4 → T3 → T2 → T1 → Orchestrator with conditional paths
3. **DAG Construction Example** — Sample 4-task DAG with wave labels
4. **File Ownership Map** — which tier writes to which directories
5. **Hook Execution Timeline** — PreToolUse → agent runs → PostToolUse → SessionEnd
6. **Self-Learning Loop** — edit → collector → pattern file → lifecycle → rules promotion

**File path**: `.claude/docs/ARCHITECTURE.md`

---

### P2.5: Add Cross-References Between `caveman.md` and `caveman/SKILL.md`

**Owner**: T3-B | **Estimated Tokens**: ~200 tokens

Two minimal edits:

**In `.claude/rules/caveman.md`**, add at the end of the References section:
```markdown
- `.claude/skills/caveman/SKILL.md` — quick trigger summary and activation examples (concise reference)
```

**In `.claude/skills/caveman/SKILL.md`**, add in the Reference section (currently last line):
```markdown
Full style guide, auto-clarity exceptions, and examples: `.claude/rules/caveman.md`
```

**Verification**:
```bash
grep "SKILL.md" .claude/rules/caveman.md
grep "rules/caveman" .claude/skills/caveman/SKILL.md
```

---

## File Ownership Map

| File | T3-A | T3-B | Notes |
|------|------|------|-------|
| `.claude/metrics/fallback-log.md` | CREATE | — | P0.1 |
| `.claude/skills/test-gen/SKILL.md` | CREATE | — | P0.2 |
| `.claude/docs/hook-exit-codes.md` | CREATE | — | P0.3 |
| `.claude/config/tier-definitions.md` | EDIT | — | P0.4: add T3 note |
| `.claude/config/context-budget.md` | EDIT | — | P0.4: update T3 line |
| `.claude/hooks/update-leaderboard.sh` | EDIT | — | P0.5: decimal multipliers |
| `.claude/config/hook-registry.md` | VERIFY/EDIT | — | P1.1: verify graphify-rebuild.sh in table |
| `.claude/agents/analyst.md` | EDIT | — | P1.5: hard constraint note |
| `.claude/scripts/verify-install.sh` | CREATE | — | P1.3 |
| `.claude/scripts/setup.sh` | — | EDIT | P1.4: Bash version check |
| `.claude/docs/GETTING_STARTED.md` | — | CREATE | P1.2 |
| `.claude/docs/TROUBLESHOOTING.md` | — | CREATE | P2.1 |
| `.claude/docs/FAQ.md` | — | CREATE | P2.2 |
| `CLAUDE.md` | — | EDIT | P2.3: rule count fix |
| `.claude/docs/ARCHITECTURE.md` | — | CREATE | P2.4 |
| `.claude/rules/caveman.md` | — | EDIT | P2.5: cross-ref |
| `.claude/skills/caveman/SKILL.md` | — | EDIT | P2.5: cross-ref |

**T3-A total**: 9 files (5 create, 4 edit)
**T3-B total**: 8 files (4 create, 4 edit)

---

## Verification Checklist

### P0 Verification (T2 reviews before marking sprint complete)

| Item | Command | Expected Result |
|------|---------|----------------|
| P0.1 fallback-log.md exists | `ls .claude/metrics/fallback-log.md` | File present |
| P0.1 has correct schema | `grep "Primary Model\|Fallback Model" .claude/metrics/fallback-log.md` | Both column headers present |
| P0.2 SKILL.md exists | `ls .claude/skills/test-gen/SKILL.md` | File present |
| P0.2 lists all 3 frameworks | `grep -c "Jest\|Vitest\|pytest" .claude/skills/test-gen/SKILL.md` | At least 3 lines |
| P0.3 hook-exit-codes.md exists | `ls .claude/docs/hook-exit-codes.md` | File present |
| P0.3 all 3 exit codes documented | `grep "Exit.*0\|Exit.*1\|Exit.*2" .claude/docs/hook-exit-codes.md` | 3+ matches |
| P0.4 tier-definitions has T3 note | `grep "5000\|5K\|T3 Note" .claude/config/tier-definitions.md` | Note present |
| P0.4 context-budget.md updated | `grep "5K task" .claude/config/context-budget.md` | Updated line present |
| P0.5 decimal multipliers | `grep "2\.0\|1\.5\|0\.8\|0\.5" .claude/hooks/update-leaderboard.sh` | 4+ matches in function |
| P0.5 shellcheck passes | `shellcheck .claude/hooks/update-leaderboard.sh` | Exit 0, no errors |

### P1 Verification

| Item | Command | Expected Result |
|------|---------|----------------|
| P1.1 graphify-rebuild.sh in table | `grep -n "graphify-rebuild" .claude/config/hook-registry.md` | Line in PostToolUse section (not just in Note) |
| P1.2 GETTING_STARTED.md exists | `wc -l .claude/docs/GETTING_STARTED.md` | 250–400 lines |
| P1.2 Bash 4 macOS section | `grep "brew install bash" .claude/docs/GETTING_STARTED.md` | Present |
| P1.3 verify-install.sh exists | `ls .claude/scripts/verify-install.sh` | File present |
| P1.3 is executable | `test -x .claude/scripts/verify-install.sh && echo OK` | OK |
| P1.3 shellcheck passes | `shellcheck .claude/scripts/verify-install.sh` | Exit 0 |
| P1.3 runs cleanly | `bash .claude/scripts/verify-install.sh 2>&1 \| tail -3` | Results line present |
| P1.4 setup.sh has Bash check | `grep "BASH_VERSINFO\|brew install bash" .claude/scripts/setup.sh` | Both present |
| P1.5 analyst.md hard constraint | `grep "MUST NOT\|hard constraint" .claude/agents/analyst.md` | Present |

---

## Out of Scope (P3)

The following items are deferred to a future sprint. No action by T3-A or T3-B this sprint.

| ID | Item | Rationale |
|----|------|-----------|
| IO-001 | Pre-spawn validator hook for task budget overflow | Useful but not blocking; needs design review by T1 |
| IO-003 | Integration test suite for hooks | High effort; requires test framework setup decision |
| IO-002 | Auto-generate ARCHITECTURE.md from CLAUDE.md | Lower priority than manual docs; P2.4 covers this manually |
| IO-005 | Slack/email notifications on session completion | Feature request; out of scope for this sprint |
| S-008-enforce | Analysis scope enforcement hook (currently advisory) | Monitor for violations first before enforcing |
| U-010-handle | Corrupted active-plan.md recovery handler | Document recovery in TROUBLESHOOTING.md (P2.1) first |
| UX-005 | CHANGELOG.md creation | Useful but not urgent; no versioned release cycle yet |
| UX-007 | TOOLS_INTEGRATION.md | `.claude/docs/TOOLS_OVERVIEW.md` partially covers this |
| UX-008 | CONTRIBUTING.md and issue templates | Good practice; not blocking for current team size |
| UX-009 | Learned patterns lifecycle visual | Covered by ARCHITECTURE.md (P2.4) at high level |
| UX-010 | EXTENDING.md for custom hooks/rules | Valuable for community adoption; defer until public release |
| I-001 | Rule count in CLAUDE.md Key Config table | Addressed in P2.3; if P2 deferred, this stays deferred |

---

## T3-A Execution Order

Execute in this sequence to minimize dependency conflicts:

1. **P0.1** — fallback-log.md (no deps, 15 min)
2. **P0.3** — hook-exit-codes.md (no deps, 45 min)
3. **P0.2** — test-gen/SKILL.md (no deps, 30 min)
4. **P0.4** — T3 budget alignment (Decision 1 is resolved; 20 min)
5. **P0.5** — multiplier fix in update-leaderboard.sh (30 min; run shellcheck after)
6. **P1.1** — hook-registry verify/edit (5 min; verify first, edit only if absent)
7. **P1.5** — analyst.md clarification (15 min)
8. **P1.3** — verify-install.sh (60 min; run shellcheck + test run after)

## T3-B Execution Order

Start after T3-A completes P0 items (to reference correct config state):

1. **P1.4** — setup.sh Bash check (15 min; no blocking deps)
2. **P1.2** — GETTING_STARTED.md (90 min; reference P0.4 and P0.5 decisions)
3. **P2.3** — CLAUDE.md rule count (5 min)
4. **P2.5** — caveman cross-references (5 min)
5. **P2.1** — TROUBLESHOOTING.md (60 min)
6. **P2.2** — FAQ.md (60 min)
7. **P2.4** — ARCHITECTURE.md (90 min)
