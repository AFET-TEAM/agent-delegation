---
doc_id: README
lang: en
source_of_truth: true
version: 4.2.0
last_updated: 2026-05-22
sync_group: root-docs
translation_of: null
sync_status: canonical
---

# Codex Multi-Agent Engineering Boilerplate

> v4.2.0 — minimal-root, Codex-first, enterprise-grade multi-agent engineering handbook

This repository is intentionally optimized for a **single-document root surface**. The root keeps only this `README.md` as the canonical operator document. All other operational assets live under `.codex/`.

This is deliberate.
It reduces:
- drift
- duplicated documentation
- maintenance overhead
- noisy root-level onboarding

It improves:
- source-of-truth clarity
- operator consistency
- long-term package maintainability

---


## Handbook Positioning

This README is intentionally written as the **single root handbook** for the package.

It is meant to serve four audiences:
- individual contributors
- team leads
- reviewers
- rollout owners

Its purpose is to explain:
- what the system is
- how it behaves by default
- where the real operational assets live
- how the team should use it safely and consistently

---

## Executive Summary

This package is a structured operating system for serious engineering work with:
- multi-agent delegation
- tiered review
- project context discovery
- context-discipline by default
- topology-first narrowing by default
- compressed output by default
- hook-assisted safety
- contracts, checklists, memory, and metrics

The current operating baseline is:
- `/caveman` -> default-on
- `/context-mode` -> default-on
- `/graphify` -> default-on

And the current scaling control is:
- `xN` -> agent scale selector

So a short prompt like:

```text
Auth feature x10
```

should be interpreted operationally closer to:

```text
/context-mode /graphify /caveman Auth feature x10
```

unless one of those modes is explicitly disabled.

---

## Deep Analysis Result

After multiple review/fix cycles, the package is strongest in these areas:

### Strong parts
- clean separation between root entrypoint and internal operating system
- explicit multi-agent tier model
- explicit review chain
- explicit PCD model
- explicit hook registry and runtime caveats
- wrapper-based team entrypoints
- usage logging and reporting for team wrapper behavior
- restricted-runtime resilience for advisory persistence hooks

### Remaining truth-based caveats
These are not defects; they are environment-dependent realities:
- model availability depends on the target runtime/account
- hook enforcement strength depends on wrapper/CI adoption
- Graphify quality depends on graph artifact freshness/availability
- wrappers improve discipline, but cannot replace operator misuse-proofing completely

### Design conclusion
The highest-value improvement was simplifying the root to one canonical README and moving everything else into `.codex/`.
That makes the structure more stable and less drift-prone.

---

## Root Policy

At the root level, keep only:
- `README.md`

Everything else belongs in `.codex/`.

This rule should remain stable unless there is a strong reason to reintroduce a broader public root surface.

---

## Performance Evaluation Table

### Scenario: medium production task (discovery + implementation + review)

| Metric | Without This System | With Codex Multi-Agent Structure (`x5`/`x10`) | Practical Effect |
|--------|---------------------|-----------------------------------------------|------------------|
| **Task decomposition** | single-threaded reasoning | tiered role-based split | clearer ownership and less role confusion |
| **Context usage** | one expanding context | narrowed per-stage/per-role context | lower overload risk |
| **Review quality** | self-review or shallow pass | T5→T4 and T3→T2→T1 chain | stronger defect detection |
| **Discovery quality** | ad hoc file reading | PCD + Context Mode + Graphify narrowing | less brute-force scanning |
| **Runtime safety** | easy to drift or overread | hooks, wrappers, and contracts constrain flow | safer default behavior |
| **Fallback visibility** | often implicit | explicit fallback expectations | better auditability |
| **Operational memory** | weak persistence | memory, metrics, and patterns | stronger continuity |
| **Scalability** | weak on broad tasks | `xN` scaling and wave-based handling | better serious-task throughput |
| **Maintenance burden** | lower at start, higher later | higher setup, lower long-term drift | better long-term structure |

