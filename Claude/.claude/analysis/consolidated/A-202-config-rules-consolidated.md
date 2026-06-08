# A-202: Config + Rules Consolidated Analysis

**Agent:** Elif Ozge Maksutoglu (T4 Lead Analyst)  
**Date:** 2026-04-29  
**Sources:** A-102 (Bugra Ozkahraman, T5), A-302 (Oya Kanat, T3)  
**Type:** System Architecture Audit  
**Confidence:** High (16 direct file verifications + cross-reference validation)

---

## Executive Summary

The configuration and rules system exhibits critical security contradictions, widespread agent skill loading gaps, and consistency issues across config files. The rules themselves are substantively complete in domain coverage (React, Spring Boot, full-stack, security, testing) but lack systemic enforcement paths: 6 rule files have zero hook enforcement, 4 critical rule files are never loaded by any agent, and 3 project templates contain zero rule references. The highest-severity finding is a direct security contradiction between `api-integration.md` (localStorage for tokens) and `backend-security.md` (memory/httpOnly for tokens). Config has 5 critical findings (name-pool desync, context budget mismatch, leaderboard duplicates, missing schema fields, metrics table empty) that block operational accuracy. Recommended fixes: reconcile token storage, align config values, complete agent skill loading, add template rule references, and establish post-session sync hooks. Total 21 prioritized actions across P0-P3.

---

## P0 — Critical Security Issues

### RC-009 (CRITICAL): Direct Authentication Token Storage Contradiction

**Severity:** P0 — Critical Security Vulnerability  
**Files:**
- `api-integration.md` (§Authentication / Token Management section)
- `backend-security.md` (§JWT Security / Token Configuration section)

**Finding:**
`api-integration.md` instructs: "Auth interceptor: Attach Bearer from `localStorage`"  
`backend-security.md` recommends: "Access token: Memory (frontend) or Authorization header"

**Conflict Detail:**
- localStorage is vulnerable to XSS attacks; tokens are exposed if attacker injects JavaScript
- Memory storage is the secure recommendation (lost on page refresh, but unavailable to XSS)
- httpOnly cookies with Secure flag is the most secure approach (httpOnly prevents JavaScript access)
- **Authoritative source:** `backend-security.md` (signed security standards for multi-stack security-critical backend)

**Root Cause:** `api-integration.md` predates the security hardening in `backend-security.md`. No automated enforcement hook exists on `api-integration.md`, so the contradiction persists.

**Evidence:** High confidence — explicit code from two rule files, direct contradiction.

**Impact:** Any T3/T2 agent implementing API auth without explicitly reading both files will use localStorage, creating XSS-vulnerable authentication flow.

**Recommendation:**
1. **Immediate:** Update `api-integration.md` §Authentication / Token Management to align with `backend-security.md` recommendations:
   ```
   Access tokens: Store in memory (frontend) or Authorization header only. 
   Do NOT use localStorage (XSS-vulnerable). 
   Refresh tokens: Store in httpOnly, Secure, SameSite cookie (see backend-security.md §JWT Security).
   ```
2. Add a cross-reference in both files with conflict resolution note.
3. Add enforcement hook or advisory note in _shared-sections.md that T3/T2 must load both `api-integration.md` and `backend-security.md` for auth tasks.
4. Create test scenario: verify auth implementation does NOT use localStorage for access tokens.

**Fix Priority:** Before next coding session. This is an active security vulnerability affecting authentication implementations.

---

### F-005 (CRITICAL): name-pool.md Score Desync from Leaderboard

**Severity:** P0 — Critical Consistency Issue  
**Files:**
- `.claude/config/name-pool.md` (lines 7-28)
- `.claude/metrics/leaderboard.md` (lines 1-32)

**Finding:**
name-pool.md shows all 20 agent names with score=0, sessions=0.  
leaderboard.md Rank 1-10 show 8 agents with score=8 from 2026-04-22 session.

**Root Cause:** After SessionEnd hooks ran (update-leaderboard.sh), leaderboard.md was updated but name-pool.md (the source document for agent selection per CLAUDE.md Step 0) was not synced.

**Impact:** CLAUDE.md Step 0 specifies: "Assign display names using score-weighted random selection" (line 27). The algorithm in name-pool.md §Score-Weighted Selection Algorithm (lines 57-88) depends on current scores. Stale scores mean:
- Recent high-performing agents have 0 weight despite being top performers
- Agent selection is random, not performance-weighted
- Metrics loop is broken (agents accumulate scores, but selection ignores them)

**Evidence:** High confidence — direct numeric comparison between two files, explicit cross-reference in CLAUDE.md.

**Recommendation:**
1. **Immediate (this session):** Update name-pool.md scores from leaderboard.md:
   ```
   | ID | Name | Score | Sessions |
   | 1  | Selin Akar | 8 | 1 |
   | 2  | Baris Benli | 8 | 1 |
   ... (copy all 10 agents from leaderboard.md ranked table)
   | 11-20 | [remaining agents] | 0 | 0 |
   ```

2. **Systemic:** Have update-leaderboard.sh (SessionEnd hook) update both leaderboard.md and name-pool.md atomically, or add a post-session sync step in Orchestrator.

3. **Verification:** After next session, confirm name-pool.md and leaderboard.md are in sync.

**Fix Priority:** Highest — breaks agent selection algorithm.

---

### F-001 (CRITICAL): context-budget.json T3 Token Budget Mismatch

**Severity:** P0 — Critical Config Inconsistency  
**Files:**
- `.claude/config/context-budget.json` (line 31)
- `.claude/config/tier-definitions.md` (line 22)

**Finding:**
context-budget.json says T3 max_tokens_per_task = 5000  
tier-definitions.md (Single Source of Truth) says T3 = 4K

**Root Cause:** JSON was not updated when tier-definitions.md was revised.

**Impact:** T3 agents are spawned with incorrect budget assumption. If context-budget.json is the operational source (used by code to allocate budgets), T3 tasks may claim 5000 tokens when they should only allocate 4000, causing overflow.

**Evidence:** High confidence — explicit numeric values in both files, tier-definitions.md is marked as Single Source of Truth (line 1).

**Recommendation:**
1. **Immediate:** Fix context-budget.json line 31:
   ```json
   "T3": {
     "max_tokens_per_task": 4000,  // was 5000
     ...
   }
   ```
2. Verify no other tier budgets in JSON differ from tier-definitions.md (check T1-T5 all values).

**Fix Priority:** Before next session.

---

