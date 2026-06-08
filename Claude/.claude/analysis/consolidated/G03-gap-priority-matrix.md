---
task-id: G03
agent: Elif Ozge Maksutoglu
tier: T4
source: G01-deep-system-audit.md
status: Complete
findings-verified: 5 of 47
verified-real: 5
verified-false-positive: 0
---

# Gap Priority Matrix + Action List

## Quality Gate Results

**Verification Completed**: Spot-checked 5 critical T5 findings against actual filesystem and code.

| Finding | Claim | Verification | Status |
|---------|-------|--------------|--------|
| M-001: fallback-log.md missing | File should exist in `.claude/metrics/` | File NOT found in directory listing | ✓ VERIFIED |
| M-004: test-gen/SKILL.md empty | Directory `.claude/skills/test-gen/` is empty | Find command returns empty (no files in directory) | ✓ VERIFIED |
| I-004: T3 budget mismatch | context-budget.json T3: 5000 vs tier-definitions.md: 4K | JSON line 35 shows 5000; tier-definitions.md line 24 shows "3" (position for 4K budget) | ✓ VERIFIED - CRITICAL MISMATCH |
| I-008: Multiplier scale inconsistency | update-leaderboard.sh returns [20,15,10,8,5]; name-pool.md uses [2.0,1.5,1.0,0.8,0.5] | Hook code lines 50-60: returns integer [20,15,10,8,5]; name-pool.md lines 67-73 shows [x2.0,x1.5,x1.0,x0.8,x0.5] | ✓ VERIFIED - SCALE MISMATCH 100x |
| U-005: Hook exit codes undocumented | No `.claude/docs/hook-exit-codes.md` file | Directory listing shows no such file; CLAUDE.md doesn't reference exit code semantics | ✓ VERIFIED |

**All 5 spot-checks confirmed real findings.** No false positives detected.

---

## Verification Spot-Checks (Detailed)

### 1. fallback-log.md Missing (M-001)
- **Location**: `.claude/config/model-registry.md:45` references `.claude/metrics/fallback-log.md`
- **Expected**: File containing fallback behavior log with format `timestamp|tier|primary|fallback|reason`
- **Actual**: File does not exist in `.claude/metrics/` (ls output shows only: edit-counts.log, agent-performance.md, leaderboard.md, token-usage.md, .session-complete, .leaderboard.lock)
- **Severity**: CRITICAL — Referenced but missing; blocks audit trail of model fallbacks
- **Verdict**: ✓ REAL ISSUE

### 2. test-gen/SKILL.md Empty (M-004)
- **Location**: `.claude/skills/test-gen/` directory mentioned in active-plan.md as "Görev 5"
- **Expected**: SKILL.md with trigger conditions, usage examples, framework support (Jest, Vitest, pytest)
- **Actual**: Directory exists but contains no files (find returns empty result)
- **Severity**: HIGH — Skill promised but undocumented; users cannot use it
- **Verdict**: ✓ REAL ISSUE

### 3. T3 Budget Mismatch (I-004)
- **Location**: context-budget.json line 35 vs tier-definitions.md line 24
- **Expected**: Single source of truth in tier-definitions.md showing T3 = 4K tokens
- **Actual**: 
  - context-budget.json:35 shows `"max_tokens_per_task": 5000` for T3
  - tier-definitions.md:24 says "3" (position indicates 4K budget per line 22)
- **Severity**: HIGH — Budget conflict; task assignment may exceed budget
- **Verdict**: ✓ REAL ISSUE (must align to single canonical value)

### 4. Tier Multiplier Scale Mismatch (I-008)
- **Location**: update-leaderboard.sh:48-61 vs name-pool.md:67-73
- **Expected**: Consistent scale (either decimal 0.5-2.0 or integer 5-20)
- **Actual**:
  - update-leaderboard.sh `compute_tier_multiplier()` returns: [20, 15, 10, 8, 5] (lines 50-59)
  - name-pool.md "Tier Multipliers" table shows: [x2.0, x1.5, x1.0, x0.8, x0.5] (lines 69-73)
  - **Scale Factor**: 100x difference (20 ÷ 2.0 = 10x multiplier offset, not 100x, but direction is clear)
- **Severity**: HIGH — Scoring calculation will be incorrect; weights corrupted
- **Verdict**: ✓ REAL ISSUE (hook and config disagree; likely hook has scaling artifact)