### Practical Efficiency Table

| Area | Baseline Single-Agent Style | Codex Multi-Agent Style | Net Effect |
|------|-----------------------------|--------------------------|-----------|
| **Token efficiency** | broad/noisy context growth | query-first and tier-scoped use | better large-task efficiency |
| **Reading behavior** | too many files too early | disciplined narrowing | less waste |
| **Parallelism** | limited | xN-driven decomposition | faster serious-task movement |
| **Governance overhead** | low | moderate | worthwhile on medium/high-risk work |
| **Best fit** | tiny or throwaway work | serious product engineering | stronger quality/traceability |

### Interpretation
- tiny task -> simpler systems may feel faster
- medium/large task -> this structure is safer and more governable
- high-risk work -> the review chain and context discipline become especially valuable

---

## Default Active Modes

Unless explicitly turned off, these are treated as active by default:
- `/caveman`
- `/context-mode`
- `/graphify`

### Meaning
- output should be compressed by default
- repo exploration should be context-disciplined by default
- topology-first narrowing should be preferred where useful

### Turn-off model
If you want one disabled, say so explicitly.
Examples:
- `context-mode off`
- `graphify off`
- `no caveman`

---

## Delegation Model

### Canonical rule
- `xN` selects delegation scale
- `/delegate` explicitly requests multi-agent decomposition
- preferred explicit form:

```text
/delegate [task] xN
```

### Fixed modes
- `x2` -> quick discovery + senior gate
- `x3` -> small bounded feature
- `x4` -> medium feature
- `x5` -> standard production feature
- `x7` -> parallel feature/test/analysis/review
- `x10` -> migration, audit, or broad refactor

### Runtime execution truth
`/delegate` mode now has a local orchestration runtime behind the wrapper. When invoked through `./bin/team delegate "<task> xN"`, the system can:
- generate per-tier task packets
- launch real parallel local worker subprocesses
- emit per-agent task reports
- emit review-chain artifacts
- persist run outputs under `.codex/runtime/runs/<timestamp>/`

This is a **local parallel worker runtime**. It is not a guarantee of remote hosted LLM sub-agent availability in every environment.

### Current runtime feature set
The local delegate runtime currently supports all of the following in one flow:
- per-tier packet generation
- wave-based parallel subprocess execution
- review-chain artifact generation
- safe file-writing into a sandboxed `workspace-mirror/`
- revision-loop retries up to 2 rounds
- fallback / escalation visibility when revision loops are exhausted
- automatic metrics updates
- automatic serious-session memory/resume/todo updates
- approval-ready promotion artifacts for mirror changes
- approval-based live apply via `./bin/team-apply`

### Runtime artifact tree
Each delegate run writes artifacts under:

```text
.codex/runtime/runs/<run_id>/
  manifest.json
  final-summary.md
  promotion-summary.md
  promotion-candidates.json
  apply-summary.md
  packets/
  agents/
  reviews/
  logs/
  diffs/
  apply-logs/
  workspace-mirror/
```


### Practical default model
If you give only:

```text
Task x10
```

then the expected interpretation is effectively:
- default modes active
- x10 scale active
- analysis/review/decomposition should be assumed where appropriate

---

## Tier Model

- Orchestrator / T1 Principal -> `gpt-5.4` (high)
- T2 Staff Engineer -> `gpt-5.3-codex` (high)
- T3 Mid Coder -> `gpt-5.2` (medium)
- T4 Lead Analyst -> `gpt-5.2` (high)
- T5 Analyst -> `gpt-5.2` (high)

### Role intent
- Orchestrator -> communication, routing, consolidation
- T1 -> architecture and final review
- T2 -> complex implementation and upper implementation review
- T3 -> bounded implementation
- T4/T5 -> discovery, evidence, analysis, consolidation

---

## Review Chain

Canonical upward flow:
- T5 output -> reviewed by T4
- T3 output -> reviewed by T2
- T2 output -> reviewed by T1
- Orchestrator -> consolidates and reports

