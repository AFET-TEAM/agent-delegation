# Git Report

## Status
```text
 M ../Claude/.claude/agents/analyst.md
 M ../Claude/.claude/config/context-budget.md
 M ../Claude/.claude/config/tier-definitions.md
 M ../Claude/.claude/hooks/update-leaderboard.sh
 M ../Claude/.claude/metrics/.edit-counter
 M ../Claude/.claude/metrics/.edit-log
 M ../Claude/.claude/metrics/.session-edits-20260521.log
 M ../Claude/.claude/scripts/setup.sh
 M ../Claude/.claude/todo/active-plan.md
 M ../Claude/CLAUDE.md
 M .codex/docs/caveman-measurement.md
 M .codex/docs/caveman.md
 M .codex/docs/context-efficiency.md
 M .codex/docs/context-mode-integration-design.md
 M .codex/docs/enterprise-onboarding.md
 M .codex/docs/graphify-integration-design.md
 M .codex/docs/graphify.md
 M .codex/docs/principal-architect-review.md
 M .codex/docs/usage-guide.md
 M .codex/instructions/reference/slash-commands.instructions.md
 M .codex/memory/resume/last-session.md
 M .codex/metrics/agent-performance.md
 M .codex/metrics/fallback-log.md
 M .codex/metrics/leaderboard.md
 M .codex/metrics/token-usage.md
 M .codex/rules/caveman.md
 M .codex/skills/caveman/SKILL.md
 M .codex/todo/active-plan.md
 D ACCEPTANCE_AUDIT.md
M  AGENTS.md
 D CHANGELOG.md
 D INDEX.md
 D ONE_PAGE_QUICKSTART.md
 D OPERATIONS_RUNBOOK.md
 D PACKAGE_MANIFEST.md
 D PROGRESS.md
MM README.md
 D SEMANTIC_PARITY_CHECKLIST.md
 D START_HERE.md
 D USAGE.md
 D docs/codex-multi-agent-guide.html
?? ../Claude/.claude/analysis/consolidated/G04-use-case-catalog.md
?? ../Claude/.claude/analysis/consolidated/G09-T3A-review.md
?? ../Claude/.claude/analysis/consolidated/G10-T3B-review.md
?? ../Claude/.claude/analysis/consolidated/G12-final-review.md
?? ../Claude/.claude/analysis/consolidated/H03-translation-scope.md
?? ../Claude/.claude/analysis/consolidated/H04-example-catalog.md
?? ../Claude/.claude/analysis/consolidated/H09-T3A-review.md
?? ../Claude/.claude/analysis/consolidated/H10-T3B-review.md
?? ../Claude/.claude/analysis/raw/H01-html-english-audit.md
?? ../Claude/.claude/analysis/raw/H02-feature-example-catalog.md
?? ../Claude/.claude/analysis/raw/H07-tr-sections-1-4.md
?? ../Claude/.claude/analysis/raw/H08-tr-sections-5-8-examples.md
?? ../Claude/.claude/docs/ARCHITECTURE.md
?? ../Claude/.claude/docs/FAQ.md
?? ../Claude/.claude/docs/GETTING_STARTED.md
?? ../Claude/.claude/docs/TROUBLESHOOTING.md
?? ../Claude/.claude/docs/example-sections-design.md
?? ../Claude/.claude/docs/hook-exit-codes.md
?? ../Claude/.claude/docs/html-doc-architecture.md
?? ../Claude/.claude/docs/improvement-plan.md
?? ../Claude/.claude/docs/turkish-content-plan.md
?? ../Claude/.claude/memory/learned-patterns/LP-2026-05-21-01-html-hook-exclusion.md
?? ../Claude/.claude/memory/sessions/session-2026-05-21-deep-analysis-html-docs-x10.md
?? ../Claude/.claude/metrics/fallback-log.md
?? ../Claude/.claude/scripts/verify-install.sh
?? ../Claude/.claude/skills/test-gen/
?? ../Claude/docs/
?? .codex/checklists/agents-contract-checklist.md
?? .codex/config/wrapper-settings.md
?? .codex/contracts/promotion-approval.md
?? .codex/contracts/run-summary.md
?? .codex/contracts/task-packet.md
?? .codex/docs/context-graphify-wrapper.md
?? .codex/docs/context-mode-wrapper.md
?? .codex/docs/delegation-engine.md
?? .codex/docs/minimum-viable-doc-set.md
?? .codex/docs/readme-agents-consistency.md
?? .codex/docs/team-entrypoint-wrapper.md
?? .codex/logs/
?? .codex/memory/sessions/session-2026-05-22-local-runtime.md
?? .codex/memory/sessions/session-2026-05-22-runtime-auto-2026-05-22T11-10-57Z.md
?? .codex/memory/sessions/session-2026-05-22-runtime-auto-2026-05-22T11-11-13Z.md
?? .codex/memory/sessions/session-2026-05-22-runtime-auto-2026-05-22T11-15-58Z.md
?? .codex/memory/sessions/session-2026-05-22-runtime-auto-2026-05-22T11-31-18Z.md
?? .codex/memory/sessions/session-2026-05-22-runtime-auto-2026-05-22T11-55-36Z.md
?? .codex/metrics/wrapper-mode-counts.md
?? .codex/runtime/
?? .codex/scripts/delegation_plan.py
?? .codex/scripts/install_simple_cli.sh
?? .codex/scripts/wrapper_dashboard_report.py
?? .codex/scripts/wrapper_flow_validator.py
?? .codex/scripts/wrapper_health_check.py
?? .codex/scripts/wrapper_usage_analyzer.py
?? .codex/scripts/wrapper_usage_markdown_report.py
?? .codex/scripts/wrapper_usage_summary.py
?? .codex/scripts/wrapper_usage_trend_analyzer.py
?? .codex/wrappers/
?? bin/
?? ../Cursor/
```