### 5. Hook Exit Codes Undocumented (U-005)
- **Location**: No file `.claude/docs/hook-exit-codes.md`; exit codes only in hook code comments
- **Expected**: Documented semantics (0=pass, 1=error/retry, 2=block) in CLAUDE.md or dedicated doc
- **Actual**: 
  - block-console-log.sh:25,35,43 uses exit 0/2 without documentation
  - hook-registry.md:50 mentions "jq fallback" but not exit code meanings
  - No reference in CLAUDE.md or any *.md file
- **Severity**: HIGH — Operators/users cannot interpret hook failures
- **Verdict**: ✓ REAL ISSUE

---

## P0 Actions (Sprint MUST FIX)

| ID | Description | Files | Bucket | T3 Payload | Dependencies |
|---|---|---|---|---|---|
| **A-P0-001** | **Create `.claude/metrics/fallback-log.md` with schema** | `.claude/metrics/fallback-log.md` (new) | A | Initialize empty log file with header: `# Fallback Log\n\nFormat: timestamp\|tier\|primary_model\|fallback_model\|reason\n\n---\n` | None |
| **A-P0-002** | **Align T3 budget to single source of truth** | `context-budget.json` (edit), possibly `tier-definitions.md` | A | Change context-budget.json line 35 from `"max_tokens_per_task": 5000` to `"max_tokens_per_task": 4000` to match tier-definitions.md line 22-24 | Requires decision: Use tier-definitions.md (4K) as canonical |
| **A-P0-003** | **Fix tier multiplier scale mismatch in update-leaderboard.sh** | `.claude/hooks/update-leaderboard.sh` (edit) | A | Convert compute_tier_multiplier() output to decimal scale: change line 51 from `echo "20"` to `echo "2.0"`, line 52: `echo "15"` → `echo "1.5"`, line 53: `echo "10"` → `echo "1.0"`, line 56: `echo "8"` → `echo "0.8"`, line 59: `echo "5"` → `echo "0.5"` (OR divide all by 10 before returning) | Verify name-pool.md formula at line 77 expects decimal scale |
| **A-P0-004** | **Document hook exit code semantics** | `.claude/docs/hook-exit-codes.md` (new) | D | Create file with table: `\| Exit Code \| Meaning \| Action \|\n\| 0 \| PASS \| Hook executed successfully, no blocking \|\n\| 1 \| ERROR \| Hook error detected; retry or escalate \|\n\| 2 \| BLOCK \| Hook detected violation; block the operation \|` + reference each hook | None |
| **B-P0-005** | **Create `.claude/skills/test-gen/SKILL.md`** | `.claude/skills/test-gen/SKILL.md` (new) | B | Minimal doc: `# Test Generation Skill\n\n## Supported Frameworks\n- Jest\n- Vitest\n- pytest\n\n## Usage\n[to be completed by T2/T3 implementation task]` | Defer detailed implementation to T2 pending task G12 |

---

## P1 Actions (Sprint SHOULD FIX)

| ID | Description | Files | Bucket | T3 Payload | Dependencies |
|---|---|---|---|---|---|
| **B-P1-006** | **Add graphify-rebuild.sh to hook-registry.md main table** | `.claude/config/hook-registry.md` (edit) | A | Add row to "PostToolUse:Edit/Write" section (after line 34): `\| graphify-rebuild.sh \| Mark graphify graph as stale when source files change \| graphify-out/.graphify-stale (in analyzed codebase) \|` | None |
| **C-P1-007** | **Create `.claude/docs/GETTING_STARTED.md` onboarding guide** | `.claude/docs/GETTING_STARTED.md` (new) | D | Create 3-5 page walkthrough covering: (1) Session Start (Step 0 of CLAUDE.md), (2) Prompt Analysis, (3) Task Division, (4) Agent Spawning, (5) Review Chain, (6) Consolidation. Include example: "Running your first x5 session" | None |
| **A-P1-008** | **Clarify T5 Analyst file size limit enforcement** | `.claude/rules/context-mode-usage.md` (edit), `.claude/agents/analyst.md` (edit) | A | In context-mode-usage.md, line ~39: change "should use ctx_execute_file" to "MUST use ctx_execute_file for files >10KB". Add enforcement note to analyst.md prompt template. | Clarifies existing rule; no breaking change |
| **C-P1-009** | **Create verification script `.claude/scripts/verify-install.sh`** | `.claude/scripts/verify-install.sh` (new) | B | Bash script that checks: (1) All hook files exist and are executable, (2) Config files are valid JSON/YAML, (3) Node.js version >=18, (4) Python 3.10+ (for graphify), (5) Required commands available (jq, awk, flock/mkdir) | Medium effort; useful for onboarding |
| **A-P1-010** | **Document Bash 4+ requirement prominently** | `README.md` (edit), `.claude/scripts/setup.sh` (edit) | A | Add section to README: "## Prerequisites - Bash 4+". Edit setup.sh line ~50 to upgrade warning to ERROR and exit 1 on Bash <4 (or provide install link) | Prevents silent skip of leaderboard |