### F-002 (CRITICAL): Leaderboard Duplicate Placeholder Rows

**Severity:** P0 — Critical Metrics Corruption  
**File:** `.claude/metrics/leaderboard.md` (rows 17-21)

**Finding:**
Five duplicate rows without scores:
```
| — | Taner Yilmaz (dup) | — | — | — | — | — | — |
| — | Oya Kanat (dup) | — | — | — | — | — | — |
... (3 more)
```

Marked in note (line 33) as "artifacts" but not removed.

**Root Cause:** Placeholder rows left in place during manual leaderboard construction; never cleaned up.

**Impact:** Corrupts the ranked table. Confuses the agent name selection algorithm (name-pool.md §Score-Weighted Selection Algorithm). The algorithm will skip duplicate rows during iteration.

**Evidence:** High confidence — rows are explicitly annotated as artifacts.

**Recommendation:**
1. **Immediate:** Remove rows 17-21 entirely. They have no data and are not referenced by any code.
2. Verify leaderboard.md line count and row numbering after deletion.
3. Add a note in leaderboard.md: "Ranked table must not contain placeholders. Use update-leaderboard.sh to maintain consistency."

**Fix Priority:** Before next agent selection.

---

## P1 — Major Consistency & Functionality Gaps

### RC-004 (CRITICAL): implementation.md Never Loaded by T3

**Severity:** P1 — Critical Agent Skill Gap  
**Files:**
- `.claude/agents/mid-coder.md` (Skills to Load section)
- `.claude/config/_shared-sections.md` (Standard Skills to Load)
- `.claude/rules/implementation.md` (all sections)

**Finding:**
`implementation.md` defines core TypeScript standards:
- TypeScript strict mode, const/let/var rules, optional chaining, nullish coalescing
- Error class hierarchy, factory pattern, repository pattern, composition over inheritance
- Test AAA pattern, test naming convention, test rules (one assertion per test, factory functions)

T3 MidCoder (primary implementer) never loads `implementation.md`. The _shared-sections.md Phase 3 options are:
```
P3 (max 1 file): react-patterns.md | backend-development.md | backend-security.md | testing.md | scss-standards.md (T2 only)
```

`implementation.md` is not listed. T3 agents implement TypeScript code without access to the core implementation standards.

**Evidence:** High confidence — direct file review of _shared-sections.md Phase 3 section shows implementation.md is not listed as option.

**Impact:** T3 agents lack guidance on core TypeScript patterns (error classes, factory pattern, composition, test patterns). Code review will find violations of these standards, requiring revisions and escalations.

**Recommendation:**
1. **Immediate:** Add `implementation.md` to Phase 3 options in _shared-sections.md with task trigger: "When implementing TypeScript/Node.js code"
2. Update mid-coder.md §Skills to Load to show `implementation.md` as available Phase 3 option.
3. Update task-assignment-matrix.md to specify when `implementation.md` should be loaded (all TypeScript implementation tasks).
4. Test: spawn a T3 agent on a TypeScript implementation task and verify implementation.md is loaded.

**Fix Priority:** Before next T3 TypeScript coding task.

---

### RC-005 (CRITICAL): api-integration.md Never Loaded by Coding Agents

**Severity:** P1 — Critical Agent Skill Gap  
**Files:**
- `.claude/rules/api-integration.md` (all sections)
- `.claude/agents/mid-coder.md` (Skills to Load)
- `.claude/agents/staff-engineer.md` (Skills to Load)
- `.claude/config/_shared-sections.md` (Standard Skills to Load)

**Finding:**
`api-integration.md` defines:
- API contract: ApiResponse<T>, HTTP methods, camelCase naming
- Auth patterns: Bearer tokens, refresh token rotation
- Axios interceptors, retry logic, error mapping
- Pagination: 1-based frontend, 0-based backend
- CORS, rate limiting, caching headers

No coding agent (T3 or T2) loads `api-integration.md`. T3/T2 implement API endpoints, services, and clients without access to these standards.

**Evidence:** High confidence — direct file review shows api-integration.md is not in any Phase (Phase 1-4) in _shared-sections.md.

**Impact:** Agents implementing APIs without guidance on contract, auth, interceptors, error mapping. Code review will flag violations.

**Recommendation:**
1. **Immediate:** Add `api-integration.md` to Phase 3 options in _shared-sections.md for API-related tasks.
2. Update task-assignment-matrix.md to include: "Load api-integration.md for tasks involving API endpoint implementation, service integration, or client-side API logic."
3. Update mid-coder.md and staff-engineer.md to show api-integration.md as available Phase 3 option.
4. Test: spawn T3 on API endpoint implementation task and verify api-integration.md is loaded.

**Fix Priority:** Before next API implementation task.

---

### RC-007 (CRITICAL): T4 Lead Analyst Never Loads code-review.md

**Severity:** P1 — Critical Role Gap  
**Files:**
- `.claude/agents/lead-analyst.md` (Skills to Load section)
- `.claude/rules/code-review.md` (§Review Process, §Review Checklist)

**Finding:**
T4 Lead Analyst's primary function is quality review of T3/T5 outputs. However, lead-analyst.md Skills to Load section specifies only:
```
Phase 1: clean-code.md (always)
Phase 3: No other rules listed (unlike T3/T2 who load domain-specific rules)
```

`code-review.md` (§Review Process, §Severity Levels, §Review Checklist, §Tier-Specific Review Rules) is not loaded by T4.

**Evidence:** High confidence — direct file review of lead-analyst.md shows code-review.md not listed in Skills to Load.

**Impact:** T4 reviewers lack explicit guidance on:
- Review checklist (function length, file length, naming, architecture, testing)
- Severity levels (Critical, Major, Minor, Suggestion)
- Tier-specific review rules for T2→T3 review chain
- Feedback format examples

**Recommendation:**
1. **Immediate:** Add code-review.md to lead-analyst.md §Skills to Load as "Phase 1 or Phase 2 (always for review tasks)"
2. Update code-review.md to add §T4→T5 Review Tier Rules section (currently only has T2→T3 and T1→T2 rules)
3. Update _shared-sections.md Phase 1 for T4 to explicitly list code-review.md.
4. Test: spawn T4 on review task and verify code-review.md is loaded.

**Fix Priority:** Before next T4 review task.

---

### RC-006 (MAJOR): code-architecture.md Never Loaded by T1 Principal

**Severity:** P1 — Major Role Gap  
**Files:**
- `.claude/agents/principal.md` (Skills to Load section)
- `.claude/rules/code-architecture.md` (all sections)

