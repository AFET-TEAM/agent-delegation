# A-302: Rules Completeness & Cross-Reference Analysis
**Agent:** Oya Kanat (T3)
**Date:** 2026-04-29

## Executive Summary

The rules system (16 files) is substantively complete for its core domain coverage (React, Spring Boot, full-stack, security, testing). However, significant coverage gaps exist: 6 rule files have no enforcement hook, 4 rule files are never loaded by any agent template, and 3 templates (full-stack, react-spa, spring-boot) do not reference specific rule files at all. The hook registry enforces rules from 5 distinct files but leaves 11 rule files entirely unprotected by automation. Two agent tiers (T4 and T5) each load only one rule file — correct for their scope but notably thin. The highest-severity finding is that `implementation.md`, `code-architecture.md`, and `api-integration.md` have zero automated enforcement, no agent skill loading, and no template reference: they exist as "read-the-manual" guidance with no systemic enforcement path.

---

## Q1: Rules ↔ Hooks Coverage Matrix

Mapping derived from hook-registry.md, each hook file's enforcement declaration, and rule file content.

| Rule File | Enforcing Hook(s) | Coverage Type | Gap? |
|---|---|---|---|
| `analysis.md` | `analysis-scope-guard.sh` (advisory + block on root write) | Partial: directory scope only, not content quality | Yes — report template, confidence level rules have no hook |
| `api-integration.md` | None | No enforcement | **YES — zero hook coverage** |
| `backend-development.md` | `field-injection-check.sh` (§Dependency Injection only) | Partial: DI rule only | Yes — layered architecture, DTO separation, @Transactional unenforceable by hook |
| `backend-security.md` | `sql-injection-check.sh`, `xss-prevention-check.sh`, `path-traversal-check.sh`, `cors-wildcard-check.sh`, `secret-guard.sh` | High: 5 hooks covering 5 major sections | Minor gap: JWT rules, rate limiting, password hashing are unhooked |
| `clean-code.md` | `block-any-type.sh`, `block-comments.sh`, `block-console-log.sh` | Partial: 3 of 8 "Absolute Prohibitions" hooked | Yes — function length, file length, complexity, circular deps, import ordering unhooked |
| `code-architecture.md` | None | No enforcement | **YES — zero hook coverage** |
| `code-review.md` | None (process document) | N/A — process rules, not code rules | Acceptable — review is agent-driven not hook-driven |
| `commit-standards.md` | None | No enforcement | Acceptable — git hook territory; runtime harness hooks are pre-edit not pre-commit |
| `git-safety.md` | `git-safety-check.sh` | High: full section "Consent Requirement" covered | Minor gap: exit code semantics issue noted in A-101/F-105 |
| `implementation.md` | None | No enforcement | **YES — zero hook coverage** |
| `java-quality-tooling.md` | `field-injection-check.sh` (indirectly via backend-development.md) | Minimal: DI prohibition only | Yes — Checkstyle, SpotBugs, JaCoCo thresholds have no hook enforcement |
| `metrics-tracking.md` | `review-tracker.sh`, `self-learning-collector.sh`, `update-leaderboard.sh`, `pattern-lifecycle.sh` | High: all 4 metric hooks documented here | Complete for hooks; lifecycle bugs noted in A-101 |
| `pr-standards.md` | None | No enforcement | Acceptable — PR rules enforced at review/merge stage |
| `react-patterns.md` | `figma-standards-guard.sh` (§Figma MCP Integration; §AntD hardcoded colors/inline styles) | Partial: Figma/style rules hooked | Yes — hooks/state hierarchy/component structure/perf rules unhooked |
| `scss-standards.md` | `figma-standards-guard.sh` (px values, inline styles, hardcoded colors) | Partial: overlaps with Figma hook | Yes — BEM naming, `!important`, empty classes not hooked independently |
| `testing.md` | None | No enforcement | Acceptable — test quality is review-enforced not pre-edit hooked |

### Summary by Coverage Category

