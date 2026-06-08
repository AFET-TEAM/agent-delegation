---
doc_id: README
lang: en
source_of_truth: true
version: 4.3.0
last_updated: 2026-05-22
sync_group: root-docs
translation_of: null
sync_status: canonical
---

# Codex Multi-Agent Engineering Boilerplate

> v4.3.0 — minimal-root, Codex-first, enterprise-grade multi-agent engineering handbook

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

This README is intentionally the **single root handbook** for the package.

It serves:
- individual contributors
- team leads
- reviewers
- rollout owners

Its job is to explain:
- what the system is
- how it behaves by default
- how the runtime actually works today
- what is guaranteed vs environment-dependent
- where the deeper operational assets live under `.codex/`

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
- contracts, checklists, memory, metrics, and runtime artifacts

Default-active operating baseline:
- `/caveman`
- `/context-mode`
- `/graphify`

Scaling control:
- `xN` -> agent scale selector

So a short prompt like:

```text
Auth feature x10
```

should be interpreted operationally closer to:

```text
/context-mode /graphify /caveman Auth feature x10
```

unless the active prompt explicitly disables one of those modes.

## Cross-Platform Parity Notes

- **Default-on token-efficiency modes (v7.4.3+)**: This is currently a Copilot-only feature. In Codex, `/caveman`, `/context-mode`, and `/graphify` remain opt-in (explicit slash trigger or keyword required). `slash-commands.instructions.md` may describe these modes as "default-active", but no persistent opt-out file exists yet; a `mode-overrides.md` equivalent is planned.

---

## Current Runtime Truth

The package now includes a **real local orchestration runtime** behind delegate mode.

When invoked through delegate mode explicitly, or when a plain Codex CLI prompt contains `xN`, the system can:
- parse `xN`
- generate per-tier task packets
- execute real parallel local subprocess workers in waves
- emit per-agent task reports
- emit review-chain artifacts
- stage safe writes into `workspace-mirror/`
- produce promotion candidates and per-file diffs
- apply approved changes back to the live repo
- create rollback snapshots and rollback manifests
- run semantic validation after apply
- emit git-aware reports after apply
- support follow-up stage / commit / PR workflow helpers

### Important truth boundary

This runtime is **real** in the following sense:
- real local subprocess execution
- real persisted packets/reports/reviews
- real retry/revision bookkeeping
- real apply / rollback / validation artifacts
- real git-facing helper workflows

But it is **not** currently:
- a hosted remote LLM sub-agent mesh
- a guarantee of external model/provider availability
- a misuse-proof autonomous production swarm
- a guaranteed PR creator on non-supported remotes

Example: GitHub PR creation support exists through `gh`, but it depends on the repo remote actually being a GitHub host and the local environment being authenticated.

---

## Strong Areas and Caveats

### Strong areas
- explicit multi-agent tier model
- explicit review chain
- explicit PCD model
- wrapper-based entrypoints
- contract-driven runtime artifacts
- approval-gated promote/apply pipeline
- rollback and validation support
- metrics and memory auto-update after serious runs

### Environment-dependent caveats
- model availability depends on the target runtime/account
- hook enforcement depends on wrapper/CI adoption
- Graphify quality depends on graph freshness/availability
- PR creation depends on remote host compatibility and auth
- optional validators such as `shellcheck` or markdown lint tooling may be unavailable and therefore degrade gracefully

---

## Root Policy

At the root level, keep only:
- `README.md`

Everything else belongs in `.codex/`.

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

### Turn-off examples
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
[task] xN
```

Inside Codex CLI, this plain form is the preferred human usage. Explicit `/delegate` remains valid but optional.

### Fixed modes
- `x2` -> quick discovery + senior gate
- `x3` -> small bounded feature
- `x4` -> medium feature
- `x5` -> standard production feature
- `x7` -> parallel feature/test/analysis/review
- `x10` -> migration, audit, or broad refactor

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
- approval-based live apply via helper workflows after delegate runs
- rollback via helper workflows after apply
- git-aware reports via `git-report.*`
- follow-up stage / commit / PR helper flows after apply
- repo-wide global lock management for competing target paths

### Runtime artifact tree
Each delegate run writes artifacts under:

```text
.codex/runtime/runs/<run_id>/
  manifest.json
  final-summary.md
  promotion-summary.md
  promotion-candidates.json
  apply-summary.md
  rollback-manifest.json
  rollback-summary.md
  rollback-log.json
  git-report.md
  git-report.json
  stage-report.md
  stage-report.json
  commit-report.md
  commit-report.json
  pr-report.md
  pr-report.json
  packets/
  agents/
  reviews/
  logs/
  diffs/
  apply-logs/
  validation/
  rollback/
  workspace-mirror/