**Finding:**
T1 Principal makes architecture decisions (Step 2: Prompt Enrichment, Step 3: Task Division and DAG Construction). `code-architecture.md` defines:
- Layered architecture (Presentation → Application → Domain → Infrastructure)
- Feature-based modular structure (frontend)
- SOLID application guide
- Hexagonal architecture (backend)
- ADR format
- Composition vs inheritance
- Micro-frontend module federation rules

T1's Skills to Load in principal.md shows Phase 2 (PCD) and Phase 3 domain rules but does not explicitly list `code-architecture.md`.

**Evidence:** High confidence — direct file review of principal.md Skills section shows architecture file not listed.

**Impact:** T1 architects lack guidance on layered architecture, SOLID principles, and ADR format when making design decisions. Architecture decisions may not follow established patterns.

**Recommendation:**
1. **Immediate:** Add `code-architecture.md` to principal.md §Skills to Load as "Phase 2 (PCD) — always for architecture-related tasks"
2. Update _shared-sections.md to note that T1 loads code-architecture.md as core skill for principal role.
3. Update task-assignment-matrix.md: "Load code-architecture.md for T1 tasks involving system design, module structure, or architectural decisions."
4. Test: spawn T1 on architecture task and verify code-architecture.md is loaded.

**Fix Priority:** Before next T1 architecture decision task.

---

### RC-008 (MAJOR): Project Templates Contain Zero Rule References

**Severity:** P1 — Major Discovery Path Gap  
**Files:**
- `.claude/templates/full-stack.md` (entire file)
- `.claude/templates/react-spa.md` (entire file)
- `.claude/templates/spring-boot.md` (entire file)

**Finding:**
All three project templates define tech stacks, project structures, and key patterns but contain zero explicit references to rule files. A developer bootstrapping from a template has no pointer to applicable rule files:

| Template | Patterns Covered | Corresponding Rule Files (not referenced) |
|----------|-----|-----|
| full-stack.md | API contract, HTTP methods, Bearer JWT, env config | api-integration.md, backend-development.md, backend-security.md |
| react-spa.md | AAA pattern, useForm, Ant Design, unit tests | testing.md, react-patterns.md, scss-standards.md |
| spring-boot.md | Constructor injection, line coverage 80%, Maven profiles | backend-development.md, java-quality-tooling.md, testing.md |

**Evidence:** High confidence — manual search of all three template files for ".md" references yields zero rule file mentions.

**Impact:** Developers using templates are unaware of coding standards they should follow. First-time developers have no rule discovery path beyond CLAUDE.md.

**Recommendation:**
1. **Add "Rules in Effect" section to each template** (10 lines each, minimal effort):
   
   **full-stack.md:**
   ```markdown
   ## Rules in Effect
   All developers on full-stack tasks should familiarize themselves with:
   - `api-integration.md` — API contract, HTTP methods, authentication patterns
   - `backend-development.md` — Layered architecture, dependency injection, transaction management
   - `backend-security.md` — SQL injection prevention, XSS prevention, authentication security
   - `react-patterns.md` — React component patterns, state management, performance
   - `testing.md` — Unit test structure and coverage requirements
   ```

   **react-spa.md:**
   ```markdown
   ## Rules in Effect
   - `react-patterns.md` — Component design, hooks, state management, performance, accessibility
   - `testing.md` — Unit test structure (AAA pattern), coverage targets
   - `scss-standards.md` — Styling standards, BEM naming, design tokens
   - `api-integration.md` — Axios interceptors, error handling, API contracts
   ```

   **spring-boot.md:**
   ```markdown
   ## Rules in Effect
   - `backend-development.md` — Layered architecture, repository pattern, transaction management
   - `backend-security.md` — SQL injection prevention, JWT security, CORS configuration
   - `java-quality-tooling.md` — Checkstyle, SpotBugs, JaCoCo thresholds
   - `testing.md` — Unit test structure (AAA pattern), coverage targets
   ```

2. Link to full rule file contents in each section.
3. Test: ensure a new developer can navigate from template to rule files.

**Fix Priority:** Before next developer onboarding.

---

### F-007/F-017 (MAJOR): context-budget.json Missing max_pcd_tokens Field

**Severity:** P1 — Major Schema Gap  
**Files:**
- `.claude/config/context-budget.json` (all tiers)
- `.claude/config/tier-definitions.md` (line 19, Tier Token Budget table)

**Finding:**
tier-definitions.md "Tier Token Budget" table has a "PCD Tokens" column (8K for T1, 6K for T2, etc.).  
context-budget.json schema does not have a "max_pcd_tokens" field:
```json
"T1": {
  "max_skills": 5,
  "max_pcd_files": 10,
  "max_tokens_per_task": 8000  // ← Ambiguous: is this PCD tokens or total task tokens?
}
```

**Ambiguity:** Does "max_tokens_per_task" include PCD allocation or exclude it?

**Evidence:** High confidence — explicit column in md; missing field in JSON; no clarifying documentation.

**Recommendation:**
1. **Update context-budget.json** to separate PCD tokens from task tokens:
   ```json
   "T1": {
     "model": "opus",
     "max_skills": 5,
     "max_pcd_files": 10,
     "max_pcd_tokens": 8000,       // ← New: explicit PCD budget
     "max_tokens_per_task": 32000,  // ← Task budget (includes PCD + agent work)
     ...
   }
   ```

2. **Update context-budget.md prose** to clarify:
   ```markdown
   ## Token Budget Components
   - **max_pcd_tokens**: Tokens reserved for loading configuration and rule files at spawn time (static per tier)
   - **max_tokens_per_task**: Total token budget for the agent's task execution (includes PCD + agent work)
   - **Calculation**: Effective per-task budget = max_tokens_per_task (PCD already reserved)
   ```

3. Verify all tiers: T1, T2, T3, T4, T5 have both fields.

**Fix Priority:** Before next T1-T4 spawn (needed for accurate budget calculation).

---

### F-006 (MAJOR): agent-performance.md Session History Table Empty

**Severity:** P1 — Major Metrics Gap  
**File:** `.claude/metrics/agent-performance.md` (lines 13-16)

**Finding:**
Session history table is defined but empty:
```markdown
| Date | Session ID | Mode | Total Tasks | Completed | Failed | Fallbacks |
|------|-----------|------|-------------|-----------|--------|-----------|
```

File contains detailed session reports (lines 26+) for 2026-04-17 and 2026-04-18 but table is blank.