Structured review output contract:
- `.codex/contracts/review-report.md`

This remains one of the most important quality mechanisms in the package.

---

## Project Context Discovery (PCD)

Use PCD on unfamiliar or large work.

Expected PCD output:
- project goal
- module map
- constraints and conventions
- likely affected files
- recommended next reads

Primary references:
- `.codex/instructions/reference/project-context-discovery.instructions.md`
- `.codex/docs/project-context-discovery.md`

---

## Context Mode

Use `/context-mode` when:
- repo is large
- task surface is wide
- over-reading is likely
- summary-first exploration is needed

Default behavior now assumes this is active unless disabled.

Core behavior:
- narrow with search first
- read only relevant sections
- summarize findings compactly
- explicitly note what was intentionally not read yet

Primary references:
- `.codex/skills/context-mode/SKILL.md`
- `.codex/rules/context-mode-usage.md`
- `.codex/docs/context-mode-install.md`
- `.codex/docs/context-mode-wrapper.md`
- `.codex/wrappers/context-mode-wrapper.sh`

---

## Graphify

Use `/graphify` when:
- dependency surface is large
- hotspot detection matters
- topology-first narrowing is useful

Default behavior now assumes this is active unless disabled.

Core behavior:
- check graph freshness
- query hotspots/boundaries
- read narrowed files
- report EXTRACTED / INFERRED / AMBIGUOUS

Important:
- Graphify guides reading
- it does **not** replace direct evidence from real files
- if graph artifacts are missing/stale, degrade to targeted search

Primary references:
- `.codex/skills/graphify/SKILL.md`
- `.codex/rules/graphify-usage.md`
- `.codex/docs/graphify.md`
- `.codex/docs/graphify-install.md`
- `.codex/wrappers/context-graphify-wrapper.sh`

---

## Caveman

Use `/caveman` to reduce prose verbosity without changing meaning.

Default behavior now assumes compressed output is active unless disabled.

Modes:
- `/caveman`
- `/caveman lite`
- `/caveman full`
- `/caveman ultra`

Preservation rules:
- never compress code
- never compress commands, paths, errors, or warnings
- never compress irreversible or consent-critical language

Primary references:
- `.codex/skills/caveman/SKILL.md`
- `.codex/rules/caveman.md`
- `.codex/docs/caveman.md`

---

## Hooks

Hook scripts live under `.codex/hooks/`.

Important runtime truth:
- hooks exist
- enforcement depends on wrapper/CI/runtime wiring
- advisory persistence hooks degrade safely in restricted environments

Examples:
- `git-safety-check.sh` -> blocks write-level git actions without explicit consent
- `context-mode-guard.sh` -> warns/blocks risky broad-output patterns
- `graphify-audit.sh` -> warns about stale graph artifacts
- `review-tracker.sh` -> tracks churn when persistence is available
- `self-learning-collector.sh` -> records rework patterns when persistence is available

Primary references:
- `.codex/config/hook-registry.md`
- `.codex/docs/runtime-preflight.md`
- `.codex/docs/system-verification.md`
- `.codex/docs/wrapper-conventions.md`

---

## Real Delegate Runtime Walkthrough

This section describes the **actual current runtime behavior** behind `delegate` mode.

### High-level lifecycle
When you run:

```bash
./bin/team delegate "update README.md and AGENTS.md x10"
```

the system performs these stages:

1. wrapper validates mode and `xN` shape
2. delegation plan is rendered
3. runtime parses `xN` and builds tier packets
4. packets are executed in waves
5. each worker emits a task report
6. reviewer tiers emit review reports
7. safe writes go to `workspace-mirror/` instead of the live repo
8. unified diffs are generated for promotion candidates
9. metrics/session/resume/todo files are auto-updated
10. final run summary is written
11. optional human-approved apply can promote selected mirror files back to live targets