| Category | Count | Files |
|---|---|---|
| Strong hook coverage (2+ hooks) | 2 | `backend-security.md`, `metrics-tracking.md` |
| Partial hook coverage (1 hook, partial) | 5 | `analysis.md`, `backend-development.md`, `clean-code.md`, `react-patterns.md`, `scss-standards.md` |
| Zero hook coverage — process rules (acceptable) | 5 | `code-review.md`, `commit-standards.md`, `pr-standards.md`, `testing.md`, `java-quality-tooling.md` |
| Zero hook coverage — code rules (gap) | 4 | `api-integration.md`, `code-architecture.md`, `implementation.md`, `git-safety.md` *(git covered)* |

**Net enforcement gap: `api-integration.md`, `code-architecture.md`, and `implementation.md` have zero automated enforcement despite containing enforceable code rules.**

### Hooks Without Corresponding Rule File Coverage

All 16 hooks map to documented rules. No orphaned hooks found. Hook coverage confirmed against hook-registry.md.

---

## Q2: Rules ↔ Agent Skills Matrix

Source: `_shared-sections.md` (Standard Skills to Load), individual agent templates (analyst.md, lead-analyst.md).

Phase mapping from `_shared-sections.md`:
- **Phase 1 (always):** `clean-code.md`
- **Phase 2 (T1/T2 only):** `task-assignment-matrix.md`
- **Phase 3 (max 1 file):** `react-patterns.md` | `backend-development.md` | `backend-security.md` | `testing.md` | `scss-standards.md` (T2 only)
- **Phase 4 (commit):** `commit-standards.md` + `git-safety.md`

| Rule File | T5 | T4 | T3 | T2 | T1 | Loading Phase | Notes |
|---|---|---|---|---|---|---|---|
| `analysis.md` | — | — | — | — | — | None listed | Not in any agent's skill list |
| `api-integration.md` | — | — | — | — | — | None listed | Not in any agent's skill list |
| `backend-development.md` | — | — | P3 | P3 | P3 | Phase 3 (backend) | Loaded only for backend tasks |
| `backend-security.md` | — | — | P3 | P3 | P3 | Phase 3 (security) | Loaded only for security tasks |
| `clean-code.md` | P1 | P1 | P1 | P1 | P1 | Phase 1 | Loaded by ALL agents always |
| `code-architecture.md` | — | — | — | — | — | None listed | Not in any agent's skill list |
| `code-review.md` | — | — | — | — | — | None listed | Not loaded; reviewers apply it implicitly |
| `commit-standards.md` | — | — | P4 | P4 | P4 | Phase 4 (commit only) | On commit only |
| `git-safety.md` | — | — | P4 | P4 | P4 | Phase 4 (commit only) | On commit only |
| `implementation.md` | — | — | — | — | — | None listed | Not in any agent's skill list |
| `java-quality-tooling.md` | — | — | — | — | — | None listed | Not in any agent's skill list |
| `metrics-tracking.md` | — | — | — | — | — | None listed | Hooks-based; no agent loads it |
| `pr-standards.md` | — | — | — | — | — | None listed | Not in any agent's skill list |
| `react-patterns.md` | — | — | P3 | P3 | P3 | Phase 3 (frontend) | Loaded only for frontend tasks |
| `scss-standards.md` | — | — | — | P3 | P3 | Phase 3 (T2 SCSS only) | T3 cannot load scss per _shared-sections.md |
| `testing.md` | — | — | P3 | P3 | P3 | Phase 3 (test tasks) | Loaded only for test tasks |

### Rule Files Not Loaded by Any Agent (Never in Skills)

Four rule files are never loaded as agent skills under any phase:

1. **`analysis.md`** — Defines write boundaries and report templates for T5/T4. These agents load only `clean-code.md`; `analysis.md` itself is not listed. T4/T5 implicitly follow its templates but they are not explicitly loaded.
2. **`api-integration.md`** — Contains API contract, axios patterns, retry logic. No agent loads it. T3 and T2 handle API work without this rule being in scope.
3. **`code-architecture.md`** — Contains SOLID application guide, hexagonal architecture patterns, ADR format. T1 Principal, who makes architecture decisions, does not explicitly load this file.
4. **`implementation.md`** — Contains TypeScript strict rules, error class hierarchy, factory/repository patterns, test AAA pattern. Not loaded by T3 despite T3 being the primary implementation agent.
5. **`java-quality-tooling.md`** — Checkstyle/SpotBugs/JaCoCo standards. No agent explicitly loads this for Java tasks.
6. **`pr-standards.md`** — PR size limits, branch naming, review guidelines. Not loaded by any agent.

### Skill Loading Tier Appropriateness Assessment

| Tier | Rules Loaded | Assessment |
|---|---|---|
| T5 (Analyst) | 1 rule (clean-code.md always; 1 task-specific max) | Appropriate: analysis only, code rules not needed |
| T4 (Lead Analyst) | 1 rule (clean-code.md only) | Thin: consolidating analysis of code quality but never loads code-review.md |
| T3 (MidCoder) | 1–2 rules (clean-code.md + 1 domain) | Appropriate: focused; missing implementation.md and api-integration.md |
| T2 (Staff Engineer) | 2–3 rules (clean-code.md + matrix + 1 domain) | Appropriate for role; missing code-architecture.md for complex tasks |
| T1 (Principal) | 2–3 rules (clean-code.md + matrix + 1 domain) | Gap: code-architecture.md never loaded despite architecture decisions being T1's core |

**Critical skill gap:** T4 Lead Analyst never loads `code-review.md` despite its primary job being quality review of T5 analysis outputs. T1 Principal never loads `code-architecture.md` despite architecture being its primary function.

---

## Q3: Rules ↔ Templates Cross-Reference

### Templates Examined
- `.claude/templates/full-stack.md`
- `.claude/templates/react-spa.md`
- `.claude/templates/spring-boot.md`

| Template | Rule Files Referenced | Missing References | Dead References |
|---|---|---|---|
| `full-stack.md` | None explicitly | All rule files | None |
| `react-spa.md` | None explicitly | All rule files | None |
| `spring-boot.md` | None explicitly | All rule files | None |

**Critical Finding:** None of the three project templates reference any rule file explicitly. Templates define tech stacks, project structures, and key patterns, but contain no "apply these rules" guidance. A developer bootstrapping from a template has no pointer to the relevant rule files (`react-patterns.md`, `backend-development.md`, `backend-security.md`, etc.).

### Template-Specific Pattern Alignment

| Template | Key Pattern | Corresponding Rule File | Rule File Exists? |
|---|---|---|---|
| `react-spa.md` | "AAA pattern, 80% overall coverage" | `testing.md` | Yes — but not referenced |
| `react-spa.md` | "useForm + yupResolver, Controller for Ant Design" | `react-patterns.md` | Yes — but not referenced |
| `react-spa.md` | "ApiResponse<T> contract" | `api-integration.md` | Yes — but not referenced |
| `spring-boot.md` | "Constructor injection only (no @Autowired on fields)" | `backend-development.md` | Yes — but not referenced |
| `spring-boot.md` | "Line coverage 80%, branch 70%" | `java-quality-tooling.md` | Yes — but not referenced |
| `full-stack.md` | "camelCase fields, pagination, Bearer JWT" | `api-integration.md` | Yes — but not referenced |
| `full-stack.md` | "1-based frontend, 0-based backend" | `api-integration.md` | Yes — but not referenced |

All patterns present in templates have corresponding rule files that exist. There are zero dead references (no template references non-existent files). The gap is the complete absence of forward-links from templates to rules.

---

## Q4: Rule File Health Assessment