**Root Cause:** Template was created but never populated. Detailed sections are manually maintained; table was forgotten.

**Evidence:** High confidence — table structure exists; rows are visibly missing.

**Impact:** Metrics are incomplete. Session history cannot be quickly scanned for operational health (completed vs failed task ratios, fallback frequency).

**Recommendation:**
1. **Populate table from detailed sections:**
   ```markdown
   | 2026-04-17 | 2026-04-17-x10-impl | x10 | 6 | 6 | 0 | 0 |
   | 2026-04-18 | 2026-04-18-x10-analysis | x10 | 10 | 10 | 0 | 0 |
   ```

2. **Add a post-session hook** (new session-metrics-gen.sh) to auto-populate this table after session end, OR
3. Document in session template that Orchestrator must fill this table manually.

**Fix Priority:** Next session (for operational continuity).

---

### RC-001 (MAJOR): api-integration.md Has Zero Hook Enforcement

**Severity:** P1 — Major Enforcement Gap  
**File:** `.claude/rules/api-integration.md` (all sections)

**Finding:**
`api-integration.md` contains enforceable code rules:
- CORS configuration (never use wildcard origins)
- Auth header format (Bearer token only)
- localStorage token storage (SECURITY: should NOT use)

**hook-registry.md** lists no hook for api-integration.md. No automated enforcement exists.

**Evidence:** High confidence — hook-registry.md review shows no api-integration-check.sh; file analyzed in A-302.

**Impact:** Violations of API standards (wildcard CORS, insecure token storage) are not caught until code review, delaying feedback.

**Recommendation:**
1. **Add enforcement hook** (api-integration-check.sh):
   - Check for CORS config with wildcard ("*") origin
   - Flag localStorage usage for sensitive data (tokens)
   - Flag unsafe HTTP methods on sensitive endpoints
   
   OR

2. **Add to existing backend-security.sh** if code parsing allows (merge api-integration rules into one hook for auth/CORS enforcement).

3. **Add `[HOOK: api-integration-check.sh]` tags** to enforceable rules in api-integration.md (e.g., §CORS Configuration).

**Fix Priority:** Next security hardening cycle (medium priority; security contradiction RC-009 is higher).

---

### RC-002 (MAJOR): implementation.md Has Zero Hook Enforcement

**Severity:** P1 — Major Enforcement Gap  
**File:** `.claude/rules/implementation.md` (§Absolute Prohibitions section)

**Finding:**
`implementation.md` contains enforceable TypeScript prohibitions:
- No `var` (use `const` or `let`)
- No loose equality (`==`, `!=`; use `===`, `!==`)
- No `any` type
- No `@ts-ignore`

**Enforcement:** Zero hooks exist for these rules. They are checked only during code review.

**Evidence:** High confidence — hook-registry.md lists no hook for implementation.md. Analysis A-302 confirmed.

**Impact:** TypeScript standard violations slip into code until review, delaying feedback.

**Recommendation:**
1. **Extend existing block-any-type.sh hook** to also block `var` declarations and loose equality operators:
   - Pattern: `\bvar\s+` → block with message "Use const or let, not var"
   - Pattern: `[!=]=(?!=)` → block with message "Use === or !==, not == or !="

2. **Add `[HOOK: block-any-type.sh]` tags** to implementation.md rules (already has tags for react-patterns.md).

3. **Verify hook can run on .ts and .tsx files** (currently designed for TypeScript; confirm no Java false positives).

**Fix Priority:** Next session (medium priority; rule loading gaps RC-004/RC-005 are higher).

---

### F-016 (MAJOR): Token Estimation Baseline Underestimates by 40-50%

**Severity:** P1 — Operational Planning Gap  
**File:** `.claude/metrics/token-usage.md` (lines 22-48)

**Finding:**
Token estimate vs actual across 2 sessions:
```
Session 2026-04-17 | Estimated 61K | Actual ~257K | Delta +196K (+322%)
Session 2026-04-18 | Estimated 83K | Actual ~562K | Delta +479K (+577%)
```

Average actual usage is **3–5x estimated**. Pattern is consistent (two consecutive sessions), indicating systematic underestimation.

**Root Cause:** Baseline estimates in context-budget.md (lines 18-28) do not account for:
- Intensive tool use (18–29 Read/Grep/Glob operations per agent)
- Multi-file analysis with full file reads
- Review feedback loops and escalations

**Evidence:** High confidence — explicit token counts from session reports (A-102, A-301 analysis).

**Impact:** Budget planning is unreliable. T3 task budgets marked as 3–6K are actually 5–10K. Leads to overflow and task failures.

**Recommendation:**
1. **Recalibrate context-budget.md baseline estimates** (increase by 40–50%):
   ```markdown
   Old: "Codebase analysis: 3–6K tokens"
   New: "Codebase analysis: 5–10K tokens"
   
   Old: "Refactoring: 2–5K tokens"
   New: "Refactoring: 4–8K tokens"
   ```

2. **Increase per-tier budgets in context-budget.json** (adjust max_tokens_per_task for each tier):
   ```json
   "T3": {
     "max_tokens_per_task": 6000,  // was 4000–5000; increase to 6000
   }
   "T2": {
     "max_tokens_per_task": 12000,  // increase from ~10000
   }
   ```

3. **Recalibrate after next 2–3 sessions** to refine accuracy further.

4. **Review CLAUDE.md Step 3 Overflow Protocol** (15K limit per sub-task): may be too aggressive for analysis-heavy tasks.

**Fix Priority:** Before next session (affects budget allocation).

---

### F-008 (MAJOR): PCD Terminology Unclear Across Files

**Severity:** P1 — Documentation Gap  
**Files:**
- `.claude/config/tier-definitions.md` (line 19, column header "PCD Tokens")
- `.claude/config/context-budget.md` (prose, uses "PCD context")
- CLAUDE.md (Step 3, mentions "skills")

**Finding:**
- tier-definitions.md says "PCD Tokens" (implying token count)
- context-budget.md says "PCD context" (unclear: files? tokens? both?)
- CLAUDE.md Step 3 says "Assign skills per agent — respect context-budget.md limits" but "skills" are not defined

**Ambiguity:** Is PCD measured in files, tokens, or both? What is a "skill"?

**Evidence:** Medium confidence — terminology is used but not explicitly defined.

