---
analysis-id: C-001
author: Canan Birsen (T4-A Lead Analyst)
model: haiku
created: 2026-04-22
reviewers: T1-A Taner Yilmaz, T1-B Oya Kanat
status: draft
sources: [A-001, A-002]
---

# C-001: Refactor Specification (Consolidated)

## Purpose
This document consolidates A-001 (hook inventory) and A-002 (template/rule audit) into actionable specifications for all Wave 3+ implementation agents.

## Summary of Findings

### Hooks (from A-001)
- 14 hooks, 634 lines total
- 14/14 use `set -euo pipefail` ✓
- 0/14 use `jq` — all grep+sed JSON parsing (P2 refactor target)
- 13/14 validate `$CLAUDE_PROJECT_DIR`
- 3 bugs fixed in Wave 2 prep: I-101 (git-safety exit code), I-102 (analysis-scope tier names), I-102b (analysis-scope advisory behavior)

### Templates & Rules (from A-002)
- 7 agent templates, 15 rule files, 6 config files audited
- 0/5 agent templates have Escalation Seed reference or Learned Patterns marker (P1 fix in I-501-I-503)
- 2/15 rule files mention hooks explicitly (backend-security.md missing — P1 fix in I-601)
- 0/6 config files are machine-readable JSON (context-budget.json needed — P1 in I-603)
- 20/22 files mix Turkish/English; standardize to English (P2)

## Implementation Contract for Wave 3 Agents

### T2-A (Baris Benli) — Security Hooks (I-103, I-104)
For each of 8 security hooks (block-any-type, block-comments, block-console-log, secret-guard, sql-injection-check, xss-prevention-check, path-traversal-check, cors-wildcard-check, field-injection-check):
1. Migrate JSON extraction from grep+sed to jq with fallback: `if command -v jq >/dev/null 2>&1; then FILE_PATH=$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<<"$INPUT"); else FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//'); fi`
2. Validate `$CLAUDE_PROJECT_DIR` at top: `: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"`
3. Ensure all user-facing messages are English (most already are)
4. Tighten regexes where noted (insertAdjacentHTML, path URL-encoded, cors unquoted, block-comments string false-positive)

I-104: figma-standards-guard.sh — add 4 checks (px→rem, Ant Design mapping, typography tokens, PascalCase frame names); extend trigger to `*.ts` (but skip files without antd/figma token imports)

### T2-B (Tarik Ziya Yesilcimen) — Self-Learning Automation (I-201-I-204)
- I-201 NEW `update-leaderboard.sh`: SessionEnd hook; parses latest session file; applies scoring deltas per name-pool.md rules; updates leaderboard.md and name-pool.md score columns atomically (flock); uses jq for data
- I-202 NEW `pattern-lifecycle.sh`: SessionEnd hook; scans learned-patterns/*.md; increments hit-count based on session content match; promotes to `.claude/rules/learned-{category}.md` at 3+ hits; archives to `.claude/memory/learned-patterns/archive/` at 0 hits across 5 sessions
- I-203 `self-learning-collector.sh`: translate Turkish pattern template to English; add hit-count/last-triggered/sessions-since-hit fields; add jq fallback
- I-204 `review-tracker.sh`: keep logic; translate any messages; add env validation; emit session marker

### T3-A (Enis Sait Erken) — Agent Templates + Name Pool (I-501, I-502, I-503, I-701, I-801)
- I-501 `_shared-sections.md`: add "Escalation Protocol" section referencing CLAUDE.md:99-109 format; add `<!-- INSERT_LEARNED_PATTERNS_HERE -->` marker
- I-502: copy marker propagation to 5 agent templates (analyst, lead-analyst, mid-coder, staff-engineer, principal)
- I-503 `orchestrator.md`: add "Agent Spawning Template" section with pseudo-code showing learned-patterns injection at spawn time
- I-701 `name-pool.md`: correct typo "Yaren Eylul Dokmec" → "Yaren Eylul Dokmez" (matches leaderboard.md); add initial-score note; tier-multiplier score mapping
- I-801 NEW `_session-template.md`: mirror CLAUDE.md Step 6 performance report format (Summary, Agent Performance table, Token Usage table, Learned Patterns, Changes)

### T3-B (Selin Akar) — Rules, Config, Metrics, Templates (I-601, I-602, I-603, I-604, I-702, I-703, I-802, I-803)
- I-601 `backend-security.md`: add "Enforcement Hooks" sub-sections cross-referencing 5 hooks (sql-injection, xss-prevention, path-traversal, cors-wildcard, field-injection) by filename
- I-602 `react-patterns.md`: annotate each rule with `[HOOK]` or `[REVIEW]` tag
- I-603 NEW `context-budget.json`: machine-readable budget with per-tier max_skills, max_files, max_tokens
- I-604 NEW `hook-registry.md`: table of every hook → trigger event → files matched → rules enforced (16 hooks after WP-2 additions)
- I-702 `model-registry.md`: add explicit fallback chain opus→sonnet→haiku with escalation log
- I-703 metrics cleanup: remove old tier references (T1.5, T2.5) from agent-performance.md and token-usage.md; add English headers
- I-802 `_pattern-template.md`: translate Turkish to English, add hit-count/last-triggered/sessions-since-hit fields
- I-803 `session-2026-04-18-cycle4.md` + `history/archive.md`: translate headers only (preserve historical content as audit trail)

### T1-A (Taner Yilmaz) — Coordination (I-205, I-206, I-901)
- I-205 `settings.json`: wire `update-leaderboard.sh` and `pattern-lifecycle.sh` as SessionEnd hooks
- I-206 NEW `metrics-tracking.md` rule: document review-tracker and self-learning-collector responsibilities
- I-901 `CLAUDE.md`: clarify revision counter reset (resets only on full reassignment after ❌); add Performance Report template; add archive policy under Self-Learning Protocol; spec SessionEnd hook invocation in Step 6

### T1-B (Oya Kanat) — Review-Only
Cross-consistency audit after all above complete.

## Risk Mitigations Carried Over from Plan
1. jq dependency → conditional fallback in every hook
2. SessionEnd hook ordering → sentinel file `.claude/metrics/.session-complete`
3. Leaderboard atomic update → flock + temp + mv
4. Pattern promotion overwrite → namespace `.claude/rules/learned-{category}.md`
5. Translation drift → headers only, historical content preserved

## Acceptance Gate
After all Wave 3/4 work, T1-B verifies:
- No old tier references (T1.5, T2.5, T3 Analyst) outside archive files
- All 16 hooks run cleanly with `bash -n`
- `context-budget.json` valid JSON
- `hook-registry.md` lists all hooks
- Test session produces leaderboard delta

## References
- Plan: /Users/tcvmaksutoglu/.claude-corp/claude-config/plans/yap-y-derinlemesine-analiz-et-polished-hearth.md
- A-001: ../raw/A-001-hook-inventory.md
- A-002: ../raw/A-002-template-rule-audit.md