## Diff
```diff
diff --git a/Codex/.codex/docs/caveman-measurement.md b/Codex/.codex/docs/caveman-measurement.md
index 6afffa0..e438da1 100644
--- a/Codex/.codex/docs/caveman-measurement.md
+++ b/Codex/.codex/docs/caveman-measurement.md
@@ -1,23 +1,9 @@
-# Caveman Measurement
+# Archived Doc
 
-## Goal
+This document has been intentionally de-emphasized to keep the internal documentation surface lean.
 
-Measure whether caveman mode reduces output token volume without harming clarity.
-
-## Suggested Method
-
-- pick 3 representative sessions
-- capture normal-mode summary length
-- capture caveman summary length
-- compare token reduction and readability
-
-## Acceptance Heuristic
-
-Compression is successful if outputs are materially shorter while preserving commands, paths, warnings, and decisions.
-
-## Example Evaluation
-
-- normal mode: 220 tokens
-- caveman full: 130 tokens
-- caveman ultra: 90 tokens
-- if warnings or commands become ambiguous, do not treat as success
+Canonical guidance now lives in:
+- README.md
+- .codex/docs/runtime-preflight.md
+- .codex/docs/system-verification.md
+- .codex/docs/usage-guide.md
diff --git a/Codex/.codex/docs/caveman.md b/Codex/.codex/docs/caveman.md
index 0babe53..096ecf2 100644
--- a/Codex/.codex/docs/caveman.md
+++ b/Codex/.codex/docs/caveman.md
@@ -2,24 +2,16 @@
 
 ## Amaç
 
-Caveman, açıklama ve rapor çıktılarının token boyutunu azaltır; kodu, dosya yolunu ve kritik uyarıları değiştirmez.
+Caveman artık varsayılan kısa çıktı disiplininin temelidir.
 
-## Aktivasyon
+## Default Behavior
 
-- `/caveman`
+Caveman baseline artık default-on kabul edilir.
+Daha agresif modlar yine ayrıca seçilebilir:
 - `/caveman lite`
 - `/caveman full`
 - `/caveman ultra`
 
-## Ne Zaman Kullanılır?
+## Koruma Kuralı
 
-- uzun ama düşük riskli raporlarda
-- status veya summary çıktılarında
-- çok fazla açıklama yerine net sonuç gerektiğinde
-
-## Ne Zaman Kullanılmaz?
-
-- riskli/destructive adımlar
-- güvenlik uyarıları
-- git onay cümleleri
-- karmaşık çok adımlı yönlendirmeler
+Kod, komut, path, uyarı ve kritik güvenlik dili sıkıştırılırken bozulmaz.
diff --git a/Codex/.codex/docs/context-efficiency.md b/Codex/.codex/docs/context-efficiency.md
index 9032e84..e438da1 100644
--- a/Codex/.codex/docs/context-efficiency.md
+++ b/Codex/.codex/docs/context-efficiency.md
@@ -1,26 +1,9 @@
-# Context Efficiency
+# Archived Doc
 
-## Amaç
+This document has been intentionally de-emphasized to keep the internal documentation surface lean.
 
-Aynı kaliteyi daha az bağlam tüketerek elde etmek.
-
-## Teknikler
-
-- query-first search
-- progressive disclosure
-- dynamic skill loading
-- graph-assisted narrowing
-- concise handoff
-
-## Senaryo Örneği
-
-### Kötü Akış
-- repo büyük
-- doğrudan çok sayıda dosya tam okunuyor
-- sonra problem alanı daraltılmaya çalışılıyor
-
-### İyi Akış
-- önce PCD
-- sonra graph/topology veya targeted search
-- ardından sadece ilgili dosya/section okunuyor
-- sonuç condensed handoff ile üst tiere taşınıyor
+Canonical guidance now lives in:
+- README.md
+- .codex/docs/runtime-preflight.md
+- .codex/docs/system-verification.md
+- .codex/docs/usage-guide.md
diff --git a/Codex/.codex/docs/context-mode-integration-design.md b/Codex/.codex/docs/context-mode-integration-design.md
index bc3e690..e438da1 100644
--- a/Codex/.codex/docs/context-mode-integration-design.md
+++ b/Codex/.codex/docs/context-mode-integration-design.md
@@ -1,27 +1,9 @@
-# Context Mode Integration Design
+# Archived Doc
 
-## Purpose
+This document has been intentionally de-emphasized to keep the internal documentation surface lean.
 
-Describe how context-efficiency rules integrate with day-to-day Codex usage.
-
-## Design Principles
-
-- query-first by default
-- wrapper or team conventions may reinforce large-output avoidance
-- summaries move upward, raw dumps do not
-- graph/topology methods should complement PCD on large repos
-
-## Integration Points
-
-- preflight docs
-- wrappers
-- review checklists
-- hooks that warn/block large-output anti-patterns
-
-## Example Flow
-
-1. user requests broad refactor
-2. Orchestrator runs PCD
-3. T5 narrows module targets via graph/search
-4. T4 consolidates findings
-5. T2/T3 implement only on narrowed files
+Canonical guidance now lives in:
+- README.md
+- .codex/docs/runtime-preflight.md
+- .codex/docs/system-verification.md
+- .codex/docs/usage-guide.md
diff --git a/Codex/.codex/docs/enterprise-onboarding.md b/Codex/.codex/docs/enterprise-onboarding.md
index 46ba9b7..e438da1 100644
--- a/Codex/.codex/docs/enterprise-onboarding.md
+++ b/Codex/.codex/docs/enterprise-onboarding.md
@@ -1,22 +1,9 @@
-# Enterprise Onboarding
+# Archived Doc
 
-## Audience
-Takım liderleri, kıdemli geliştiriciler, yeni ekip üyeleri.
+This document has been intentionally de-emphasized to keep the internal documentation surface lean.
 
-## Rollout Order
-1. README + AGENTS
-2. USAGE + demo flow
-3. rules + skills overview
-4. sample session/memory review
-5. first controlled team trial on x3 or x5
-
-## Governance Notes
-- git consent policy must be communicated clearly
-- fallback visibility is mandatory
-- review chain is not optional in multi-agent mode
-- metrics are operational feedback, not vanity data
-
-## Real Project Tuning
-- adapt templates to your repo topology
-- align backend/frontend rules with current stack versions
-- verify hooks on CI or wrapper path before scaling usage
+Canonical guidance now lives in:
+- README.md
+- .codex/docs/runtime-preflight.md
+- .codex/docs/system-verification.md
+- .codex/docs/usage-guide.md
diff --git a/Codex/.codex/docs/graphify-integration-design.md b/Codex/.codex/docs/graphify-integration-design.md
index 7b373fa..e438da1 100644
--- a/Codex/.codex/docs/graphify-integration-design.md
+++ b/Codex/.codex/docs/graphify-integration-design.md
@@ -1,24 +1,9 @@
-# Graphify Integration Design
+# Archived Doc
 
-## Purpose
+This document has been intentionally de-emphasized to keep the internal documentation surface lean.
 
-Define how graph/topology discovery supports analysis tiers and the Orchestrator.
-
-## Principles
-
-- topology should narrow search, not replace judgment
-- stale graph state must be visible
-- local-only generation preferred for private codebases
-
-## Workflow
-
-1. check freshness
-2. query hotspots/boundaries
-3. narrow file reads
-4. consolidate into actionable findings
-
-## Failure Modes
-
-- stale graph creates misleading confidence
-- graph-only inference without file confirmation can overreach
-- missing graph should degrade to targeted search, not brute-force chaos
+Canonical guidance now lives in:
+- README.md
+- .codex/docs/runtime-preflight.md
+- .codex/docs/system-verification.md
+- .codex/docs/usage-guide.md
diff --git a/Codex/.codex/docs/graphify.md b/Codex/.codex/docs/graphify.md
index 2ebfa80..c537e3f 100644
--- a/Codex/.codex/docs/graphify.md
+++ b/Codex/.codex/docs/graphify.md
@@ -1,22 +1,20 @@
 # Graphify / Knowledge Graph
 
-## Amaç
+## Purpose
 
-Büyük repolarda dosya dosya brute-force gezinmek yerine topoloji sinyalleriyle kritik alanları bulmak.
+Default-active topology-first narrowing for large repositories and coupled systems.
 
-## Kullanım
+## Default Behavior
+
+Graphify is now treated as preferred-by-default unless explicitly disabled.
+
+## Use Model
 
 - hotspot bulma
 - modül sınırı çıkarma
 - coupling risklerini belirleme
 - PCD sonrası ilgili okuma listesini daraltma
 
-## Örnek Analiz Çıktısı
-
-- EXTRACTED: AuthService imports TokenStore
-- INFERRED: Notification delivery and preference UI share cross-module coupling via event path
-- AMBIGUOUS: Retry policy ownership unclear without deeper read
-
-## Kullanım Notu
+## Important Note
 
-Graph çıktısı karar yardımıdır; kritik yorumlar için ilgili dosya yine açılmalıdır.
+Graphify karar yardımıdır; kritik yorumlar için ilgili dosya yine açılmalıdır.
diff --git a/Codex/.codex/docs/principal-architect-review.md b/Codex/.codex/docs/principal-architect-review.md
index d5caf77..e438da1 100644
--- a/Codex/.codex/docs/principal-architect-review.md
+++ b/Codex/.codex/docs/principal-architect-review.md
@@ -1,18 +1,9 @@
-# Principal Architect Review
+# Archived Doc
 
-## Review Scope
+This document has been intentionally de-emphasized to keep the internal documentation surface lean.
 
-This document captures a principal-level review of the Codex boilerplate structure.
-
-## Checked Areas
-
-- model/tier alignment
-- review chain coherence
-- skill/rule/instruction layering
-- hook coverage
-- session/memory/metrics completeness
-- onboarding and runtime readiness
-
-## Verdict
-
-The package is structurally coherent and suitable for controlled enterprise rollout, provided real environment model access and hook wiring are verified.
+Canonical guidance now lives in:
+- README.md
+- .codex/docs/runtime-preflight.md
+- .codex/docs/system-verification.md
+- .codex/docs/usage-guide.md
diff --git a/Codex/.codex/docs/usage-guide.md b/Codex/.codex/docs/usage-guide.md
index 830f683..f03f396 100644
--- a/Codex/.codex/docs/usage-guide.md
+++ b/Codex/.codex/docs/usage-guide.md
@@ -1,26 +1,38 @@
 # Usage Guide
 
+## Default Mode Baseline
+
+Unless explicitly disabled, this package now assumes these modes are active by default:
+- `/caveman`
+- `/context-mode`
+- `/graphify`
+
+This means a short prompt like:
+
+```text
+Auth feature x5
+```
+
+should be interpreted operationally closer to:
+
+```text
+/context-mode /graphify /caveman Auth feature x5
+```
+
 ## Quick Examples
 
-- `Analyze the payment module /pcd`
-- `/delegate build notification service x5`
-- `/review inspect latest changes`
-- `/context-mode /delegate large refactor x7`
-- `/caveman full /status`
+- `Analyze the payment module x3`
+- `build notification service x5`
+- `large refactor x7`
+- `migration audit x10`
 
 ## Recommended Sequence
 
 1. `README.md`
-2. `START_HERE.md`
-3. `AGENTS.md`
-4. `USAGE.md`
-5. `.codex/docs/runtime-preflight.md`
-6. `.codex/demo/end-to-end-x7.md`
+2. `.codex/instructions/reference/slash-commands.instructions.md`
+3. `.codex/docs/runtime-preflight.md`
+4. `.codex/demo/end-to-end-x7.md`
 
 ## Operator Hint
 
-If the repo is large or unfamiliar, never skip PCD and context-mode discipline.
-
-## Runtime Hint
-
-If the environment is read-only or persistence-restricted, advisory hooks may report warnings and skip writes instead of failing the workflow.
+If you do not explicitly opt out, the system should behave as if compressed output, context discipline, and graph-first narrowing are on by default.
diff --git a/Codex/.codex/instructions/reference/slash-commands.instructions.md b/Codex/.codex/instructions/reference/slash-commands.instructions.md
index 0cd3c70..5ebb2c3 100644
--- a/Codex/.codex/instructions/reference/slash-commands.instructions.md
+++ b/Codex/.codex/instructions/reference/slash-commands.instructions.md
@@ -4,6 +4,18 @@
 
 Normalize how command-like modifiers affect orchestration behavior.
 
+## Default Active Modes
+
+Unless explicitly turned off by the operator, the following modes are treated as default-active:
+- `/caveman`
+- `/context-mode`
+- `/graphify`
+
+This means:
+- compressed output is the baseline
+- context discipline is the baseline
+- topology-first narrowing is preferred when useful
+
 ## Commands and Effects
 
 - `/delegate` -> multi-agent decomposition
@@ -12,14 +24,30 @@ Normalize how command-like modifiers affect orchestration behavior.
 - `/architect` -> architecture-first routing
 - `/resume` -> continue prior context
 - `/history` -> summarize prior decisions
-- `/context-mode` -> strict context discipline
-- `/caveman` -> compressed output
-- `/graphify` -> topology-first exploration
+- `/context-mode` -> strict context discipline (default-active)
+- `/caveman` -> compressed output (default-active)
+- `/graphify` -> topology-first exploration (default-active)
 - `/pcd` -> project context discovery
 - `/fallback-status` -> report fallback events
 
+## Caveman Severity
+
+- default baseline -> concise output
+- `/caveman lite` -> lightly compressed
+- `/caveman full` -> aggressively compressed by default
+- `/caveman ultra` -> telegraph-style where safe
+
+## xN Interaction
+
+- `xN` controls agent scale
+- default modes remain active unless explicitly disabled
+- typical shortest operator form can now be just:
+  - `task x5`
+  - `task x10`
+
 ## Examples
 
-- `/pcd /delegate Auth feature x5`
-- `/context-mode /review recent changes`
-- `/architect payment module boundary proposal`
+- `Auth feature x5`
+- `Large refactor x10`
+- `/delegate Auth feature x5`
+- `/review recent changes`
diff --git a/Codex/.codex/memory/resume/last-session.md b/Codex/.codex/memory/resume/last-session.md
index dbf1efb..dbfd711 100644
--- a/Codex/.codex/memory/resume/last-session.md
+++ b/Codex/.codex/memory/resume/last-session.md
@@ -1,18 +1,17 @@
 # Last Session Resume
 
 ## Current State
-Codex boilerplate parity and deepening passes are complete.
+Runtime now supports safe file-writing, revision loops, and automatic bookkeeping.
 
 ## Most Important Decisions
-- skills/instructions/contracts/hooks are all first-class layers
-- review chain is mandatory in multi-agent mode
-- fallback visibility is operationally required
+- writes are sandboxed into runtime workspace-mirror unless explicitly allowed
+- revision required results can retry up to 2 rounds before escalation
+- metrics/session/todo updates occur automatically after serious delegate runs
 
 ## Recommended Next Use
-Start with:
-`/pcd /delegate [task] x5`
+`./bin/team delegate "approval-based live apply pipeline ekle x10"`
 
 ## What To Recheck In New Environments
-- model availability
-- hook execution conventions
-- wrapper/preflight integration
+- rg availability
+- python3 subprocess policies
+- runtime artifact retention expectations
diff --git a/Codex/.codex/metrics/agent-performance.md b/Codex/.codex/metrics/agent-performance.md
index d0a127b..037180a 100644
--- a/Codex/.codex/metrics/agent-performance.md
+++ b/Codex/.codex/metrics/agent-performance.md
@@ -8,6 +8,16 @@
 | 2026-05-21 | Orion | T4 | 1 | 2 | 0 | consolidation output strong |
 | 2026-05-21 | Mira | T5 | 2 | 0 | 0 | high-signal raw analysis |
 
+| 2026-05-22 | T5-1 | T5 | 1 | 0 | 0 | local runtime auto-update |
+| 2026-05-22 | T4-1 | T4 | 1 | 1 | 0 | local runtime auto-update |
+| 2026-05-22 | T3-1 | T3 | 1 | 0 | 0 | local runtime auto-update |
+| 2026-05-22 | T2-1 | T2 | 1 | 1 | 0 | local runtime auto-update |
+| 2026-05-22 | T1-1 | T1 | 1 | 1 | 0 | local runtime auto-update |
+| 2026-05-22 | T5-2 | T5 | 1 | 0 | 0 | local runtime auto-update |
+| 2026-05-22 | T4-2 | T4 | 1 | 1 | 0 | local runtime auto-update |
+| 2026-05-22 | T3-2 | T3 | 1 | 0 | 0 | local runtime auto-update |
+| 2026-05-22 | T2-2 | T2 | 1 | 1 | 0 | local runtime auto-update |
+| 2026-05-22 | T1-2 | T1 | 1 | 1 | 0 | local runtime auto-update |
 ## Interpretation
 
 Repeated fallback or rework should feed calibration and task-routing improvements.
diff --git a/Codex/.codex/metrics/fallback-log.md b/Codex/.codex/metrics/fallback-log.md
index 3727121..4ba3282 100644
--- a/Codex/.codex/metrics/fallback-log.md
+++ b/Codex/.codex/metrics/fallback-log.md
@@ -4,6 +4,9 @@
 |---|---|---|---|---|---|---|
 | 2026-05-21T12:40:00Z | Nova | T2 | gpt-5.3-codex | gpt-5.2 | model unavailable | lower cost, possible coding-depth tradeoff |
 
+| 2026-05-22T11:11:13Z | T5-1 | T5 | gpt-5.2 | gpt-5.2 | revision loop exhausted | runtime escalation required |
+| 2026-05-22T11:11:14Z | T3-1 | T3 | gpt-5.2 | gpt-5.2 | revision loop exhausted | runtime escalation required |
+| 2026-05-22T11:11:14Z | T2-1 | T2 | gpt-5.3-codex | gpt-5.3-codex | revision loop exhausted | runtime escalation required |
 ## Interpretation Notes
 
 Fallback should be visible in session summaries and used to calibrate future task/model assignment.
diff --git a/Codex/.codex/metrics/leaderboard.md b/Codex/.codex/metrics/leaderboard.md
index ff430c1..896e7de 100644
--- a/Codex/.codex/metrics/leaderboard.md
+++ b/Codex/.codex/metrics/leaderboard.md
@@ -8,6 +8,16 @@
 | Orion | 1 | concise consolidation |
 | Mira | 1 | evidence quality good |
 
+| T5-1 | 1 | local runtime contribution |
+| T4-1 | 2 | local runtime contribution |
+| T3-1 | 1 | local runtime contribution |
+| T2-1 | 2 | local runtime contribution |
+| T1-1 | 3 | local runtime contribution |
+| T5-2 | 1 | local runtime contribution |
+| T4-2 | 2 | local runtime contribution |
+| T3-2 | 1 | local runtime contribution |
+| T2-2 | 2 | local runtime contribution |
+| T1-2 | 3 | local runtime contribution |
 ## Scoring Notes
 
 - completed work increases score
diff --git a/Codex/.codex/metrics/token-usage.md b/Codex/.codex/metrics/token-usage.md
index 78cdd22..01cf4da 100644
--- a/Codex/.codex/metrics/token-usage.md
+++ b/Codex/.codex/metrics/token-usage.md
@@ -7,6 +7,36 @@
 | 2026-05-21 | codex-full-parity | T1 Principal | 6K | 7K | +1K |
 | 2026-05-21 | codex-full-parity | T2 Staff Engineer | 8K | 8K | 0K |
 
+| 2026-05-22 | 2026-05-22T11-10-57Z | T5-1 | 3K | 3K | 0K |
+| 2026-05-22 | 2026-05-22T11-10-57Z | T4-1 | 5K | 5K | 0K |
+| 2026-05-22 | 2026-05-22T11-10-57Z | T3-1 | 4K | 4K | 0K |
+| 2026-05-22 | 2026-05-22T11-10-57Z | T2-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-10-57Z | T1-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-11-13Z | T5-1 | 3K | 3K | 0K |
+| 2026-05-22 | 2026-05-22T11-11-13Z | T4-1 | 5K | 5K | 0K |
+| 2026-05-22 | 2026-05-22T11-11-13Z | T3-1 | 4K | 4K | 0K |
+| 2026-05-22 | 2026-05-22T11-11-13Z | T2-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-11-13Z | T1-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-15-58Z | T5-1 | 3K | 3K | 0K |
+| 2026-05-22 | 2026-05-22T11-15-58Z | T4-1 | 5K | 5K | 0K |
+| 2026-05-22 | 2026-05-22T11-15-58Z | T3-1 | 4K | 4K | 0K |
+| 2026-05-22 | 2026-05-22T11-15-58Z | T2-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-15-58Z | T1-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-31-18Z | T5-1 | 3K | 3K | 0K |
+| 2026-05-22 | 2026-05-22T11-31-18Z | T4-1 | 5K | 5K | 0K |
+| 2026-05-22 | 2026-05-22T11-31-18Z | T3-1 | 4K | 4K | 0K |
+| 2026-05-22 | 2026-05-22T11-31-18Z | T2-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-31-18Z | T1-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T5-1 | 3K | 3K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T5-2 | 3K | 3K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T4-1 | 5K | 5K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T4-2 | 5K | 5K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T3-1 | 4K | 4K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T3-2 | 4K | 4K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T2-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T2-2 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T1-1 | 6K | 6K | 0K |
+| 2026-05-22 | 2026-05-22T11-55-36Z | T1-2 | 6K | 6K | 0K |
 ## Interpretation
 
 Large estimate/actual divergence should inform future task decomposition and model selection.
diff --git a/Codex/.codex/rules/caveman.md b/Codex/.codex/rules/caveman.md
index 6eac890..0097f57 100644
--- a/Codex/.codex/rules/caveman.md
+++ b/Codex/.codex/rules/caveman.md
@@ -1,36 +1,26 @@
-# Caveman Standards
+# Caveman Rule
 
-## 1. Purpose
+## Purpose
 
-Caveman compresses prose output, not reasoning quality.
+Allow compressed operator-facing output without losing correctness.
 
-## 2. Levels
+## Rule
 
-- lite: short but professional
-- full: default compressed style
-- ultra: highly compressed telegraph style
+- if `/caveman` is present, reduce verbosity
+- if `/caveman full` is present, answer with aggressive brevity by default
+- if `/caveman ultra` is present, use telegraph-style compression where safe
+- do not let helpfulness expand the answer beyond the selected compression mode unless safety requires it
 
-## 3. Never Compress
+## Must Preserve
 
-- code blocks
+- commands
+- code
 - file paths
-- identifiers
-- error messages
-- security warnings
-- destructive action confirmations
-- git consent language
+- errors
+-
```