**Recommendation:**
1. **Add a Terminology section to context-budget.md:**
   ```markdown
   ## Terminology
   - **PCD (Project Context Data)**: Configuration files (tier-definitions.md, delegation-rules.md, etc.) and rule files (clean-code.md, react-patterns.md, etc.) loaded at agent spawn time.
   - **PCD Files**: Count of .md files in PCD bundle per tier (tier-definitions.md "Max Context Files" column).
   - **PCD Tokens**: Estimated token cost of loading those PCD files (tier-definitions.md "PCD Tokens" column).
   - **max_tokens_per_task**: Maximum token budget for agent's task execution (separate allocation; includes PCD + task work).
   - **Skills**: Rule files selected per phase (Phase 1 = clean-code.md, Phase 3 = one domain rule) based on task type.
   ```

2. **Update CLAUDE.md Step 3** to use "rules" instead of "skills" for clarity (or add definition of "skills").

3. **Add frontmatter to context-budget.json** with schema documentation.

**Fix Priority:** Before next documentation update (low urgency; clarification only).

---

## P2 — Quality Issues

### RC-003 (MINOR): code-architecture.md Has Zero Hook Enforcement

**Severity:** P2 — Minor (acceptable for architectural rules)  
**File:** `.claude/rules/code-architecture.md`

**Finding:**
No enforcement hook exists for `code-architecture.md`. Architectural rules are review-enforced (manually), not hook-enforced.

**Assessment:** This is acceptable. Architectural patterns (layered architecture, SOLID, hexagonal patterns) are emergent properties that are difficult to enforce with static analysis. Code review is the appropriate enforcement mechanism.

**Recommendation:**
1. Add explicit note in code-architecture.md:
   ```markdown
   ## Enforcement
   Architectural rules are enforced through code review (see code-review.md §Tier-Specific Review Rules §Principal to Staff Engineer Review).
   Static analysis hooks cannot verify architectural alignment; human review is required.
   ```

2. Reference code-architecture.md in code-review.md checklist for T1/T2 reviewers.

**Fix Priority:** Low (documentation only; no functional gap).

---

### RC-013 (MINOR): Function Length Limits Differ Without Language Context

**Severity:** P2 — Minor  
**Files:**
- `clean-code.md` (20 lines max, applies to TypeScript)
- `java-quality-tooling.md` (80 lines max via Checkstyle, applies to Java)

**Finding:**
Function length limits differ:
- clean-code.md: 20 lines max (TypeScript)
- java-quality-tooling.md: 80 lines max (Java)

**Assessment:** This is not a true contradiction. Java's verbosity (getters/setters, type declarations) justifies longer methods. However, multi-stack agents (T3 working on full-stack) could apply the wrong limit if not careful.

**Recommendation:**
1. **Add language context** to both rules:
   
   **clean-code.md:**
   ```markdown
   - **Maximum 20 lines** per function (TypeScript/JavaScript only. Java methods have separate limits in java-quality-tooling.md)
   ```

   **java-quality-tooling.md:**
   ```markdown
   | Maximum method length | 80 lines (Java only. TypeScript functions limited to 20 lines per clean-code.md) |
   ```

2. Update mid-coder.md and staff-engineer.md to note: "Function length limits differ by language. Load both clean-code.md and relevant domain-specific rule (backend-development.md for Java) to ensure correct limit."

**Fix Priority:** Low (mostly educational; limits are language-appropriate).

---

### RC-014 (MINOR): scss-standards.md Thin Coverage

**Severity:** P2 — Minor  
**File:** `.claude/rules/scss-standards.md` (55 lines)

**Finding:**
Shortest rule file in the set. Covers BEM, units, colors, anti-patterns but lacks:
- Media query breakpoint standards
- Module composition patterns (when to create new modules)
- Complex classNames() usage examples
- Naming conventions for nested selectors

**Recommendation:**
1. Expand scss-standards.md with 20–30 additional lines covering:
   ```markdown
   ## Breakpoint Standards
   - Mobile-first approach: min-width breakpoints
   - Desktop: @media (min-width: 1024px)
   - Tablet: @media (min-width: 768px)
   - Store breakpoints in a SCSS map for consistency
   
   ## Module Composition
   - Create a new SCSS module when:
     - File exceeds 150 lines
     - Module serves more than one feature
     - Common mixins/variables needed across 2+ features
   
   ## Complex classNames() Examples
   - Example: conditional class application in component modules
   ```

2. Link from react-patterns.md to scss-standards.md (currently minimal cross-reference).

**Fix Priority:** Low (cosmetic; coverage is adequate for core needs).

---

### F-015 (INFO): settings.local.json Contains Stale Permissions

**Severity:** P2 — Info (operational housekeeping)  
**File:** `.claude/settings.local.json` (lines 4–20)

**Finding:**
Contains 6 Bash permissions from previous session:
```json
"Bash(chmod +x *)",
"Bash(ls -lt /Users/tcvmaksutoglu/.claude-corp/...)",
...
```

Very specific (hard-coded paths, line numbers). Likely from prior orchestration. Unclear if persistent or session-only.

**Recommendation:**
1. **Document a retention policy:**
   - If session-only: add comment at top of settings.local.json:
     ```json
     // Auto-cleaned after session end. Session-specific permissions only.
     ```
   - If persistent: add documentation for each permission explaining why it's needed.

2. **Current state:** Review and either delete or document these permissions before next session.

**Fix Priority:** Low (housekeeping; no functional impact).

---

### F-003 (MINOR): Hook Wiring Completeness Unclear

**Severity:** P2 — Minor  
**File:** `.claude/config/hook-registry.md`, `.claude/settings.json`

**Finding:**
hook-registry.md lists 16 hooks. settings.json declares 13 hooks wired (11 PreToolUse + 2 SessionEnd). Question: are all 16 hooks actually functional?

**Note from A-102:** "Both SessionEnd hooks present in settings.json (lines 128–144) so only 11 PreToolUse declared. Total 13 hooks wired."

**Assessment:** Wiring appears complete (11 PreToolUse + 2 SessionEnd = 13 of 16 hooks mentioned). The discrepancy may be that 3 hooks are documented but not yet implemented (e.g., pattern-lifecycle.sh is documented but implementation status unclear).

**Recommendation:**
1. Verify all 16 hooks have corresponding shell scripts in `.claude/hooks/` directory.
2. Verify all 16 are wired in settings.json (may be under different categories: PreToolUse, PostToolUse, SessionEnd, etc.).
3. If 3 hooks are not yet implemented, document their status in hook-registry.md (§Status: Planned, Not Yet Implemented).

**Fix Priority:** Low (verification only; no functional gap indicated).