```

### Practical default model
If a Codex CLI user gives only:

```text
Task x10
```

then the expected interpretation is effectively:
- default modes active
- x10 scale active
- implicit delegate active
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

Core behavior:
- narrow with search first
- read only relevant sections
- summarize findings compactly
- explicitly note what was intentionally not read yet

---

## Graphify

Use `/graphify` when:
- dependency surface is large
- hotspot detection matters
- topology-first narrowing is useful

Core behavior:
- check graph freshness
- query hotspots/boundaries
- read narrowed files
- report EXTRACTED / INFERRED / AMBIGUOUS

---

## Caveman

Use `/caveman` to reduce prose verbosity without changing meaning.

Modes:
- `/caveman`
- `/caveman lite`
- `/caveman full`
- `/caveman ultra`

Preservation rules:
- never compress code
- never compress commands, paths, warnings, or errors
- never compress irreversible or consent-critical wording

---

## Architecture Overview

The current runtime can be understood as four connected layers:
- wrapper/operator entrypoints
- delegate orchestration runtime
- approval-gated apply/rollback pipeline
- git-facing post-apply helpers

### Runtime architecture diagram

```mermaid
flowchart TD
    U[Operator] --> W[./bin/team]
    W --> M{Mode}
    M -->|delegate| DP[delegation_plan.py]
    DP --> ORCH[orchestrate.py]
    ORCH --> P[task_packets.py]
    ORCH --> W1[wave1 T5]
    ORCH --> W2[wave2 T4]
    ORCH --> W3[wave3 T3]
    ORCH --> W4[wave4 T2]
    ORCH --> W5[wave5 T1]
    W1 --> AW[agent_worker.py]
    W2 --> AW
    W3 --> AW
    W4 --> AW
    W5 --> AW
    AW --> SW[safe_writes.py]
    SW --> GL[global-locks.json]
    AW --> WR[workspace-mirror]
    ORCH --> RV[review_chain.py]
    RV --> RR[reviews/*.md]
    ORCH --> FS[final-summary.md]
    ORCH --> MET[metrics_auto.py]
    MET --> MEM[memory + metrics + todo]
```

### Approval and promotion diagram

```mermaid
flowchart TD
    WR[workspace-mirror] --> PR[promotion.py]
    PR --> DIFF[diffs/*.diff]
    PR --> PC[promotion-candidates.json]
    PR --> PS[promotion-summary.md]
    PC --> AP[./bin/team-apply]
    AP --> LOCK[file_locks.py]
    AP --> RB[rollback snapshots]
    AP --> LIVE[live repo targets]
    LIVE --> VAL[semantic_validation.py]
    VAL --> VJ[validation/*.json]
    AP --> GS[git_reporting.py]
    GS --> GR[git-report.md/json]
    AP --> AS[apply-summary.md]
```

### Rollback and git-helper diagram

```mermaid
flowchart LR
    LIVE[live repo targets] --> TR[./bin/team-rollback]
    TR --> RM[rollback-manifest.json]
    RM --> RS[rollback/]
    TR --> RLOG[rollback-summary.md + rollback-log.json]

    LIVE --> TG[./bin/team-git]
    TG --> ST[stage-report.*]
    TG --> CM[commit-report.*]
    TG --> PRR[pr-report.*]
```

### Interpretation
- plain `xN` prompts in Codex CLI drive orchestration and artifact generation.
- workers never write directly to the live repo during delegate execution; they write into `workspace-mirror/`.
- promotion/apply is a second explicit step.
- rollback is a third explicit step.
- git stage/commit/PR helpers are optional follow-up operator actions.

## Real Delegate Runtime Walkthrough

This section describes the **actual runtime behavior** behind `delegate` mode.

### High-level lifecycle
When you run:

```text
approval-based live apply / promote pipeline ekle x10
```

the system performs these stages:

1. wrapper validates mode and prompt shape
2. delegation plan is rendered
3. runtime parses `xN` and builds tier packets
4. packets are executed in waves
5. each worker emits a task report
6. reviewer tiers emit review reports
7. safe writes go to `workspace-mirror/` instead of the live repo
8. unified diffs and promotion candidates are generated
9. optional apply promotes approved mirror files back to live targets
10. rollback snapshots are created before live apply
11. post-apply semantic validation runs
12. git-aware reports are emitted
13. metrics/session/resume/todo files are auto-updated for serious runs

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
```text
auth feature x3
```

#### `x5`
- T5: 1
- T4: 1
- T3: 1
- T2: 1
- T1: 1

Example:
```text
notification refactor x5
```

#### `x10`
- T5: 2
- T4: 2
- T3: 2
- T2: 2
- T1: 2

Example:
```text
platform migration audit x10
```

Expected use:
- migration
- broad refactor
- heavy audit
- high review pressure

### Example: successful delegate run
```text
update README.md and AGENTS.md x5
```

Typical artifact families:
- `manifest.json`
- `agents/*.md`
- `reviews/*.md`
- `promotion-summary.md`
- `promotion-candidates.json`
- `diffs/*.diff`

### Example: revision-loop scenario
```text
force-revision runtime write update README.md x5
```

What this demonstrates:
- review reports can return `Revision Required`
- the same packet can retry up to 2 more times
- exhausted loops are logged as fallback/escalation rows
- fallback visibility is preserved in final summary and metrics

Typical artifacts:
- `reviews/*-r0.md`
- `reviews/*-r1.md`
- `reviews/*-r2.md`
- fallback rows in `.codex/metrics/fallback-log.md`

---

## Safe File-Writing Model

Workers do **not** directly modify the live repository during runtime execution.
They write to:

```text
.codex/runtime/runs/<run_id>/workspace-mirror/
```

Write policy is tier-scoped:
- T5 -> raw analysis/runtime-owned surfaces only
- T4 -> consolidation/contracts-oriented surfaces
- T3 -> bounded implementation-safe surfaces and mirror outputs
- T2 -> broader config/contracts/docs surfaces
- T1 -> highest review/architecture scope including selected root docs

Write policy decisions are logged under:
- `.codex/runtime/runs/<run_id>/logs/write-policy-T*.json`

---

## Repo-Wide Global Lock Manager

The runtime now keeps a shared repo-wide lock registry under:

```text
.codex/runtime/global-locks.json
```

Purpose:
- prevent competing runs from silently staging/applying to the same target path
- make lock ownership explicit
- preserve run-local lock snapshots for diagnostics

Run-local diagnostic lock snapshots are still written to:
- `.codex/runtime/runs/<run_id>/locks.json`

This means lock scope is no longer only per-run.
It is coordinated across the repo runtime surface.

---

## Approval-Ready Promotion Model

Mirror changes are not auto-applied to live repo targets.
The runtime emits:
- `promotion-summary.md`
- `promotion-candidates.json`
- per-file unified diffs under `diffs/`

Example approval summary entry:

```text
- target: README.md | mirror: workspace-mirror/README.md | diff: diffs/README.md.diff | approval_required: yes
```

---

## Approval-Based Live Apply

After a run produces promotion candidates, you can explicitly apply approved targets:

```text
apply <run_id> --approve README.md
apply <run_id> --approve-all
```

Inside Codex CLI, helper intents can also be expressed plain-text-first if the runtime layer exposes them.

Example:

```bash
./bin/team-apply 2026-05-22T11-31-18Z --approve-all
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
- uses the repo-wide lock manager to avoid same-target collisions
- releases apply/runtime locks after work completes so later runs are not permanently blocked

Git-aware reports:
- `git-report.md`
- `git-report.json`

---

## Rollback

Rollback examples:

```text
rollback 2026-05-22T11-31-18Z --target README.md
rollback 2026-05-22T11-31-18Z --all
```

Rollback behavior:
- reads `rollback-manifest.json`
- restores selected live targets from snapshots under `rollback/`
- writes `rollback-summary.md`
- writes `rollback-log.json`

Validation failure behavior during apply:
- invalid promoted content is rolled back immediately from the live target
- the per-target result is marked unsuccessful rather than reported as applied

---

## Semantic Validation

Post-apply validation currently includes best-effort file-type-aware checks.

### Markdown
- non-empty check
- basic structure check
- optional markdown lint integration when available

### JSON
- parse validation
- parsed structure sanity

### Python
- compile validation
- best-effort safe import smoke for low-risk cases

### Shell
- `bash -n`
- `shellcheck` when available

Unavailable optional tools degrade gracefully and are reported as skipped/unavailable rather than crashing the apply pipeline.

---

## Git Workflow Helpers

After apply, you can run git-facing helper commands.

### Stage approved targets
```text
git stage 2026-05-22T11-31-18Z README.md AGENTS.md
```

### Commit staged changes
```text
git commit 2026-05-22T11-31-18Z chore: apply approved runtime promotions
```

### Prepare a PR request (GitHub CLI path, dry-run oriented)
```text
git pr 2026-05-22T11-31-18Z Apply runtime promotions Approval-gated changes from runtime run
```

Artifacts:
- `stage-report.md`
- `stage-report.json`
- `commit-report.md`
- `commit-report.json`
- `pr-report.md`
- `pr-report.json`

### Important PR caveat
The PR helper currently relies on `gh pr create`.
If the repository remote is not a known GitHub host, or if auth is not configured, PR creation will not succeed and the failure will be captured in `pr-report.*`.

---

## Metrics and Serious-Session Auto-Updates

After serious delegate runs, the runtime auto-updates:
- `.codex/metrics/token-usage.md`
- `.codex/metrics/agent-performance.md`
- `.codex/metrics/leaderboard.md`
- `.codex/metrics/fallback-log.md`
- `.codex/memory/sessions/`
- `.codex/memory/resume/last-session.md`
- `.codex/todo/active-plan.md`

---

## Hooks

Hook scripts live under `.codex/hooks/`.

Important runtime truth:
- hooks exist
- enforcement depends on wrapper/CI/runtime wiring
- advisory persistence hooks degrade safely in restricted environments

Examples:
- `git-safety-check.sh`
- `context-mode-guard.sh`
- `graphify-audit.sh`
- `review-tracker.sh`
- `self-learning-collector.sh`

---

## Simple Command UX

Inside Codex CLI sessions, users should be able to type **plain prompts** without adding `delegate`, `codex`, `run`, or another orchestration prefix.

### Core interpretation rule
If a plain prompt contains `x2`, `x3`, `x4`, `x5`, `x7`, or `x10`, it should automatically be treated as a delegate request.

Examples inside Codex CLI:

```text
auth feature x3
notification refactor x5
platform migration audit x10
approval-based live apply pipeline ekle x10
```

Operationally, these are interpreted as if the user had written:

```text
/context-mode /graphify /caveman /delegate <prompt-with-xN>
```

### Keyword-first mode selection
If the prompt starts with one of these keywords, it should route accordingly:
- `pcd`
- `context`
- `graphify`
- `caveman`
- `review`

Examples inside Codex CLI:

```text
pcd repo analizi
caveman auth akis ozeti
graphify high coupling module boundaries
review son degisiklikleri kontrol et
```

### Important boundary
This plain-prompt behavior is the intended interpretation model for **Codex CLI conversation usage**.
For raw external shell usage, some command entrypoint is still required because shells cannot execute arbitrary natural-language text without a command/function wrapper.

### External-shell optional helpers
For users who operate outside Codex CLI, helper entrypoints still exist:
- `bin/codex`
- `.codex/runtime/shell_integration.sh`
- `.codex/scripts/install_simple_cli.sh`

But these are optional external-shell conveniences, not the primary intended UX inside Codex CLI sessions.

---

## Team Wrappers and Commands

### Main team entrypoint
```text
<prompt>
```

Inside Codex CLI conversation usage, plain prompts are the primary operator surface. External shell wrappers remain available separately.

### Supported team modes
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

### Apply / rollback / git helpers
```bash
./bin/team-apply <run_id> --approve README.md
./bin/team-rollback <run_id> --target README.md
./bin/team-git stage <run_id> README.md AGENTS.md
./bin/team-git commit <run_id> "chore: apply approved runtime promotions"
./bin/team-git pr <run_id> "Apply runtime promotions" "Approval-gated changes from runtime run"
```

### Strict delegate enforcement
```bash
CODEX_STRICT_DELEGATE=1 ./bin/team delegate "build notification preferences x5"
```

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
- `.codex/checklists/agents-contract-checklist.md`

---

## Operational Validation

If you want to verify the package is healthy, inspect:
- `.codex/docs/runtime-preflight.md`
- `.codex/docs/system-verification.md`
- `.codex/config/hook-registry.md`
- `.codex/instructions/reference/slash-commands.instructions.md`
- `.codex/instructions/reference/review-chain.instructions.md`
- runtime artifacts under `.codex/runtime/runs/<run_id>/`

And for wrapper usage governance:
- `.codex/scripts/wrapper_usage_summary.py`
- `.codex/scripts/wrapper_usage_markdown_report.py`
- `.codex/scripts/wrapper_usage_trend_analyzer.py`
- `.codex/scripts/wrapper_dashboard_report.py`
- `.codex/scripts/wrapper_health_check.py`
- `.codex/scripts/wrapper_flow_validator.py`

---

## Recommended Operator Examples

Quick bounded work:
```text
auth feature x3
```

Balanced production lane:
```text
notification preference refactor x5
```

Broad migration/audit lane:
```text
platform migration audit x10
```

Promotion/apply lane:
```text
update README.md and AGENTS.md x10
apply 2026-05-22T11-31-18Z --approve-all
git stage 2026-05-22T11-31-18Z README.md AGENTS.md
```

Rollback lane:
```text
rollback 2026-05-22T11-31-18Z --target README.md
```

GitHub PR helper lane:
```text
git pr 2026-05-22T11-31-18Z Apply runtime promotions Approval-gated changes from runtime run
```

---

## Final Guidance

If you change the operating model, update:
- this `README.md`
- the relevant `.codex/` source-of-truth docs
- any related contracts, wrappers, checks, runtime helpers, or verification docs

This keeps the package lean at the root while preserving depth internally.

> **Versioning**: see [docs/VERSION_STRATEGY.md](../docs/VERSION_STRATEGY.md) for cross-platform parity policy.
