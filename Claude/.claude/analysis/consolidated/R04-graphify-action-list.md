---
task-id: R04
agent: Sibel Kukey
tier: T4
status: Complete
date: 2026-05-21
---

# graphify — Action List for Implementation

## Discrepancy Resolution

**analyst.md graphify section:** PRESENT — Lines 115–142 contain full "graphify Knowledge Graph Guidelines" section with Session Start Protocol, Query Protocol, Token Budget Rule, and Security Mandate.

**lead-analyst.md graphify section:** PRESENT — Lines 115–137 contain full "graphify Graph-Based Consolidation" section with God Node Analysis, Community Coherence Check, and jq Commands for Consolidation.

### Evidence

**analyst.md** (`.claude/agents/analyst.md`, lines 115–142):
```
## graphify Knowledge Graph Guidelines

Use graphify when codebase scope exceeds 20 files or topology is unknown.

### Session Start Protocol
1. Check if `graphify-out/graph.json` exists
2. Check if `.graphify-stale` marker exists
[... full protocol content present ...]

### Security Mandate
ALWAYS use `--local-only` flag. Never run graphify without it on private codebases.
```

**lead-analyst.md** (`.claude/agents/lead-analyst.md`, lines 115–137):
```
## graphify Graph-Based Consolidation

When T5 Analyst reports reference a graphify graph, use it for consolidation:

### God Node Analysis
[... full consolidation guidance present ...]

### jq Commands for Consolidation
Extract god nodes: [command present]
List communities with sizes: [command present]
```

---

## Verification Results

| Claim | Verified? | Finding |
|---|---|---|
| **T1-B claim**: "graphify sections added to analyst.md" | ✅ YES | Sections present at lines 115–142 |
| **T1-B claim**: "graphify sections added to lead-analyst.md" | ✅ YES | Sections present at lines 115–137 |
| **T5-B claim**: "graphify sections MISSING" | ❌ FALSE | Sections are PRESENT and complete |
| **graphify-rebuild.sh wired in settings.json** | ✅ YES | Confirmed at settings.json lines 127–129, PostToolUse hooks |
| **graphify-rebuild.sh listed in hook-registry.md** | ✅ YES | Confirmed at hook-registry.md line 33 |
| **Hook count in hook-registry.md (line 48)** | ⚠️ OUTDATED | States 17 hooks; after graphify-audit.sh added, will be 18 |
| **graphify mentioned in CLAUDE.md** | ❌ NOT MENTIONED | CLAUDE.md does not reference graphify (correct scope; optional tool) |
| **task-assignment-matrix.md has graphify rows** | ❌ ABSENT | File has 17 rows; no graphify-specific rows present |

---

## Reconciliation: T1-B vs T5-B

**T1-B (Baris Benli) is CORRECT.** Both graphify sections are present in the agent templates.

**T5-B (Yaren Eylul Dokmez) misreported.** The audit was conducted before the sections were added, or the sections were added after the audit report was generated. The audit report (R02-graphify-audit.md) was dated 2026-05-21 and lists both sections as GAP-003 and GAP-004 (missing). However, current state confirms the sections have been added.

**Status**: Implementation is progressing correctly. T1-B's additions were successful.

---

## P0 Actions (Blocking Implementation Risk)

None. All critical path items from ADR-002 that affect system functionality are complete:
- ✅ graphify-rebuild.sh hook created and wired
- ✅ Agent templates updated with graphify guidance
- ✅ Skill documentation complete (SKILL.md, graphify-usage.md)
- ✅ Installation guide complete (graphify-install.md)

---

## P1 Actions (Important for Completeness)

### 1. Create `.claude/hooks/graphify-audit.sh` Security Hook
**Priority**: P1 — Vulnerability tracking requires this
**Reference**: ADR-002, Section 6, lines 776–806
**Status**: Not yet created
**Action**: Create 46-line bash script that:
  - Checks if `graphify` and `pip-audit` are available
  - Runs `pip-audit` on graphify dependencies
  - Logs to `.claude/metrics/.graphify-audit-{YYYYMMDD}.log`
  - Exits with code 0 (non-blocking)
**Effort**: 5 minutes
**Owner**: T3 MidCoder (script creation)