## Staged Diff
```diff
diff --git a/Codex/AGENTS.md b/Codex/AGENTS.md
index 9a1ec09..46a9ef0 100644
--- a/Codex/AGENTS.md
+++ b/Codex/AGENTS.md
@@ -1,52 +1,82 @@
+# Codex Agent Operating Contract
+
+> Canonical operator contract for the Codex multi-agent engineering boilerplate.
+> Date: 2026-05-22
+> Status: Active
+
+This file defines how the Codex structure should behave at the orchestration level.
+It exists because agent role clarity, delegation discipline, review routing, and operating boundaries are core runtime behavior — not optional documentation.
+
 ---
-doc_id: AGENTS
-lang: en
-source_of_truth: true
-version: 2.7.0
-last_updated: 2026-05-21
-sync_group: root-docs
-translation_of: null
-sync_status: canonical
+
+## 1. Purpose
+
+The Codex structure is designed to operate as a disciplined multi-agent engineering system rather than a loose collection of prompts.
+
+This contract defines:
+- tier responsibilities
+- delegation behavior
+- review chain expectations
+- file ownership boundaries
+- fallback visibility
+- context discipline expectations
+- serious-session artifact expectations
+- operator safety rules
+
 ---
 
-# Codex Agent Operating Contract
+## 2. System Summary
 
-This file is the main operating contract for the Codex boilerplate.
+The system is organized around one orchestrating layer and five execution/analysis tiers.
 
-## System Summary
+### Ownership model
+- **Orchestrator** owns user communication, task shaping, decomposition, consolidation, and final reporting.
+- **T1 Principal** owns architecture decisions, top-tier review, and high-risk escalations.
+- **T2 Staff Engineer** owns complex implementation and upper implementation review.
+- **T3 Mid Coder** owns bounded implementation work.
+- **T4 Lead Analyst** owns consolidated analysis and analyst review.
+- **T5 Analyst** owns discovery, evidence gathering, and raw analysis.
 
-- Orchestrator owns user communication, decomposition, and consolidation.
-- T1 / T2 / T3 own implementation and upward review.
-- T4 / T5 own analysis, evidence gathering, and consolidation.
+### Global system truths
 - No agent writes outside its assigned scope.
 - No write-level git action happens without explicit user consent.
-- Session memory and metrics are updated at the end of serious sessions.
+- Review chain is mandatory in multi-agent mode.
+- Fallback events must remain visible.
+- Discovery should precede major implementation on unfamiliar work.
 
-## Serious Session Definition
+---
 
-A session is serious if one or more of the following is true:
-- multi-agent mode was used
-- a feature, refactor, audit, or architecture decision produced meaningful project impact
-- a fallback event occurred
-- a review pass produced actionable findings that should be preserved
-- a resume/handoff/session-summary artifact would help the next operator
+## 3. Default Active Modes
 
-Minimum expected updates after a serious session:
-- `.codex/memory/sessions/` -> session summary or equivalent session record
-- `.codex/memory/resume/` -> resume pointer if continuation is likely
-- `.codex/metrics/` -> fallback, token, or performance updates when applicable
-- `.codex/todo/active-plan.md` -> next actions if work remains open
+Unless explicitly disabled by the operator, these modes are treated as active by default:
+- `/caveman`
+- `/context-mode`
+- `/graphify`
+
+### Practical meaning
+- output should default to compressed operator-efficient form
+- repo exploration should default to context-disciplined narrowing
+- topology-first narrowing should be preferred where dependency complexity makes it useful
+
+### Explicit opt-out examples
+- `context-mode off`
+- `graphify off`
+- `no caveman`
+
+---
 
-## Multi-Agent Activation
+## 4. Multi-Agent Activation
 
 Prompt suffix `xN` activates delegation sizing.
 
-Preferred explicit form:
+### Preferred explicit form
 
 ```text
 /delegate [task] xN
 ```
 
+### Fixed xN distributions
+
 | Mode | T1 | T2 | T3 | T4 | T5 | Total |
 |---|---:|---:|---:|---:|---:|---:|
 | x2 | 1 | 0 | 0 | 0 | 1 | 2 |
@@ -56,7 +86,119 @@ Preferred explicit form:
 | x7 | 1 | 2 | 1 | 1 | 2 | 7 |
 | x10 | 2 | 2 | 2 | 2 | 2 | 10 |
 
-## Global Operating Rules
+### Practical interpretation
+- `x2` -> fast discovery + senior gate
+- `x3` -> small bounded feature
+- `x4` -> medium feature
+- `x5` -> standard production feature
+- `x7` -> strong default for broad work with parallel review/analysis/test pressure
+- `x10` -> migration, audit, or large refactor / broad initiative
+
+---
+
+## 5. Tier Definitions
+
+## Orchestrator
+
+### Responsibility
+- clarify operator intent
+- activate default modes unless disabled
+- decide whether PCD is needed
+- decide whether graph/topology analysis is needed
+- choose or interpret xN scale
+- assign ownership boundaries
+- preserve review and fallback visibility
+- consolidate final output
+
+### Must not
+- silently hide fallback
+- let risky work bypass review chain
+- collapse unresolved concerns into “done” language
+
+---
+
+## T1 Principal
+
+### Responsibility
+- architecture decisions
+- final review on high-risk or integrated work
+- escalation handling for ambiguity or cross-boundary design risk
+- maintainability / contract / failure-mode review
+
+### Typical focus
+- boundaries
+- architectural integrity
+- contract drift
+- long-term maintainability
+- security/failure behavior at the system level
+
+---
+
+## T2 Staff Engineer
+
+### Responsibility
+- complex implementation
+- upper implementation review
+- bounded architecture translation into code-level plans
+- T3 review and correction
+
+### Typical focus
+- correctness
+- validation completeness
+- hidden assumptions
+- integration risk
+
+---
+
+## T3 Mid Coder
+
+### Responsibility
+- bounded implementation
+- focused feature work under review
+- narrow-scope code changes with clear ownership
+
+### Typical focus
+- scoped coding tasks
+- tests where bounded
+- straightforward implementation lanes
+
+---
+
+## T4 Lead Analyst
+
+### Responsibility
+- consolidate T5 research
+- remove duplication and weak evidence
+- produce implementation-useful analysis
+- review raw analyst output
+
+### Typical focus
+- synthesis
+- actionability
+- confidence labeling
+- prioritization of risks and likely affected surfaces
+
+---
+
+## T5 Analyst
+
+### Responsibility
+- repo discovery
+- dependency and module mapping
+- document reading
+- risk extraction
+- test scenario generation
+- raw evidence production
+
+### Typical focus
+- evidence density
+- low speculation
+- source-aware reporting
+- compact discovery handoff
+
+---
+
+## 6. Global Operating Rules
 
 1. discovery before implementation
 2. lowest suitable tier first
@@ -64,15 +206,142 @@ Preferred explicit form:
 4. review chain required in multi-agent mode
 5. fallback and rework must be visible
 6. file ownership must remain unambiguous
+7. default modes remain active unless explicitly disabled
+8. broad reading should be narrowed before expansion
+
+---
 
-## Model and Effort Defaults
+## 7. Review Chain
+
+Canonical upward flow:
+- T5 output reviewed by T4
+- T3 output reviewed by T2
+- T2 output reviewed by T1
+- Orchestrator consolidates and reports
+
+### Review outcomes
+- Approved
+- Revision Required
+- Rejected
+
+### Review contract
+Structured review outputs should use:
+- `.codex/contracts/review-report.md`
+
+### Review expectations
+- findings grouped by severity
+- required fixes listed explicitly
+- residual risks remain visible
+- validation scope must be honest
+
+---
+
+## 8. Serious Session Definition
+
+A session is serious if one or more of the following is true:
+- multi-agent mode was used
+- a feature, refactor, audit, or architecture decision produced meaningful project impact
+- a fallback event occurred
+- a review pass produced actionable findings worth preserving
+- a session generated reusable insights, patterns, or next-step artifacts
+- a resume/handoff/session-summary artifact would materially help the next operator
+
+### Minimum expected updates after a serious session
+- `.codex/memory/sessions/` -> session summary or equivalent session record
+- `.codex/memory/resume/` -> resume pointer if continuation is likely
+- `.codex/metrics/` -> fallback, token, wrapper, or performance updates when applicable
+- `.codex/todo/active-plan.md` -> next actions if work remains open
+
+---
+
+## 9. File Ownership Model
+
+### Root principle
+No agent writes outside explicitly assigned scope.
+
+### Practical ownership expectations
+- Orchestrator -> should not default to writing application code
+- T1 -> writes only where architecture or high-risk correction requires it
+- T2 -> writes owned implementation surfaces
+- T3 -> writes bounded implementation surfaces assigned to it
+- T4 -> analysis/consolidation artifacts only unless explicitly elevated
+- T5 -> raw analysis artifacts only unless explicitly elevated
+
+### Review note
+Parallel writing should be split by boundary, not by arbitrary file count alone.
+
+---
+
+## 10. Context Discipline Model
+
+Because `/context-mode` is default-active, the system should behave as if these are baseline expectations:
+- narrow with search first
+- avoid broad recursive dumping when a smaller read is possible
+- summarize before escalating context volume
+- explicitly note what was intentionally not read yet
+- use Graphify to narrow, not to replace direct evidence
+
+---
+
+## 11. Graphify Model
+
+Because `/graphify` is default-active, the system should prefer topology-first narrowing where useful.
+
+### Expected behavior
+- check graph freshness when possible
+- use hotspot/coupling signals to narrow likely files
+- confirm critical claims against real files
+- degrade gracefully to targeted search when graph data is stale or unavailable
+
+---
+
+## 12. Caveman Model
+
+Because `/caveman` is default-active, operator-facing output should be compact by default.
+
+### Expected behavior
+- direct answer first
+- compressed prose
+- no unnecessary expansion
+- preserve commands, code, paths, warnings, errors, and consent-critical wording exactly
+
+### Stronger modes
+- `/caveman lite`
+- `/caveman full`
+- `/caveman ultra`
+
+If `/caveman full` or `/caveman ultra` is explicitly used, output should become more aggressively compressed.
+
+---
+
+## 13. Model and Effort Defaults
 
 - Orchestrator / T1 -> `gpt-5.4`, high
 - T2 -> `gpt-5.3-codex`, high
 - T3 -> `gpt-5.2`, medium
 - T4 / T5 -> `gpt-5.2`, high
 
-## Supported Commands
+### Model truth note
+Actual model access still depends on the target runtime/account.
+Model strategy is canonical; availability is environment-specific.
+
+---
+
+## 14. Hook and Wrapper Truth
+
+### Hook truth
+Hooks exist under `.codex/hooks/`, but enforcement depends on runtime integration.
+
+### Wrapper truth
+Wrappers improve consistency and make `/context-mode`, `/graphify`, `/delegate`, `/review`, `/pcd`, and `/caveman` team-usable at scale.
+
+### Important caveat
+Wrappers strengthen discipline.
+They do not make the system operator-proof.
+
+---
+
+## 15. Supported Command Modifiers
 
 - `/delegate`
 - `/review`
@@ -86,14 +355,35 @@ Preferred explicit form:
 - `/pcd`
 - `/fallback-status`
 
-## Canonical References
-
-- onboarding: `START_HERE.md`
-- usage: `USAGE.md`
-- quick reference: `ONE_PAGE_QUICKSTART.md`
-- tier/model mapping: `.codex/config/tier-definitions.md`
-- model behavior: `.codex/config/model-registry.md`
-- contracts/checklists: `.codex/contracts/`, `.codex/checklists/`
-- operator runbook: `OPERATIONS_RUNBOOK.md`
-- demo flow: `.codex/demo/end-to-end-x7.md`
-- full documentation: `docs/codex-multi-agent-guide.html`
+---
+
+## 16. Canonical References
+
+Primary operating references now live in:
+- `README.md`
+- `.codex/config/tier-definitions.md`
+- `.codex/config/delegation-rules.md`
+- `.codex/config/model-registry.md`
+- `.codex/instructions/reference/slash-commands.instructions.md`
+- `.codex/instructions/reference/review-chain.instructions.md`
+- `.codex/instructions/reference/project-context-discovery.instructions.md`
+- `.codex/contracts/`
+- `.codex/checklists/`
+- `.codex/docs/runtime-preflight.md`
+- `.codex/docs/system-verification.md`
+- `.codex/docs/team-entrypoint-wrapper.md`
+
+---
+
+## 17. Final Rule
+
+If this structure changes, update:
+- `README.md`
+- `AGENTS.md`
+- any impacted `.codex/config/` source-of-truth docs
+- any impacted `.codex/contracts/`, `.codex/checklists/`, and wrapper references
+
+This file is required because the system needs an explicit operating contract to remain reliable under team usage.
+
+
+<!-- runtime mirror update by T1 -->
diff --git a/Codex/README.md b/Codex/README.md
index 30e2244..b0570de 100644
--- a/Codex/README.md
+++ b/Codex/README.md
@@ -2,8 +2,8 @@
 doc_id: README
 lang: en
 source_of_truth: true
-version: 2.8.0
-last_updated: 2026-05-21
+version: 4.2.0
+last_updated: 2026-05-22
 sync_group: root-docs
 translation_of: null
 sync_status: canonical
@@ -11,53 +11,248 @@ sync_status: canonical
 
 # Codex Multi-Agent Engineering Boilerplate
 
-> v2.8.0 — production-grade, Codex-first, multi-agent engineering boilerplate
+> v4.2.0 — minimal-root, Codex-first, enterprise-grade multi-agent engineering handbook
 
-This package is a team-shareable engineering operating system for multi-agent development, analysis, implementation, review, context discipline, fallback visibility, and rollout governance.
+This repository is intentionally optimized for a **single-document root surface**. The root keeps only this `README.md` as the canonical operator document. All other operational assets live under `.codex/`.
 
-## What This Package Provides
+This is deliberate.
+It reduces:
+- drift
+- duplicated documentation
+- maintenance overhead
+- noisy root-level onboarding
 
-- 5-tier multi-agent architecture
-- `xN` delegation (`x2`, `x3`, `x4`, `x5`, `x7`, `x10`)
-- Codex-first model strategy
-- Project Context Discovery (PCD)
-- Context Mode / context-efficiency discipline
-- Caveman compressed-output mode
-- Graphify / topology-first discovery
-- review chain, file ownership, escalation, and fallback visibility
-- skills, rules, hooks, templates, contracts, checklists
-- session memory, learned patterns, metrics, leaderboard
-- onboarding, runbook, release, audit, and validation documentation
-- detailed HTML documentation for beginner and advanced users
+It improves:
+- source-of-truth clarity
+- operator consistency
+- long-term package maintainability
 
-## Read This First
+---
+
+
+## Handbook Positioning
+
+This README is intentionally written as the **single root handbook** for the package.
+
+It is meant to serve four audiences:
+- individual contributors
+- team leads
+- reviewers
+- rollout owners
+
+Its purpose is to explain:
+- what the system is
+- how it behaves by default
+- where the real operational assets live
+- how the team should use it safely and consistently
+
+---
+
+## Executive Summary
+
+This package is a structured operating system for serious engineering work with:
+- multi-agent delegation
+- tiered review
+- project context discovery
+- context-discipline by default
+- topology-first narrowing by default
+- compressed output by default
+- hook-assisted safety
+- contracts, checklists, memory, and metrics
+
+The current operating baseline is:
+- `/caveman` -> default-on
+- `/context-mode` -> default-on
+- `/graphify` -> default-on
+
+And the current scaling control is:
+- `xN` -> agent scale selector
+
+So a short prompt like:
+
+```text
+Auth feature x10
+```
+
+should be interpreted operationally closer to:
+
+```text
+/context-mode /graphify /caveman Auth feature x10
+```
+
+unless one of those modes is explicitly disabled.
+
+---
+
+## Deep Analysis Result
+
+After multiple review/fix cycles, the package is strongest in these areas:
 
-1. `START_HERE.md` — fastest onboarding path
-2. `AGENTS.md` — operating contract
-3. `USAGE.md` — operator guide and workflow examples
-4. `ONE_PAGE_QUICKSTART.md` — condensed quick reference
-5. `OPERATIONS_RUNBOOK.md` — runtime and rollout model
-6. `INDEX.md` — package map
-7. `docs/codex-multi-agent-guide.html` — full guided documentation
+### Strong parts
+- clean separation between root entrypoint and internal operating system
+- explicit multi-agent tier model
+- explicit review chain
+- explicit PCD model
+- explicit hook registry and runtime caveats
+- wrapper-based team entrypoints
+- usage logging and reporting for team wrapper behavior
+- restricted-runtime resilience for advisory persistence hooks
 
-## Beginner Path
+### Remaining truth-based caveats
+These are not defects; they are environment-dependent realities:
+- model availability depends on the target runtime/account
+- hook enforcement strength depends on wrapper/CI adoption
+- Graphify quality depends on graph artifact freshness/availability
+- wrappers improve discipline, but cannot replace operator misuse-proofing completely
 
-- read `START_HERE.md`
-- copy one prompt from `ONE_PAGE_QUICKSTART.md`
-- run `/pcd` before broad work on an unfamiliar repo
-- use `/delegate ... x5` for a normal production feature
-- use `/review` before closure
+### Design conclusion
+The highest-value improvement was simplifying the root to one canonical README and moving everything else into `.codex/`.
+That makes the structure more stable and less drift-prone.
 
-## Advanced / Operator Path
+---
+
+## Root Policy
+
+At the root level, keep only:
+- `README.md`
+
+Everything else belongs in `.codex/`.
+
+This rule should remain stable unless there is a strong reason to reintroduce a broader public root surface.
+
+---
+
+## Performance Evaluation Table
+
+### Scenario: medium production task (discovery + implementation + review)
+
+| Metric | Without This System | With Codex Multi-Agent Structure (`x5`/`x10`) | Practical Effect |
+|--------|---------------------|-----------------------------------------------|------------------|
+| **Task decomposition** | single-threaded reasoning | tiered role-based split | clearer ownership and less role confusion |
+| **Context usage** | one expanding context | narrowed per-stage/per-role context | lower overload risk |
+| **Review quality** | self-review or shallow pass | T5→T4 and T3→T2→T1 chain | stronger defect detection |
+| **Discovery quality** | ad hoc file reading | PCD + Context Mode + Graphify narrowing | less brute-force scanning |
+| **Runtime safety** | easy to drift or overread | hooks, wrappers, and contracts constrain flow | safer default behavior |
+| **Fallback visibility** | often implicit | explicit fallback expectations | better auditability |
+| **Operational memory** | weak persistence | memory, metrics, and patterns | stronger continuity |
+| **Scalability** | weak on broad tasks | `xN` scaling and wave-based handling | better serious-task throughput |
+| **Maintenance burden** | lower at start, higher later | higher setup, lower long-term drift | better long-term structure |
+
+### Practical Efficiency Table
+
+| Area | Baseline Single-Agent Style | Codex Multi-Agent Style | Net Effect |
+|------|-----------------------------|--------------------------|-----------|
+| **Token efficiency** | broad/noisy context growth | query-first and tier-scoped use | better large-task efficiency |
+| **Reading behavior** | too many files too early | disciplined narrowing | less waste |
+| **Parallelism** | limited | xN-driven decomposition | faster serious-task movement |
+| **Governance overhead** | low | moderate | worthwhile on medium/high-risk work |
+| **Best fit** | tiny or throwaway work | serious product engineering | stronger quality/traceability |
+
+### Interpretation
+- tiny task -> simpler systems may feel faster
+- medium/large task -> this structure is safer and more governable
+- high-risk work -> the review chain and context discipline become especially valuable
 
-- read `OPERATIONS_RUNBOOK.md`
-- review `.codex/config/delegation-rules.md`
-- review `.
```