| Rule File | Has Purpose Statement | Has Clear Rules | Has Code Examples | Has Enforcement Notes | Quality Rating | Issues |
|---|---|---|---|---|---|---|
| `analysis.md` | Yes (§Write Permission Boundaries) | Yes | Yes (report template) | Yes (mentions hook) | Good | No examples for "Analysis Types" application |
| `api-integration.md` | Implicit (contract doc) | Yes | Yes (TypeScript interfaces) | No | Good | No enforcement notes; no frontmatter |
| `backend-development.md` | Yes (frontmatter paths) | Yes | Yes (Java examples) | Partial (§Enforcement Hooks missing) | Good | Missing explicit enforcement notes section |
| `backend-security.md` | Yes (frontmatter paths) | Yes | Yes (Java examples) | Yes (§Enforcement Hooks table) | Excellent | Most complete rule file in the set |
| `clean-code.md` | Yes | Yes | Yes | Yes (mentions hooks) | Good | No frontmatter paths; hook coverage limited |
| `code-architecture.md` | Yes (§Layered Architecture) | Yes | Yes (structure diagrams) | No | Good | No enforcement notes; ADR format section incomplete |
| `code-review.md` | Yes | Yes | Yes (example feedback) | Yes (process-level) | Good | Review tier rules incomplete for T4→T5 chain |
| `commit-standards.md` | Yes | Yes | Yes (examples) | No | Good | No tool enforcement; relies on review |
| `git-safety.md` | Yes | Yes | No | Yes (hook named explicitly) | Good | No code examples; short but complete for scope |
| `implementation.md` | Yes | Yes | Yes (extensive TypeScript) | No | Good | No frontmatter paths; no enforcement notes |
| `java-quality-tooling.md` | Yes (frontmatter paths) | Yes | Yes (XML snippets) | No | Good | No direct enforcement link to hooks |
| `metrics-tracking.md` | Yes | Yes | No | Yes (4 hooks named) | Good | Not a code rule file; purpose is documentation |
| `pr-standards.md` | Yes | Yes | No | No | Good | Process document; acceptable without enforcement |
| `react-patterns.md` | Yes (frontmatter paths) | Yes | Yes (extensive TypeScript) | Partial ([HOOK]/[REVIEW] inline tags) | Excellent | Longest rule file (422 lines); dual-version support is valuable |
| `scss-standards.md` | Implicit | Yes | Yes (SCSS examples) | No | Fair | Shortest rule file (55 lines); thin on anti-pattern coverage |
| `testing.md` | Yes (frontmatter paths) | Yes | Yes | No | Good | No enforcement notes; testing is review-based |

### Overly Thin Rule Files

1. **`scss-standards.md`** (55 lines) — Covers BEM, units, colors, anti-patterns but lacks:
   - Examples of correct vs. incorrect BEM class names
   - Media query breakpoint standards
   - Module composition patterns (when to create new modules)
   - `classNames()` complex usage examples

2. **`git-safety.md`** (37 lines) — Intentionally concise but lacks:
   - Examples of how consent is recorded (chat message format)
   - Interaction with the automated review chain

### Contradictions Between Rule Files

| Contradiction | File A | File B | Detail |
|---|---|---|---|
| Function parameter limit | `clean-code.md` (max 3) | `java-quality-tooling.md` (max 7 via Checkstyle) | Java allows 7 params; TypeScript allows 3. Different languages — NOT a true contradiction but could confuse T3 agents working full-stack. Needs explicit callout. |
| Method length | `clean-code.md` (20 lines max) | `java-quality-tooling.md` (80 lines via Checkstyle) | Same issue as above: TypeScript vs Java limits. Conflicting limits for cross-stack agents. |
| File length | `clean-code.md` (250 lines, 300 for React) | `java-quality-tooling.md` (500 lines via Checkstyle) | TypeScript files limited at 250; Java at 500. Multi-stack agents could apply wrong limit. |
| Pagination | `api-integration.md` (1-based frontend) | `full-stack.md` template (1-based frontend, 0-based backend) | Consistent — full-stack.md correctly repeats the api-integration.md rule. No contradiction. |
| Authentication token storage | `api-integration.md` ("Auth interceptor: Attach Bearer from localStorage") | `backend-security.md` ("Access token: Memory (frontend) or Authorization header") | **REAL CONTRADICTION:** api-integration.md instructs storing access tokens in localStorage; backend-security.md says Memory (frontend). localStorage is vulnerable to XSS; memory storage is the secure recommendation. |

