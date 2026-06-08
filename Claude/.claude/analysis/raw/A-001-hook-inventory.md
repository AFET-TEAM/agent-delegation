---
analysis-id: A-001
author: Ayse Demir (T5-A Analyst, sonnet escalation)
model: sonnet (escalated from haiku after 2 revision rounds)
created: 2026-04-22
reviewer: Canan Birsen (T4-A Lead Analyst)
status: draft
---

# A-001: Hook Script Inventory

## Summary

Inventory of 14 shell hook scripts in `.claude/hooks/`. Total 634 lines. All 14 use `set -euo pipefail`. None use `jq` (all use sed/grep for JSON extraction — flagged P2). 13/14 validate `$CLAUDE_PROJECT_DIR`. 3 bugs fixed this session (I-101 git-safety exit code, I-102 analysis-scope tier names, I-102b analysis-scope advisory behavior).

## Inventory Table

| # | File | Lines | Purpose | Trigger | Safety | jq | Env Valid |
|---|------|-------|---------|---------|--------|-----|-----------|
| 1 | block-any-type.sh | 42 | Prevent TypeScript `any` type and `@ts-ignore` | PreToolUse:Edit/Write | Yes | No | Yes |
| 2 | block-comments.sh | 61 | Block inline comments and TODO/FIXME/HACK/XXX | PreToolUse:Edit/Write | Yes | No | Yes |
| 3 | block-console-log.sh | 42 | Block console.* and alert/confirm/prompt | PreToolUse:Edit/Write | Yes | No | Yes |
| 4 | secret-guard.sh | 66 | Prevent hardcoded credentials and API keys | PreToolUse:Edit/Write | Yes | No | Yes |
| 5 | sql-injection-check.sh | 40 | Detect SQL string concatenation | PreToolUse:Edit/Write | Yes | No | Yes |
| 6 | xss-prevention-check.sh | 50 | Block innerHTML, dangerouslySetInnerHTML, eval | PreToolUse:Edit/Write | Yes | No | Yes |
| 7 | path-traversal-check.sh | 35 | Detect unsanitized file path operations | PreToolUse:Edit/Write | Yes | No | Yes |
| 8 | cors-wildcard-check.sh | 25 | Block wildcard CORS origin | PreToolUse:Edit/Write | Yes | No | Yes |
| 9 | field-injection-check.sh | 25 | Prevent Spring @Autowired field injection | PreToolUse:Edit/Write | Yes | No | Yes |
| 10 | figma-standards-guard.sh | 49 | Block inline styles, hardcoded colors, non-semantic HTML | PreToolUse:Edit/Write | Yes | No | Yes |
| 11 | review-tracker.sh | 47 | Count edits; alert at 5 and 10 thresholds | PostToolUse:Edit/Write | Yes | No | Yes |
| 12 | self-learning-collector.sh | 70 | Record repeated edits as learned patterns (Turkish content) | PostToolUse:Edit/Write | Yes | No | Partial |
| 13 | git-safety-check.sh | 33 | Block destructive git without consent (FIXED: exit 0→2 for commit/add) | PreToolUse:Bash | Yes | No | Yes |
| 14 | analysis-scope-guard.sh | 31 | Advisory for analysis/raw and analysis/consolidated; block for analysis/ root (FIXED: tier names + advisory exit codes) | PreToolUse:Edit/Write | Yes | No | Yes |

## Observations

- **Languages**: 13 English, 1 Mixed (self-learning-collector.sh lines 53-60 contain Turkish pattern template content)
- **jq adoption**: 0/14 — all hooks use fragile grep+sed JSON extraction (P2 issue, scheduled for I-103 rewrite)
- **Env validation**: 13/14 — self-learning-collector.sh has partial validation
- **Safety compliance**: 14/14 `set -euo pipefail`
- **Hook registration**: 11 on PreToolUse:Edit/Write/MultiEdit, 1 on PreToolUse:Bash, 2 on PostToolUse:Edit/Write, 0 on SessionEnd (WP-2 will add 2 new SessionEnd hooks)

## Fixed This Session

- `git-safety-check.sh:29` — Changed `exit 0` to `exit 2` for commit/add/tag operations (I-101)
- `analysis-scope-guard.sh:17,21,25` — Tier labels T3→T5, T2.5→T4; prefixes INFO/WARNING → BLOCKED (I-102)
- `analysis-scope-guard.sh:17,21` — Exit codes changed to advisory (exit 0); messages updated (I-102b, authorized by user direct-text consent)

## Still-Open Issues

- **All 14 hooks**: migrate JSON parsing from grep+sed to jq with conditional fallback if jq unavailable (P2, I-103)
- **self-learning-collector.sh**: translate Turkish pattern template content to English (P2, I-203)
- **figma-standards-guard.sh**: extend to cover 4 missing Figma rules (px→rem, AntD mapping, typography tokens, PascalCase) + .ts extension (P1, I-104)
- **New hooks needed**: `update-leaderboard.sh` and `pattern-lifecycle.sh` for SessionEnd (P0, I-201/I-202)
- **Metrics tracking rule**: no rule file documents review-tracker.sh and self-learning-collector.sh (P1, I-206)

## References

- /Users/tcvmaksutoglu/Dev/w/claude-code-saka/CLAUDE.md (Hook Layer, line 161)
- /Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/settings.json (hook registrations, lines 38-128)
- /Users/tcvmaksutoglu/Dev/w/claude-code-saka/.claude/analysis/consolidated/C-001-refactor-spec.md (pending T4-A synthesis)