---

### F-009 / F-010 (MINOR): T5 and T3 Templates Missing Explicit Bash Prohibition

**Severity:** P2 — Minor (clarity only)  
**Files:**
- `.claude/agents/analyst.md` (lines 38–43)
- `.claude/agents/mid-coder.md` (lines 38–42)

**Finding:**
Both templates list Prohibited Tools but do not explicitly state "Bash | [reason]".

**Assessment:** This is a minor consistency issue. CLAUDE.md Step 4 implies agents cannot execute Bash (spawned via Agent tool, not direct Bash), but it's not explicitly called out in T5/T3 templates like it is in T4 lead-analyst.md.

**Recommendation:**
1. Add explicit Bash prohibition rows to analyst.md and mid-coder.md Prohibited Tools sections:
   ```markdown
   | Tool | Prohibition | Reason |
   |------|----------|--------|
   | Bash | Prohibited | T{N} does not execute commands; research/implementation only |
   ```

**Fix Priority:** Very low (documentation clarity; no functional impact).

---

## P3 — Improvements

### RC-006 (MINOR): Add "Unmatched Task Types" Guidance to delegation-rules.md

**Severity:** P3 — Minor  
**File:** `.claude/config/delegation-rules.md`

**Finding:**
delegation-rules.md provides xN distribution table but does not address:
1. What if a task doesn't fit task-assignment-matrix categories?
2. What if a task requires more tokens than any tier's max budget?

Current guidance exists in CLAUDE.md Step 3 (Overflow Protocol, line 53) but not in delegation-rules.md.

**Recommendation:**
Add a section to delegation-rules.md:
```markdown
## Handling Unmatched Tasks

If a task does not fit the task-assignment-matrix categories:
1. Route to T1 Principal for tier assignment recommendation
2. Document the task type and tier decision
3. Consider proposing a new row in task-assignment-matrix.md for future similar tasks

If a task exceeds available tier budgets (per context-budget.md):
- See CLAUDE.md §Step 3 Overflow Protocol for escalation guidance
```

**Fix Priority:** Very low (documentation; covered elsewhere).

---

### RC-012 (MINOR): TypeScript Standards Scattered Across 3 Files

**Severity:** P3 — Minor  
**Files:**
- `implementation.md` (patterns)
- `react-patterns.md` (React + TypeScript)
- `clean-code.md` (language-agnostic)

**Finding:**
TypeScript-specific standards are split across 3 files. Agents loading only one may miss guidance.

**Recommendation:**
Option A: Create dedicated `typescript-standards.md` consolidating:
- Type system rules (interface vs type, generics, mapped types)
- Module rules (import ordering, barrel exports)
- Error handling (domain error classes)

Option B: Add cross-references in implementation.md:
```markdown
See also: clean-code.md §Import Rules, react-patterns.md §TypeScript Type Patterns for additional TypeScript guidance.
```

**Current state:** Option B is lower effort and acceptable. Option A would improve discoverability for T3 agents.

**Fix Priority:** Very low (educational improvement; adequate coverage exists).

---

### RC-011 (MINOR): No Dedicated Logging Standards for Frontend

**Severity:** P3 — Minor  
**File:** None (gap in rules)

**Finding:**
`block-console-log.sh` prohibits console.log but provides no positive guidance on what to use instead for frontend logging.

**Recommendation:**
Option A: Expand backend-development.md §Structured Logging to include frontend guidance:
```markdown
## Structured Logging (Both Frontend and Backend)

Frontend: Use a structured logging library like pino-browser or browser-logs...
Backend: Use Winston, Pino, or similar...
```

Option B: Create `logging-standards.md` with frontend + backend sections.

Current state: Acceptable with Option A (lower effort). Hooks enforce the prohibition; teams must choose their logging library.

**Fix Priority:** Very low (teams have no guidance but prohibition is clear).

---

### RC-015 (MINOR): spring-boot.md Missing Flyway Migration Setup

**Severity:** P3 — Minor  
**File:** `.claude/templates/spring-boot.md`

**Finding:**
spring-boot.md does not mention Flyway migrations despite backend-development.md requiring "Database migrations versioned and tracked (Flyway for Java)".

**Recommendation:**
Add a section to spring-boot.md §Key Patterns:
```markdown
### Database Migrations

Use Flyway for version-controlled migrations. Place migration files in `src/main/resources/db/migration/` directory:

Example: `V1__create_users_table.sql`

Maven automatically runs migrations on application startup via the org.flywaydb:flyway-maven-plugin.
```

**Fix Priority:** Very low (documentation only).

---

### RC-016 (MINOR): code-review.md Missing T4→T5 Review Tier Rules

**Severity:** P3 — Minor  
**File:** `.claude/rules/code-review.md`

**Finding:**
§Tier-Specific Review Rules covers T2→T3 and T1→T2 review chains but does not specify rules for T4 (Lead Analyst) reviewing T5 (Analyst) outputs.

**Recommendation:**
Add a section to code-review.md:
```markdown
### Lead Analyst to Analyst Review (T4→T5)

T4 Lead Analyst reviews T5 Analyst reports for:
- Format compliance with analysis.md report template
- Source references verified and accessible
- Confidence levels justified with evidence
- Completeness of analysis scope
- Actionability of findings and recommendations
- Cross-reference validation between findings
```

**Fix Priority:** Very low (documentation only).

---

## Consolidated Findings Table