---

## Q5: Missing Rule Files

Based on hook coverage, template content, agent skills, and project scope:

| Missing Rule | Evidence of Need | Priority |
|---|---|---|
| **`typescript-standards.md`** | `implementation.md` has TypeScript rules mixed with patterns; `react-patterns.md` has TypeScript section. Separate pure TypeScript standards file needed for backend TypeScript (Node.js). | High |
| **`state-management.md`** | `react-patterns.md` §State Management Hierarchy covers Zustand + TanStack Query but these are buried in a 422-line file. A dedicated file would improve agent discoverability. | Medium |
| **`accessibility.md`** | `react-patterns.md` §Accessibility has 7 rules ([REVIEW] tagged) but no dedicated enforcement. WCAG 2.1 compliance deserves a standalone file with detailed checklist. | Medium |
| **`error-handling.md`** | Error handling appears in `clean-code.md` (brief), `implementation.md` (domain error classes), `backend-development.md` (GlobalExceptionHandler). A unified error-handling rule file covering both frontend and backend would reduce redundancy. | Medium |
| **`logging-standards.md`** | `backend-development.md` §Structured Logging mentions Winston/Pino, but no dedicated logging rules exist. Console statement blocking (hook) has no positive guidance on what to use instead. | Medium |
| **`environment-configuration.md`** | Templates reference `.env.example` and environment-specific config but no rule file governs environment variable naming, secret management, or multi-environment setup. | Medium |
| **`graphql-standards.md`** | `code-architecture.md` mentions GraphQL adapters in Hexagonal Architecture. No rule file exists for GraphQL-specific patterns. | Low (if project uses GraphQL) |
| **`websocket-standards.md`** | No coverage anywhere in rules or templates. | Low (if project uses WebSockets) |
| **`performance-standards.md`** | `react-patterns.md` has performance section; `task-assignment-matrix.md` lists "Performance profiling" as T5 task. No dedicated performance rules file. | Low |

---

## Q6: Templates Completeness

### `full-stack.md`

**Score: 6/10**

| Aspect | Present? | Notes |
|---|---|---|
| Tech stack definition | Yes (diagram) | Lists React, Spring Boot, PostgreSQL/Redis |
| API contract | Yes | ApiResponse<T>, HTTP methods, camelCase |
| Communication standards | Yes | Table format |
| Project structure | No | Not included — deferred to individual templates |
| Rule file references | No | Zero explicit references |
| Quality gates | No | Not mentioned |
| Environment configuration | Partial | Dev/staging/prod URLs listed |
| Auth standards | Partial | Bearer JWT mentioned; no refresh token detail |
| Development workflow | Yes | 4-step process |

**Gaps:** No cross-references to `api-integration.md`, `backend-development.md`, `backend-security.md`. No project structure. No quality gates.

### `react-spa.md`

**Score: 7/10**

| Aspect | Present? | Notes |
|---|---|---|
| Tech stack definition | Yes | Complete table with versions |
| Project structure | Yes | Detailed src/ tree |
| Configuration files | Yes | vite, tsconfig, vitest, .env |
| Key patterns | Yes | 7 concise pattern references |
| Module Federation | Yes | Read-only shell reference |
| Rule file references | No | Zero explicit references |
| Accessibility requirements | No | Not mentioned |
| Error handling patterns | No | Not mentioned |
| CI/CD requirements | No | Not mentioned |

**Gaps:** No cross-references to `react-patterns.md`, `testing.md`, `scss-standards.md`. No accessibility or error handling guidance.

### `spring-boot.md`

**Score: 7/10**