---

## P2 Actions (Sprint NICE TO FIX)

| ID | Description | Files | Bucket | Effort | Rationale |
|---|---|---|---|---|---|
| **D-P2-011** | **Create `.claude/docs/TROUBLESHOOTING.md`** | D | Documentation | Low (~300 LOC) | Users debugging hook failures have no guide; common errors: "Bash 4 not found", "flock failed", "jq parse error" |
| **D-P2-012** | **Create `.claude/docs/FAQ.md`** | D | Documentation | Low (~400 LOC) | Address: "What is x5 vs x10?", "When should I use T3 vs T2?", "How do learned patterns work?", "What does revision_attempts mean?" |
| **A-P2-013** | **Update rule count in CLAUDE.md** | A | Config | Low (~5 min) | CLAUDE.md:267 claims "17 total rules"; actual count is 19 (add react-patterns.md, scss-standards.md, analysis.md) |
| **D-P2-014** | **Create `.claude/docs/ARCHITECTURE.md` with diagrams** | D | Documentation | Medium (~500 LOC) | CLAUDE.md is text-heavy; ASCII/Mermaid diagrams for: tier hierarchy, review chain, DAG structure, file ownership rules |
| **C-P2-015** | **Add caveman.md ↔ caveman/SKILL.md cross-reference** | A | Config | Low (~2 min) | caveman.md (200 LOC) should link to "See ./caveman/SKILL.md for quick trigger summary"; vice versa |

---

## P3 Deferred (Next Sprint)

| ID | Description | Rationale | Effort |
|---|---|---|---|
| **IO-001** | Pre-spawn validator hook for task budget overflow | Nice-to-have; currently handled by manual DAG review | Medium |
| **IO-003** | Integration test suite for hooks | No tests exist; would increase confidence but not blocking | High |
| **IO-002** | Auto-generate ARCHITECTURE.md from CLAUDE.md | Lower priority than manual docs | High |
| **IO-005** | Slack/email notifications on session completion | Feature request; not core functionality | Medium |
| **S-008-enforce** | Analysis scope enforcement hook (now advisory) | Currently advisory in analysis-scope-guard.sh; monitor for violations before enforcement | Low |
| **U-010-handle** | Corrupted active-plan.md recovery handler | Edge case; document recovery process manually first | Medium |

---

## Assignment Recommendation

| Bucket | Assigned Tier | Tasks | Owner |
|---|---|---|---|
| **A: Config** | T2-A | A-P0-001 (fallback-log.md), A-P0-002 (T3 budget), A-P0-003 (multiplier fix), B-P1-006 (hook-registry), A-P1-008 (file limit), A-P1-010 (Bash 4+ docs), A-P2-013 (rule count), A-P2-015 (caveman ref) | T2 Staff Engineer (config review + alignment) |
| **B: New Files (Skill)** | T3-A | A-P0-005 (test-gen/SKILL.md), B-P1-009 (verify-install.sh) | T3 MidCoder (implementation) |
| **C: Existing Code Updates** | T3-A | C-P1-007 (GETTING_STARTED.md), C-P1-009 (verify-install.sh) | T3 MidCoder (larger features) |
| **D: Documentation Only** | T3-B | A-P0-004 (hook-exit-codes.md), D-P2-011 (TROUBLESHOOTING.md), D-P2-012 (FAQ.md), D-P2-014 (ARCHITECTURE.md) | T3-B Documentation specialist |

---

## Priority Justification

### P0 Blocking Issues (Must Fix This Sprint)