| ID | Component | Category | Severity | Finding (consolidated) | Sources | Status |
|----|-----------|----------|----------|------------------------|---------|--------|
| RC-009 | `api-integration.md` vs `backend-security.md` | Security | **P0-Critical** | localStorage vs memory/httpOnly contradiction for access tokens (XSS vulnerability) | A-302 | CONTRADICTS - MUST FIX |
| F-005 | `name-pool.md` vs `leaderboard.md` | Config Consistency | **P0-Critical** | Score desync: name-pool all 0, leaderboard shows 8 agents with score=8 | A-102 | STALE DATA |
| F-001 | `context-budget.json` vs `tier-definitions.md` | Config Consistency | **P0-Critical** | T3 max_tokens_per_task: JSON says 5000, tier-definitions says 4K | A-102 | MISMATCH |
| F-002 | `leaderboard.md` | Metrics | **P0-Critical** | 5 duplicate placeholder rows (marked "dup") in ranked table | A-102 | DATA CORRUPTION |
| RC-004 | `implementation.md` | Agent Skills | **P1-Critical** | Never loaded by T3 MidCoder despite being core TypeScript standards | A-302 | LOADING GAP |
| RC-005 | `api-integration.md` | Agent Skills | **P1-Critical** | Never loaded by any coding agent; required for API endpoints and services | A-302 | LOADING GAP |
| RC-007 | `code-review.md` | Agent Skills | **P1-Critical** | Never loaded by T4 Lead Analyst despite quality review being primary function | A-302 | LOADING GAP |
| RC-006 | `code-architecture.md` | Agent Skills | **P1-Major** | Never loaded by T1 Principal; architecture decisions unguided by standards | A-302 | LOADING GAP |
| RC-008 | Project templates (3 files) | Templates | **P1-Major** | Zero rule file references in any template; no rule discovery path for developers | A-302 | DISCOVERY GAP |
| F-007 / F-017 | `context-budget.json` | Config Schema | **P1-Major** | Missing "max_pcd_tokens" field; ambiguity between PCD and task token budgets | A-102 | INCOMPLETE SCHEMA |
| F-006 | `agent-performance.md` | Metrics | **P1-Major** | Session history table empty despite 2 completed sessions with data | A-102 | INCOMPLETE TABLE |
| RC-001 | `api-integration.md` | Hook Enforcement | **P1-Major** | Zero hook enforcement for enforceable rules (CORS, auth, localStorage) | A-302 | UNHOOKED |
| RC-002 | `implementation.md` | Hook Enforcement | **P1-Major** | Zero hook enforcement for TypeScript prohibitions (var, loose equality) | A-302 | UNHOOKED |
| F-016 | `token-usage.md` | Metrics Calibration | **P1-Major** | Token estimates underestimate by 40-50% across 2 sessions (3–5x actual) | A-102 | CALIBRATION NEEDED |
| F-008 | `tier-definitions.md`, `context-budget.md`, CLAUDE.md | Documentation | **P1-Major** | PCD terminology unclear; "PCD Tokens" vs "PCD context" vs "skills" undefined | A-102 | TERMINOLOGY GAP |
| RC-003 | `code-architecture.md` | Hook Enforcement | **P2-Minor** | Zero hook enforcement (acceptable for review-enforced architecture rules) | A-302 | BY DESIGN |
| RC-013 | `clean-code.md` vs `java-quality-tooling.md` | Contradiction | **P2-Minor** | Function length limits differ (20 lines TypeScript vs 80 lines Java) without language context | A-302 | CONTEXT MISSING |
| RC-014 | `scss-standards.md` | Rule Quality | **P2-Minor** | Thinnest rule file (55 lines); missing breakpoint standards and module composition | A-302 | THIN COVERAGE |
| F-015 | `settings.local.json` | Config State | **P2-Info** | Stale session permissions (6 Bash, 1 Python) from previous session; retention policy unclear | A-102 | HOUSEKEEPING |
| F-003 | `.claude/settings.json` vs `hook-registry.md` | Config Completeness | **P2-Minor** | Hook wiring mostly complete (13 of 16); 3 hooks status unclear | A-102 | VERIFICATION NEEDED |
| F-009 / F-010 | `analyst.md`, `mid-coder.md` | Template | **P2-Minor** | Bash prohibition not explicitly stated (clarity issue only) | A-102 | CLARITY |
| RC-006 | `delegation-rules.md` | Documentation | **P3-Minor** | No guidance on unmatched task types (covered in CLAUDE.md but not here) | A-102 | DOCUMENTATION |
| RC-012 | System-wide | Rule Organization | **P3-Minor** | TypeScript standards scattered across 3 files (implementation.md, react-patterns.md, clean-code.md) | A-302 | ORGANIZATION |
| RC-011 | System-wide | Missing Rule | **P3-Minor** | No frontend logging standards; block-console-log.sh has no positive guidance | A-302 | MISSING GUIDANCE |
| RC-015 | `spring-boot.md` | Template | **P3-Minor** | Flyway migration not mentioned despite backend-development.md requiring it | A-302 | TEMPLATE GAP |
| RC-016 | `code-review.md` | Rule Quality | **P3-Minor** | T4→T5 review tier rules not specified (only T2→T3 and T1→T2 defined) | A-302 | INCOMPLETE |
| F-010 | CLAUDE.md | Accuracy | **P3-Minor** | Rule file count stated as 15; actual is 16 (includes analysis.md) | A-102 | MINOR INACCURACY |

---

## Fix Roadmap (Ordered by Impact & Dependencies)

### Immediate (Before Next Session)

**Must Fix — Critical Security & Operational Blockers:**

1. **RC-009: Resolve localStorage vs httpOnly contradiction**
   - Update `api-integration.md` to align with `backend-security.md` (use memory/httpOnly, not localStorage)
   - Add cross-reference in both files
   - Add note to _shared-sections.md that T3/T2 must load both files for auth tasks
   - *Effort: 1 hour | Blocks: any auth implementation*

2. **F-005: Sync name-pool.md scores with leaderboard.md**
   - Copy current scores from leaderboard.md Rank 1-10 to name-pool.md
   - Establish post-session sync in update-leaderboard.sh (atomic update of both files)
   - *Effort: 30 min | Blocks: agent selection algorithm*

3. **F-001: Fix context-budget.json T3 token budget**
   - Change T3 max_tokens_per_task from 5000 to 4000
   - Verify all other tiers match tier-definitions.md
   - *Effort: 15 min | Blocks: budget allocation*

4. **F-002: Remove duplicate placeholder rows from leaderboard.md**
   - Delete rows 17-21 (marked "dup")
   - Re-index numbered rank column
   - *Effort: 10 min | Blocks: metrics accuracy*

---

### High Priority (Before Next Coding Session)

**Must Fix — Critical Agent Skill Loading Gaps:**

5. **RC-004: Add implementation.md to Phase 3 options**
   - Update `_shared-sections.md` Phase 3 to include "implementation.md" for TypeScript tasks
   - Update `mid-coder.md` §Skills to Load
   - Update `task-assignment-matrix.md` to trigger on "TypeScript implementation" tasks
   - *Effort: 1 hour | Blocks: T3 TypeScript coding tasks*

6. **RC-005: Add api-integration.md to Phase 3 options**
   - Update `_shared-sections.md` Phase 3 to include "api-integration.md" for API tasks
   - Update `mid-coder.md` and `staff-engineer.md` §Skills to Load
   - *Effort: 1 hour | Blocks: T3/T2 API implementation tasks*