| Aspect | Present? | Notes |
|---|---|---|
| Tech stack definition | Yes | Complete table with versions |
| Project structure | Yes | Detailed Maven tree |
| Key patterns | Yes | 7 critical patterns with brief descriptions |
| Quality gates | Yes | Table with thresholds (80% line, 70% branch) |
| Maven profiles | Yes | default, quality-checks, docker |
| Rule file references | No | Zero explicit references |
| Security configuration | No | JWT mentioned in patterns but no security setup |
| Database migration | No | Flyway not mentioned |
| OpenAPI config | No | Tool listed but no setup guidance |

**Gaps:** No cross-references to `backend-development.md`, `backend-security.md`, `java-quality-tooling.md`. No Flyway migration setup. No security filter chain setup.

### Template Assessment Summary

All three templates are structurally sound as quick-start guides but function as isolated documents. None reference the rule files that govern the code they describe. Adding a "Rules in Effect" section to each template would close this gap with minimal effort.

---

## Q7: CLAUDE.md ↔ Rules Alignment

### CLAUDE.md Rule File References

| CLAUDE.md Reference | Referenced File | File Exists? | Notes |
|---|---|---|---|
| "15 standard files covering clean code, React, testing, API, backend, security, PR" | `.claude/rules/` (all files) | Yes (16 files, including analysis.md) | Count discrepancy: CLAUDE.md says 15, actual count is 16 |
| "Review chain applies `.claude/rules/code-review.md` checklist" | `code-review.md` | Yes | Correct |
| `git-safety.md` §Consent Requirement | `git-safety.md` | Yes | Correct |
| `figma-standards-guard.sh` enforces `react-patterns.md §Figma Standards` | `react-patterns.md` | Yes | Correct |
| Hook registry `.claude/config/hook-registry.md` | `hook-registry.md` | Yes | Correct |
| Task assignment matrix `.claude/config/task-assignment-matrix.md` | `task-assignment-matrix.md` | Yes | Correct |
| `.claude/rules/learned-*.md` (pattern promotion target) | `learned-*.md` files | Does not exist yet | Expected future state; acceptable |

### Discrepancy: Rule Count

CLAUDE.md states "15 standard files" in §Enforcement Layers. Actual count is **16 files** (including `analysis.md`). `analysis.md` may have been added after CLAUDE.md was last updated, or it may be considered a system file rather than a "standard" rule.

### CLAUDE.md References to Non-Existent Files (None Found)

All explicit file references in CLAUDE.md (`hook-registry.md`, `code-review.md`, `git-safety.md`, `react-patterns.md`, agent templates, config files) resolve to existing files.

### Rules Mentioned in CLAUDE.md Without Standalone Files

1. **Figma MCP Integration** — CLAUDE.md §Figma MCP Integration has 6 rules. The `figma-standards-guard.sh` hook enforces them. `react-patterns.md` §Figma MCP Integration Rules covers the same content. No standalone `figma-standards.md` file. This is acceptable — covered in react-patterns.md.

2. **"Clean code, React, testing, API, backend, security, PR"** in §Enforcement Layers — all have corresponding files. "API" maps to `api-integration.md` (exists). Alignment is correct.

---

## Missing/Thin Coverage Findings