### Wave model
The runtime currently uses this effective sequence:
- `wave1-discovery` -> T5
- `wave2-consolidation` -> T4
- `wave3-implementation` -> T3
- `wave4-staff-review` -> T2
- `wave5-principal-review` -> T1
- `wave6-consolidation` -> orchestrator

### xN distribution examples

#### `x3`
- T5: 1
- T4: 0
- T3: 0
- T2: 1
- T1: 1

Example:
```bash
./bin/team delegate "auth feature x3"
```

#### `x5`
- T5: 1
- T4: 1
- T3: 1
- T2: 1
- T1: 1

Example:
```bash
./bin/team delegate "notification refactor x5"
```

#### `x10`
- T5: 2
- T4: 2
- T3: 2
- T2: 2
- T1: 2

Example:
```bash
./bin/team delegate "platform migration audit x10"
```

Expected use:
- migration
- broad refactor
- heavy audit
- high review pressure

### Example: successful delegate run
```bash
./bin/team delegate "update README.md and AGENTS.md x5"
```

### Example: revision-loop scenario
```bash
./bin/team delegate "force-revision runtime write update README.md x5"
```

### Safe file-writing model
Workers do **not** directly modify the live repository during runtime execution.
They write to:

```text
.codex/runtime/runs/<run_id>/workspace-mirror/
```

Write policy decisions are logged under:
- `.codex/runtime/runs/<run_id>/logs/write-policy-T*.json`

### Approval-ready promotion model
Mirror changes are not auto-applied to live repo targets.
The runtime emits:
- `promotion-summary.md`
- `promotion-candidates.json`
- per-file unified diffs under `diffs/`

Example approval summary entry:

```text
- target: README.md | mirror: workspace-mirror/README.md | diff: diffs/README.md.diff | approval_required: yes
```

### Approval-based live apply
After a run produces promotion candidates, you can explicitly apply approved targets:

```bash
./bin/team-apply <run_id> --approve README.md
./bin/team-apply <run_id> --approve-all
```

Example:

```bash
./bin/team-apply 2026-05-22T11-15-58Z --approve-all
```

Rollback examples:

```bash
./bin/team-rollback 2026-05-22T11-15-58Z --target README.md
./bin/team-rollback 2026-05-22T11-15-58Z --all
```

The apply step:
- reads `promotion-candidates.json`
- copies approved mirror content back onto the live target
- writes machine-readable logs under `apply-logs/`
- writes `apply-summary.md`
- takes rollback snapshots before writing live targets
- writes `rollback-manifest.json`
- writes post-apply validation artifacts under `validation/`
- runs semantic validation for markdown/json/python/shell targets
- emits git-aware apply reports (`git-report.md`, `git-report.json`)
- uses file locks to avoid same-run collision on the same target

### Metrics and serious-session auto-updates
After serious delegate runs, the runtime auto-updates:
- `.codex/metrics/token-usage.md`
- `.codex/metrics/agent-performance.md`
- `.codex/metrics/leaderboard.md`
- `.codex/metrics/fallback-log.md`
- `.codex/memory/sessions/`
- `.codex/memory/resume/last-session.md`
- `.codex/todo/active-plan.md`

### Important truth boundary
This runtime is real local orchestration with persisted artifacts and explicit approval gates, but it is not a remote hosted LLM sub-agent mesh.

### Recommended operator examples
```bash
./bin/team delegate "auth feature x3"
./bin/team delegate "notification preference refactor x5"
./bin/team delegate "platform migration audit x10"
CODEX_STRICT_DELEGATE=1 ./bin/team delegate "build notification preferences x5"
./bin/team-apply 2026-05-22T11-15-58Z --approve README.md
```

## Team Wrappers

### Main team entrypoint
```bash
./bin/team <mode> "<prompt>"
```

### Supported modes
- `pcd`
- `context`
- `graphify`
- `delegate`
- `review`
- `caveman`

### Convenience command
```bash
./bin/ctx "analyze auth flow and keep reads minimal"
```