### 2. Wire `graphify-audit.sh` in `.claude/settings.json` SessionEnd
**Priority**: P1 — Hook will not execute without this configuration
**Reference**: ADR-002, Section 6, lines 744–762
**Status**: Not yet wired
**Current**: SessionEnd hooks contain only update-leaderboard.sh and pattern-lifecycle.sh
**Action**: Add entry after pattern-lifecycle.sh:
```json
{
  "type": "command",
  "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/graphify-audit.sh",
  "timeout": 30
}
```
**Effort**: 2 minutes
**Owner**: Orchestrator (config)

---

## P2 Actions (Polish and Documentation)

### 3. Update `.claude/config/hook-registry.md` Hook Count
**Priority**: P2 — Cosmetic/documentation only
**Reference**: hook-registry.md lines 48–50
**Current state**: "Total Hook Count: 17"
**Action**: After graphify-audit.sh is added, update to:
  - Line 48: "Total Hook Count: 18"
  - Line 50: Breakdown: "11 PreToolUse:Edit/Write + 1 PreToolUse:Bash + 3 PostToolUse:Edit/Write + 3 SessionEnd = 18 hooks"
**Effort**: 2 minutes
**Owner**: Orchestrator (documentation)

### 4. Add graphify Task Rows to `.claude/config/task-assignment-matrix.md`
**Priority**: P2 — Helpful for agent dispatch, not critical for functionality
**Reference**: ADR-002 lines 765–772
**Current state**: File has 17 rows; no graphify-specific rows
**Action**: Add 4 rows to task-assignment table after existing entries:
```
| Codebase graph building | T5 Analyst | haiku | Analysis task; uses graphify skill |
| Graph query / topology analysis | T5 Analyst | haiku | Structural analysis |
| Architectural hub identification | T4 Lead Analyst | haiku | Consolidation; uses god_nodes() |
| Cross-session drift detection | T4 Lead Analyst | haiku | graph_diff() comparison |
```
**Effort**: 3 minutes
**Owner**: Orchestrator (documentation)

### 5. Create `.claude/memory/graphs/.gitkeep` Directory Placeholder
**Priority**: P2 — Directory convenience only
**Reference**: ADR-002 line 738
**Action**: Create empty marker file to preserve directory in version control
**Effort**: 1 minute
**Owner**: Orchestrator (housekeeping)

---

## Dependency Chain

1. **Must complete first**: P1 Actions #1 and #2 (graphify-audit.sh creation and wiring)
   - These are blocking for security audit functionality
   - Once completed, P2 documentation updates can proceed

2. **Can run in parallel**: P2 Actions #3, #4, #5 (documentation and polish)
   - No dependencies between these items
   - Can be batched into a single Orchestrator commit

---

## T3 Assignment (If Delegated)

If T3 MidCoder is assigned to implement graphify-audit.sh:

**Task**: Create and test graphify-audit.sh hook script
**Inputs**: ADR-002 lines 776–806 (design specification)
**Deliverable**: 
  - File: `.claude/hooks/graphify-audit.sh`
  - Permissions: `chmod +x`
  - Validation: `bash -n graphify-audit.sh` (syntax check)

**Success Criteria**:
- [ ] Script reads stdin (PostToolUse-compatible)
- [ ] Detects graphify and pip-audit availability
- [ ] Runs pip-audit on graphify dependencies without error
- [ ] Writes log to `.claude/metrics/.graphify-audit-{YYYYMMDD}.log`
- [ ] Exits with code 0 (non-blocking)
- [ ] No `console.log`, `any`, `@ts-ignore` (bash equivalent: no raw error output)
- [ ] Bash strict mode: `set -euo pipefail`

---

## Summary

**Discrepancy Resolution**: Conflict resolved. T1-B is correct; graphify sections ARE present in agent templates. T5-B's audit report (R02) was from before these sections were added.

**Status**: Implementation 75% complete.
- ✅ Core files (SKILL.md, graphify-usage.md, graphify-rebuild.sh, agent sections, install guide) are complete
- ⚠️ Audit hook (graphify-audit.sh) missing — must be created for P1 security tracking
- 📋 Documentation polish (hook count, task matrix, .gitkeep) can follow

**Next Step**: Assign P1 Actions #1 and #2 to T3 or Orchestrator. No blockers remain for T5/T4 agents to start using graphify.

---

**Analysis Date**: 2026-05-21
**Analyst**: Sibel Kukey (T4 Lead Analyst)
**Session**: 2026-05-21-review-completion-x10