| ID | Category | Finding | Severity | Recommendation |
|---|---|---|---|---|
| RC-001 | Hook Coverage | `api-integration.md` has zero hook enforcement despite containing enforceable rules (CORS config, auth header, localStorage token storage) | Major | Add advisory hook or promote applicable rules to existing hooks (e.g., api-integration-check.sh) |
| RC-002 | Hook Coverage | `implementation.md` has zero hook enforcement despite containing TypeScript rules (strict mode, const/let, template literals) and prohibition of `var`, loose equality | Major | Merge applicable prohibitions into `block-any-type.sh` or create `implementation-check.sh` |
| RC-003 | Hook Coverage | `code-architecture.md` has zero hook enforcement | Minor | Architectural rules are largely review-enforced; add note to code-review.md checklist referencing this file |
| RC-004 | Agent Skills | `implementation.md` never loaded by T3 MidCoder — the primary implementer — despite containing the core TypeScript/pattern standards T3 should follow | Critical | Add `implementation.md` to Phase 3 of _shared-sections.md for TypeScript implementation tasks |
| RC-005 | Agent Skills | `api-integration.md` never loaded by any coding agent despite T3 implementing API endpoints and T2 implementing services | Critical | Add `api-integration.md` to Phase 3 options in _shared-sections.md for API tasks |
| RC-006 | Agent Skills | `code-architecture.md` never loaded by T1 Principal despite architecture decisions being T1's primary function | Major | Add `code-architecture.md` to Phase 2 (PCD) or Phase 3 for T1 in _shared-sections.md |
| RC-007 | Agent Skills | T4 Lead Analyst never loads `code-review.md` despite performing quality review as its primary function | Major | Add `code-review.md` to T4's Skills to Load section in lead-analyst.md |
| RC-008 | Templates | None of the 3 project templates reference any rule file; developers bootstrapping from templates have no rule discovery path | Major | Add "Rules in Effect" section to each template listing 3-5 relevant rule files |
| RC-009 | Contradictions | `api-integration.md` instructs storing access tokens in localStorage; `backend-security.md` recommends memory storage. localStorage is XSS-vulnerable. | Critical | Align both files to `backend-security.md`'s recommendation: memory storage for access tokens, httpOnly cookie for refresh tokens |
| RC-010 | CLAUDE.md Accuracy | CLAUDE.md says "15 standard files" but 16 rule files exist | Minor | Update CLAUDE.md §Enforcement Layers count from 15 to 16 |
| RC-011 | Missing Rules | No dedicated logging standards file; `block-console-log.sh` prohibits console.log but provides no guidance on what structured logging to use | Major | Add `logging-standards.md` or expand `backend-development.md` §Structured Logging to cover frontend logging |
| RC-012 | Missing Rules | No `typescript-standards.md` — TypeScript rules are split across `implementation.md`, `react-patterns.md`, and `clean-code.md` | Minor | Consolidate TypeScript rules into dedicated file or add cross-references between files |
| RC-013 | Rule Contradiction | Function/method length limits differ by language: clean-code.md says 20 lines (TypeScript) vs java-quality-tooling.md says 80 lines (Java). Multi-stack agents may apply wrong limit | Minor | Add explicit callout in both files: "This limit applies to [TypeScript/Java] only" |
| RC-014 | Rule Quality | `scss-standards.md` at 55 lines is the thinnest rule file; missing media query breakpoints, module composition patterns, complex BEM examples | Minor | Expand with 20-30 lines covering breakpoints and module composition |
| RC-015 | Template Gap | `spring-boot.md` does not mention Flyway migrations despite `backend-development.md` requiring "Database migrations versioned and tracked (Flyway for Java)" | Minor | Add Flyway migration setup to spring-boot.md §Key Patterns |

---

## Templates Assessment

### `full-stack.md` — Score: 6/10
- Strengths: API contract definition, HTTP method table, environment config.
- Gaps: No rule references, no project structure, no quality gates, auth section incomplete.
- Recommendation: Add "Rules in Effect" section: `api-integration.md`, `backend-development.md`, `backend-security.md`. Add link to react-spa.md and spring-boot.md for stack-specific detail.

### `react-spa.md` — Score: 7/10
- Strengths: Complete tech stack, project structure, key patterns summary, MFE guidance.
- Gaps: No rule references, no accessibility requirements, no error handling, no CI/CD.
- Recommendation: Add "Rules in Effect" section: `react-patterns.md`, `testing.md`, `scss-standards.md`, `api-integration.md`. Add accessibility checklist pointer.

### `spring-boot.md` — Score: 7/10
- Strengths: Complete tech stack, project structure, key patterns, quality gates table, Maven profiles.
- Gaps: No rule references, no Flyway migration setup, no security filter chain, no OpenAPI config example.
- Recommendation: Add "Rules in Effect" section: `backend-development.md`, `backend-security.md`, `java-quality-tooling.md`, `testing.md`. Add Flyway and security filter chain sections.

