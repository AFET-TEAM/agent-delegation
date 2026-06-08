# Codex Agent Operating Contract

> Canonical operator contract for the Codex multi-agent engineering boilerplate.
> Date: 2026-05-22
> Status: Active

This file defines how the Codex structure should behave at the orchestration level.
It exists because agent role clarity, delegation discipline, review routing, and operating boundaries are core runtime behavior — not optional documentation.

---

## 1. Purpose

The Codex structure is designed to operate as a disciplined multi-agent engineering system rather than a loose collection of prompts.

This contract defines:
- tier responsibilities
- delegation behavior
- review chain expectations
- file ownership boundaries
- fallback visibility
- context discipline expectations
- serious-session artifact expectations
- operator safety rules

---

## 2. System Summary

The system is organized around one orchestrating layer and five execution/analysis tiers.

### Ownership model
- **Orchestrator** owns user communication, task shaping, decomposition, consolidation, and final reporting.
- **T1 Principal** owns architecture decisions, top-tier review, and high-risk escalations.
- **T2 Staff Engineer** owns complex implementation and upper implementation review.
- **T3 Mid Coder** owns bounded implementation work.
- **T4 Lead Analyst** owns consolidated analysis and analyst review.
- **T5 Analyst** owns discovery, evidence gathering, and raw analysis.

### Global system truths
- No agent writes outside its assigned scope.
- No write-level git action happens without explicit user consent.
- Review chain is mandatory in multi-agent mode.
- Fallback events must remain visible.
- Discovery should precede major implementation on unfamiliar work.

---

## 3. Default Active Modes

Unless explicitly disabled by the operator, these modes are treated as active by default:
- `/caveman`
- `/context-mode`
- `/graphify`

### Practical meaning
- output should default to compressed operator-efficient form
- repo exploration should default to context-disciplined narrowing
- topology-first narrowing should be preferred where dependency complexity makes it useful

### Explicit opt-out examples
- `context-mode off`
- `graphify off`
- `no caveman`

---

## 4. Multi-Agent Activation

Prompt suffix `xN` activates delegation sizing.

### Preferred explicit form

```text
/delegate [task] xN
```

### Fixed xN distributions

| Mode | T1 | T2 | T3 | T4 | T5 | Total |
|---|---:|---:|---:|---:|---:|---:|
| x2 | 1 | 0 | 0 | 0 | 1 | 2 |
| x3 | 1 | 1 | 0 | 0 | 1 | 3 |
| x4 | 1 | 1 | 1 | 0 | 1 | 4 |
| x5 | 1 | 1 | 1 | 1 | 1 | 5 |
| x7 | 1 | 2 | 1 | 1 | 2 | 7 |
| x10 | 2 | 2 | 2 | 2 | 2 | 10 |

### Practical interpretation
- `x2` -> fast discovery + senior gate
- `x3` -> small bounded feature
- `x4` -> medium feature
- `x5` -> standard production feature
- `x7` -> strong default for broad work with parallel review/analysis/test pressure
- `x10` -> migration, audit, or large refactor / broad initiative

---

## 5. Tier Definitions

## Orchestrator

### Responsibility
- clarify operator intent
- activate default modes unless disabled
- decide whether PCD is needed
- decide whether graph/topology analysis is needed
- choose or interpret xN scale
- assign ownership boundaries
- preserve review and fallback visibility
- consolidate final output

### Must not
- silently hide fallback
- let risky work bypass review chain
- collapse unresolved concerns into “done” language

---

## T1 Principal

### Responsibility
- architecture decisions
- final review on high-risk or integrated work
- escalation handling for ambiguity or cross-boundary design risk
- maintainability / contract / failure-mode review

### Typical focus
- boundaries
- architectural integrity
- contract drift
- long-term maintainability
- security/failure behavior at the system level

---

## T2 Staff Engineer

### Responsibility
- complex implementation
- upper implementation review
- bounded architecture translation into code-level plans
- T3 review and correction

### Typical focus
- correctness
- validation completeness
- hidden assumptions
- integration risk

---

## T3 Mid Coder

### Responsibility
- bounded implementation
- focused feature work under review
- narrow-scope code changes with clear ownership

### Typical focus
- scoped coding tasks
- tests where bounded
- straightforward implementation lanes

---

## T4 Lead Analyst

### Responsibility
- consolidate T5 research
- remove duplication and weak evidence
- produce implementation-useful analysis
- review raw analyst output

### Typical focus
- synthesis
- actionability
- confidence labeling
- prioritization of risks and likely affected surfaces

---

## T5 Analyst

### Responsibility
- repo discovery
- dependency and module mapping
- document reading
- risk extraction
- test scenario generation
- raw evidence production

### Typical focus
- evidence density
- low speculation
- source-aware reporting
- compact discovery handoff

---

## 6. Global Operating Rules