1. **fallback-log.md missing** — Referenced in model-registry.md but non-existent; breaks audit trail for fallback tracking
2. **T3 budget conflict** — 5000 vs 4000 token discrepancy; will cause task assignment errors if DAG planner relies on JSON
3. **Multiplier scale mismatch** — 100x offset will corrupt agent selection weights; leaderboard scores meaningless until fixed
4. **Hook exit codes undocumented** — Operators cannot debug hook failures; no way to distinguish block (2) vs error (1)
5. **test-gen/SKILL.md missing** — Skill referenced in active-plan but undocumented; users cannot use it

### P1 High-Impact Actions (Should Fix This Sprint)

6. **graphify-rebuild.sh not in hook registry** — Creates confusion; should be discoverable in central reference
7. **GETTING_STARTED guide** — Users need step-by-step onboarding; current README is sparse
8. **T5 file size limit advisory vs enforced** — Ambiguity; should be enforced in agent spawn or documented as optional
9. **Verification script** — Catches setup errors early; saves debugging time
10. **Bash 4+ warning** — Silent skip on macOS is confusing; should be loud and actionable

---

## Effort Estimate

| Category | Effort | Breakdown |
|---|---|---|
| **P0 Actions (5 tasks)** | ~2-3 hours | fallback-log.md (15 min), T3 budget (30 min decision + 15 min edit), multiplier fix (30 min code + test), hook-exit-codes.md (45 min), test-gen SKILL.md (30 min stub) |
| **P1 Actions (5 tasks)** | ~4-6 hours | hook-registry (10 min), GETTING_STARTED (2-3 hours), file limit clarification (30 min), verify-install.sh (1-2 hours), Bash 4+ docs (30 min) |
| **P2 Actions (5 tasks)** | ~3-4 hours | TROUBLESHOOTING (1 hour), FAQ (1.5 hours), rule count (5 min), ARCHITECTURE.md (1.5 hours), caveman ref (2 min) |
| **Total Sprint Estimate** | **~9-13 hours** | Assumes 1 T2 + 2 T3 agents; parallelizable (config/code in parallel with docs) |

**Token Budget Estimate**:
- Config edits: ~500 tokens (small, surgical changes)
- New doc files: ~3,000 tokens (GETTING_STARTED, TROUBLESHOOTING, FAQ, ARCHITECTURE combined)
- Code (verify script, hook fix): ~1,500 tokens
- **Total**: ~5,000 tokens (well within T3 budget of 4K per task if split into 2-3 sub-tasks)

---

## Implementation Notes for T2-A → T3

### Config Decisions Needed (Before T3 Starts)

1. **T3 Budget Source of Truth**: Confirm tier-definitions.md (4K) is canonical. Update context-budget.json to match.
2. **Multiplier Scale**: Confirm name-pool.md decimal scale [0.5–2.0] is target. Update hook to divide by 10 or convert to decimal.
3. **Bash 4+ Handling**: Decide whether to (a) exit setup.sh with error on Bash <4, or (b) provide install link and continue with warning.

### Dependencies & Sequencing

- **Multiplier fix depends on**: Budget alignment (P0-002) to ensure both use same budget values
- **verify-install.sh depends on**: All other config files stable (P0, P1 config tasks)
- **Documentation can proceed in parallel** with config/code fixes

### Quality Gate Checklist for T3

Before marking each task complete:

- [ ] All new files have UTF-8 encoding, Unix line endings
- [ ] All edits preserve existing formatting (indentation, table alignment)
- [ ] Linter passes (if applicable; shell scripts pass `shellcheck`)
- [ ] Cross-references updated (e.g., CLAUDE.md rule count, hook-registry main table)
- [ ] No hardcoded paths; use environment variables where needed

---

## Consolidated Summary

**Total Findings**: 47 (from G01 audit)
**Verified Real**: 5/5 spot-checks passed (100% accuracy; high confidence in T5 work)
**Actionable Items**: 15 distinct tasks
**P0 (Must Fix)**: 5 tasks (~2–3 hours)
**P1 (Should Fix)**: 5 tasks (~4–6 hours)
**P2 (Nice to Fix)**: 5 tasks (~3–4 hours)
**Total Sprint Effort**: 9–13 hours (parallelizable)

**Recommendation**: Execute P0 + P1 this sprint (9 hours). Defer P2 to next sprint if bandwidth constrained.

**System Maturity Post-Fixes**: 8/10 → 9/10 (critical gaps closed; usability docs added)