---

## Findings Table

| ID | File | Category | Severity | Finding | Confidence | Recommendation |
|---|---|---|---|---|---|---|
| RC-001 | `api-integration.md` | Hook Coverage | Major | Zero hook enforcement for enforceable code rules | High | Create advisory hook or extend existing hooks |
| RC-002 | `implementation.md` | Hook Coverage | Major | Zero hook enforcement despite containing TypeScript prohibitions | High | Merge `var` and loose equality checks into block hooks |
| RC-003 | `code-architecture.md` | Hook Coverage | Minor | Zero hook enforcement (architecture is review-driven) | High | Add explicit reference in code-review.md checklist |
| RC-004 | `_shared-sections.md` | Agent Skills | Critical | `implementation.md` never loaded by T3 despite being the core TypeScript standard for T3's work | High | Add to Phase 3 options for TypeScript tasks |
| RC-005 | `_shared-sections.md` | Agent Skills | Critical | `api-integration.md` never loaded by coding agents implementing API endpoints | High | Add to Phase 3 options for API tasks |
| RC-006 | `_shared-sections.md` | Agent Skills | Major | `code-architecture.md` never loaded by T1 Principal | High | Add to Phase 2 (PCD) for T1 |
| RC-007 | `lead-analyst.md` | Agent Skills | Major | T4 Lead Analyst never loads `code-review.md` | High | Add to T4 Skills to Load |
| RC-008 | All 3 templates | Templates | Major | No rule file references in any project template | High | Add "Rules in Effect" sections |
| RC-009 | `api-integration.md` vs `backend-security.md` | Contradiction | Critical | localStorage vs memory storage for access tokens: direct security contradiction | High | Align to memory storage (backend-security.md is authoritative) |
| RC-010 | `CLAUDE.md` | Accuracy | Minor | Rule file count stated as 15; actual is 16 | High | Update count |
| RC-011 | System-wide | Missing Rule | Major | No logging standards for frontend; block-console-log.sh has no positive guidance | High | Add logging standards or expand backend-development.md |
| RC-012 | System-wide | Missing Rule | Minor | TypeScript standards split across 3 files | Medium | Consolidate or add cross-references |
| RC-013 | `clean-code.md`, `java-quality-tooling.md` | Contradiction | Minor | Function/method length limits differ (20 lines vs 80 lines) without language context | High | Add language qualification to both files |
| RC-014 | `scss-standards.md` | Rule Quality | Minor | Thinnest rule file (55 lines); missing breakpoints, module composition | High | Expand with 20-30 lines |
| RC-015 | `spring-boot.md` | Template Gap | Minor | Flyway migration not mentioned despite backend-development.md requiring it | High | Add to spring-boot.md §Key Patterns |
| RC-016 | `code-review.md` | Rule Quality | Minor | T4→T5 review chain rules are absent; only T2→T3 and T1→T2 review rules specified | Medium | Add §Lead Analyst to Analyst Review section |

---

## Prior Analysis Cross-Reference

This analysis builds on findings from A-002 (2026-04-22) and A-101/A-102 (2026-04-29):

- A-002/Finding 3 ("Hook References Inconsistent") confirmed here as RC-003: only 2 rule files explicitly reference hooks. Recommendation: Annotate rule file rules with `[HOOK]` or `[REVIEW]` tags (as react-patterns.md already does) across all files.
- A-101/F-110 ("px safe values assumption") connects to RC-014 (scss-standards.md thin): the 2px border exception should be documented in scss-standards.md, not left as undocumented hook behavior.
- A-102/F-016 (token estimation underestimate) indirectly supported by RC-004/RC-005: agents not loading relevant rule files may produce lower-quality work requiring more revisions, driving up actual token usage.

---

**Analysis Complete** — Ready for T4 Lead Analyst consolidation.