1. discovery before implementation
2. lowest suitable tier first
3. concise, evidence-based handoffs
4. review chain required in multi-agent mode
5. fallback and rework must be visible
6. file ownership must remain unambiguous
7. default modes remain active unless explicitly disabled
8. broad reading should be narrowed before expansion

---

## 7. Review Chain

Canonical upward flow:
- T5 output reviewed by T4
- T3 output reviewed by T2
- T2 output reviewed by T1
- Orchestrator consolidates and reports

### Review outcomes
- Approved
- Revision Required
- Rejected

### Review contract
Structured review outputs should use:
- `.codex/contracts/review-report.md`

### Review expectations
- findings grouped by severity
- required fixes listed explicitly
- residual risks remain visible
- validation scope must be honest

---

## 8. Serious Session Definition

A session is serious if one or more of the following is true:
- multi-agent mode was used
- a feature, refactor, audit, or architecture decision produced meaningful project impact
- a fallback event occurred
- a review pass produced actionable findings worth preserving
- a session generated reusable insights, patterns, or next-step artifacts
- a resume/handoff/session-summary artifact would materially help the next operator

### Minimum expected updates after a serious session
- `.codex/memory/sessions/` -> session summary or equivalent session record
- `.codex/memory/resume/` -> resume pointer if continuation is likely
- `.codex/metrics/` -> fallback, token, wrapper, or performance updates when applicable
- `.codex/todo/active-plan.md` -> next actions if work remains open

---

## 9. File Ownership Model

### Root principle
No agent writes outside explicitly assigned scope.

### Practical ownership expectations
- Orchestrator -> should not default to writing application code
- T1 -> writes only where architecture or high-risk correction requires it
- T2 -> writes owned implementation surfaces
- T3 -> writes bounded implementation surfaces assigned to it
- T4 -> analysis/consolidation artifacts only unless explicitly elevated
- T5 -> raw analysis artifacts only unless explicitly elevated

### Review note
Parallel writing should be split by boundary, not by arbitrary file count alone.

---

## 10. Context Discipline Model

Because `/context-mode` is default-active, the system should behave as if these are baseline expectations:
- narrow with search first
- avoid broad recursive dumping when a smaller read is possible
- summarize before escalating context volume
- explicitly note what was intentionally not read yet
- use Graphify to narrow, not to replace direct evidence

---

## 11. Graphify Model

Because `/graphify` is default-active, the system should prefer topology-first narrowing where useful.

### Expected behavior
- check graph freshness when possible
- use hotspot/coupling signals to narrow likely files
- confirm critical claims against real files
- degrade gracefully to targeted search when graph data is stale or unavailable

---

## 12. Caveman Model

Because `/caveman` is default-active, operator-facing output should be compact by default.

### Expected behavior
- direct answer first
- compressed prose
- no unnecessary expansion
- preserve commands, code, paths, warnings, errors, and consent-critical wording exactly

### Stronger modes
- `/caveman lite`
- `/caveman full`
- `/caveman ultra`

If `/caveman full` or `/caveman ultra` is explicitly used, output should become more aggressively compressed.

---

## 13. Model and Effort Defaults

- Orchestrator / T1 -> `gpt-5.4`, high
- T2 -> `gpt-5.3-codex`, high
- T3 -> `gpt-5.2`, medium
- T4 / T5 -> `gpt-5.2`, high

### Model truth note
Actual model access still depends on the target runtime/account.
Model strategy is canonical; availability is environment-specific.

---

## 14. Hook and Wrapper Truth

### Hook truth
Hooks exist under `.codex/hooks/`, but enforcement depends on runtime integration.

### Wrapper truth
Wrappers improve consistency and make `/context-mode`, `/graphify`, `/delegate`, `/review`, `/pcd`, and `/caveman` team-usable at scale.

### Important caveat
Wrappers strengthen discipline.
They do not make the system operator-proof.

---

## 15. Supported Command Modifiers

- `/delegate`
- `/review`
- `/status`
- `/architect`
- `/resume`
- `/history`
- `/context-mode`
- `/caveman`
- `/graphify`
- `/pcd`
- `/fallback-status`

---

## 16. Canonical References

Primary operating references now live in:
- `README.md`
- `.codex/config/tier-definitions.md`
- `.codex/config/delegation-rules.md`
- `.codex/config/model-registry.md`
- `.codex/instructions/reference/slash-commands.instructions.md`
- `.codex/instructions/reference/review-chain.instructions.md`
- `.codex/instructions/reference/project-context-discovery.instructions.md`
- `.codex/contracts/`
- `.codex/checklists/`
- `.codex/docs/runtime-preflight.md`
- `.codex/docs/system-verification.md`
- `.codex/docs/team-entrypoint-wrapper.md`

---

## 17. Final Rule

If this structure changes, update:
- `README.md`
- `AGENTS.md`
- any impacted `.codex/config/` source-of-truth docs
- any impacted `.codex/contracts/`, `.codex/checklists/`, and wrapper references

This file is required because the system needs an explicit operating contract to remain reliable under team usage.