7. **RC-007: Add code-review.md to lead-analyst.md Skills**
   - Update `lead-analyst.md` §Skills to Load to always include "code-review.md"
   - Add §T4→T5 Review Rules to `code-review.md`
   - *Effort: 1 hour | Blocks: T4 review tasks*

8. **RC-006: Add code-architecture.md to principal.md Skills**
   - Update `principal.md` §Skills to Load to include "code-architecture.md" for architecture tasks
   - Update `_shared-sections.md` Phase 2 (PCD) for T1
   - *Effort: 1 hour | Blocks: T1 architecture decisions*

---

### Medium Priority (Before Next Session + 1)

**Should Fix — Major Consistency & Template Gaps:**

9. **RC-008: Add "Rules in Effect" sections to all 3 project templates**
   - Add 10-line section to each template listing 3-5 relevant rule files
   - Link to full rule file contents
   - *Effort: 1.5 hours | Improves: developer onboarding*

10. **F-007 / F-017: Add max_pcd_tokens field to context-budget.json**
    - Add field to all 5 tiers (T1, T2, T3, T4, T5)
    - Update `context-budget.md` with terminology section (PCD Files vs PCD Tokens vs Task Tokens)
    - *Effort: 1 hour | Blocks: accurate budget calculation for T1-T4*

11. **F-006: Populate agent-performance.md session history table**
    - Manually fill table from detailed sections (2 rows for existing sessions)
    - Document whether Orchestrator or hook should maintain this table
    - *Effort: 30 min | Improves: operational visibility*

12. **F-016: Recalibrate token estimation baselines**
    - Increase all baseline estimates in `context-budget.md` by 40–50%
    - Increase `max_tokens_per_task` for each tier in `context-budget.json`
    - Review CLAUDE.md §Overflow Protocol 15K limit
    - *Effort: 1 hour | Improves: budget planning accuracy*

---

### Low Priority (Next Cycle)

**Nice-to-Have — Enforcement, Documentation, Quality:**

13. **RC-001: Create api-integration-check.sh enforcement hook**
    - Add hook to block wildcard CORS origins and localStorage usage
    - Or merge into existing backend-security hooks
    - *Effort: 2 hours | Enforcement tool*

14. **RC-002: Extend block-any-type.sh to block var and loose equality**
    - Extend hook patterns for `var` declarations and `==` / `!=`
    - *Effort: 1 hour | Enforcement tool*

15. **F-008: Add terminology section to context-budget.md**
    - Define PCD, PCD Files, PCD Tokens, max_tokens_per_task, skills
    - *Effort: 30 min | Documentation clarity*

16. **F-003: Verify all 16 hooks are wired in settings.json**
    - List each hook, confirm wiring status, document any unimplemented hooks
    - *Effort: 1 hour | Verification*

17. **RC-014: Expand scss-standards.md with 20-30 lines**
    - Add breakpoint standards, module composition patterns, classNames() examples
    - *Effort: 1.5 hours | Rule quality*

18. **RC-013: Add language context to function length limits**
    - Update `clean-code.md` and `java-quality-tooling.md` with "(TypeScript)" / "(Java)" qualifiers
    - *Effort: 30 min | Clarity*

19. **F-009 / F-010: Add explicit Bash prohibition to T5 and T3 templates**
    - Add rows to Prohibited Tools sections in analyst.md and mid-coder.md
    - *Effort: 15 min | Clarity*

20. **F-015: Document settings.local.json retention policy**
    - Add comment or policy document explaining session-only vs persistent permissions
    - Review and delete/document existing permissions
    - *Effort: 30 min | Housekeeping*

21. **Minor fixes:**
    - RC-012: Add cross-references for TypeScript standards
    - RC-011: Expand backend-development.md or create logging-standards.md
    - RC-015: Add Flyway migration section to spring-boot.md template
    - RC-016: Add T4→T5 review rules to code-review.md
    - F-010: Update CLAUDE.md rule count from 15 to 16
    - *Combined effort: 2 hours | Documentation improvements*

---

## Dependencies & Execution Order

```
PHASE 1 (Critical Blockers — before next session)
  1. RC-009 (token storage contradiction)
  2. F-005 (name-pool sync)
  3. F-001 (context-budget.json T3)
  4. F-002 (leaderboard duplicates)
  ↓
PHASE 2 (Agent Skill Gaps — before next coding tasks)
  5. RC-004 (implementation.md loading)
  6. RC-005 (api-integration.md loading)
  7. RC-007 (code-review.md for T4)
  8. RC-006 (code-architecture.md for T1)
  ↓
PHASE 3 (Templates & Config — during next session)
  9. RC-008 (template rule references)
  10. F-007/F-017 (max_pcd_tokens field)
  11. F-006 (populate session history table)
  12. F-016 (recalibrate token baselines)
  ↓
PHASE 4 (Enforcement & Documentation — next cycle)
  13–21. Hook enforcement, documentation, clarity fixes
```

---

## Consolidated Severity Summary

| Severity | Count | Key Issues |
|----------|-------|-----------|
| **P0 — Critical** | 4 | Security contradiction (localStorage), name-pool desync, config mismatch, metrics corruption |
| **P1 — Major** | 10 | Agent skill gaps (4), template gaps (1), enforcement gaps (2), schema gaps (1), metrics gaps (1), calibration (1) |
| **P2 — Minor** | 6 | Documentation gaps, terminology clarity, language context, thin rule coverage, stale config |
| **P3 — Very Minor** | 6+ | Documentation improvements, rule expansion, minor template updates |
| **Total** | 26 | Consolidated findings from A-102 + A-302 |

---

## Verification Checklist

- [x] All findings from A-102 cross-referenced (21 findings, 5 critical)
- [x] All findings from A-302 cross-referenced (16 findings, 5 critical)
- [x] Duplicate findings merged (e.g., name-pool desync confirmed in both)
- [x] Security contradiction (localStorage vs httpOnly) elevated to P0
- [x] Agent skill gaps identified and ordered by tier (T1, T2, T3, T4)
- [x] Template gaps consolidated into single recommendation
- [x] Hook enforcement gaps assessed (5 rules with zero hooks)
- [x] Token estimation recalibration justified with data
- [x] Dependencies between fixes identified (name-pool → agent selection, implementation.md → T3 tasks)
- [x] Effort estimates provided for all high-priority fixes
- [x] Execution order specified (4 phases)

---

**Consolidation Complete** — All findings from A-102 and A-302 merged, prioritized, and ready for Orchestrator action.