### Related wrappers
- `.codex/wrappers/context-mode-wrapper.sh`
- `.codex/wrappers/context-graphify-wrapper.sh`
- `.codex/wrappers/team-entrypoint.sh`

---

## Team Wrapper Operations

Preferred team entrypoint:

```bash
./bin/team <mode> "<prompt>"
```

Additional team tooling:
- `./bin/team-report`
- `./bin/team-report --markdown`
- `python3 .codex/scripts/wrapper_usage_summary.py`
- `python3 .codex/scripts/wrapper_usage_markdown_report.py`
- `python3 .codex/scripts/wrapper_usage_trend_analyzer.py`
- `python3 .codex/scripts/wrapper_dashboard_report.py`
- `python3 .codex/scripts/wrapper_health_check.py`
- `python3 .codex/scripts/wrapper_flow_validator.py`
- `.codex/config/wrapper-settings.md`
- `.codex/metrics/wrapper-mode-counts.md`
- archived reports under `.codex/logs/archive/`

Optional strict delegate mode:

```bash
CODEX_STRICT_DELEGATE=1 ./bin/team delegate "build notification preferences x5"
```

If strict mode is enabled and `xN` is missing, delegate mode blocks instead of warning.

---

## Skills

Reusable capabilities are stored under `.codex/skills/`.

Examples:
- analysis
- context-mode
- graphify
- caveman
- code-review
- implementation
- backend-development
- frontend-development
- testing-standards
- security-check

Each skill documents:
- purpose
- activation conditions
- workflow
- constraints
- expected output discipline

---

## Contracts and Checklists

Core structured artifacts:
- `.codex/contracts/task-report.md`
- `.codex/contracts/review-report.md`
- `.codex/contracts/session-summary.md`
- `.codex/contracts/handoff-summary.md`
- `.codex/contracts/fallback-event.md`
- `.codex/contracts/task-packet.md`
- `.codex/contracts/run-summary.md`
- `.codex/contracts/promotion-approval.md`

Core process checklists:
- `.codex/checklists/pre-task.md`
- `.codex/checklists/post-task.md`

---

## Operational Validation

If you want to verify the package is healthy, inspect:
- `.codex/docs/runtime-preflight.md`
- `.codex/docs/system-verification.md`
- `.codex/config/hook-registry.md`
- `.codex/instructions/reference/slash-commands.instructions.md`
- `.codex/instructions/reference/review-chain.instructions.md`

And for wrapper usage governance:
- `.codex/scripts/wrapper_usage_summary.py`
- `.codex/scripts/wrapper_usage_markdown_report.py`
- `.codex/scripts/wrapper_usage_trend_analyzer.py`
- `.codex/scripts/wrapper_dashboard_report.py`
- `.codex/scripts/wrapper_health_check.py`
- `.codex/scripts/wrapper_flow_validator.py`

---

## Internal Documentation Model

The internal documentation surface has been intentionally reduced toward a minimum viable set.

Primary reference:
- `.codex/docs/minimum-viable-doc-set.md`

This keeps the package lean while preserving operational depth where it matters.

---

## Remaining Improvement Opportunities

The package is already strong, but future enhancements could include:
- richer automated reference-integrity scans across `.codex/docs/`
- configurable wrapper health thresholds in a stricter policy layer
- richer dashboards if the team wants more reporting detail

These are optimization opportunities, not current blockers.

---

## Known Runtime Caveats

These are intentional environment-dependent caveats, not defects:
- model availability must be verified in the target account/runtime
- hook enforcement depends on wrapper/CI integration
- Graphify strength depends on graph artifact freshness/availability
- advisory persistence hooks may skip writes in restricted environments while preserving workflow continuity

---

## Final Guidance

If you change the operating model, update:
- this `README.md`
- the relevant `.codex/` source-of-truth docs
- any related contracts, wrappers, checks, or runtime verification docs

This keeps the package lean at the root while preserving depth internally.

