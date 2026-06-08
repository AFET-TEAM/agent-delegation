# Metrics Tracking Standards

## Purpose

This rule documents how the multi-agent system tracks metrics, learns from sessions, and maintains agent performance data. Four hooks collaborate to implement the self-learning loop.

## Hook Responsibilities

### review-tracker.sh (PostToolUse:Edit/Write/MultiEdit)

Counts edits per file across a session.

- Increments a counter at `.claude/metrics/edit-counts.log` for each Edit/Write/MultiEdit on source files
- Emits warnings at 5 and 10 edits per file
- Writes per-edit log entries to `.claude/metrics/.session-edits-YYYYMMDD.log` (format: `timestamp|count|filepath`)

### self-learning-collector.sh (PostToolUse:Edit/Write/MultiEdit)

Detects repeated edit cycles and creates learned pattern files.

- Threshold: 2+ edits to the same file in a session
- Generates a pattern file at `.claude/memory/learned-patterns/<pattern-id>.md` using the template (English sections: Error, Fix, Rule, Context)
- Initial frontmatter: `hit-count: 0`, `last-triggered: null`, `sessions-since-hit: 0`

### update-leaderboard.sh (SessionEnd)

Applies scoring deltas from the session to agent name scores.

- Reads the latest session file in `.claude/memory/sessions/`
- Parses "Agent Performance" table
- Computes score deltas per `.claude/config/name-pool.md` Scoring Rules:
  - Task completed: +5
  - Task failed: −5
  - Code review first-pass: +3
  - Review second-pass: +1
  - Review 3+ rounds: −3
  - Found P0/P1 issue: +4 (when annotated)
  - False positive: −2 (when annotated)
  - Unnecessary escalation: −2
  - Model fallback: −1
- Updates `.claude/metrics/leaderboard.md` (score column and session-end summary table)
- Updates `.claude/config/name-pool.md` (score column)
- Uses `flock` on `.claude/metrics/.leaderboard.lock` for atomic writes
- Temp-file + `mv` pattern (atomic on same filesystem)
- Emits sentinel file `.claude/metrics/.session-complete` upon completion

### pattern-lifecycle.sh (SessionEnd)

Triggers pattern promotion and archival.

- Waits up to 5 seconds for `.claude/metrics/.session-complete` sentinel (then proceeds regardless)
- Iterates all patterns in `.claude/memory/learned-patterns/*.md` (excluding `_pattern-template.md` and `archive/`)
- For each pattern: greps session content against Error/Hata section keywords; if match increments `hit-count`, resets `sessions-since-hit`
- Otherwise: increments `sessions-since-hit`
- Promotion: at `hit-count >= 3`, appends pattern content to `.claude/rules/learned-{category}.md` with a unique marker `<!-- pattern: filename -->` to prevent duplicate appends
- Archival: at `sessions-since-hit >= 5 AND hit-count == 0`, moves pattern to `.claude/memory/learned-patterns/archive/`

## Invariants

- Learned patterns are never deleted — archived patterns remain recoverable in `archive/`
- Pattern promotion goes to namespaced `learned-{category}.md` files, never modifying canonical rule files (prevents clobbering human-written rules)
- Scoring is idempotent at the session level — `update-leaderboard.sh` uses `flock` to prevent concurrent runs corrupting files
- Turkish/legacy pattern files are supported by both `Error` and `Hata` section headers during lifecycle transition

## Tier Responsibilities

| Tier | Updates | Reads |
|------|---------|-------|
| Orchestrator | session file, active-plan.md | all metrics at session start |
| T1-T5 | own agent outputs | learned-patterns, leaderboard at spawn |

## Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| All leaderboard scores remain 0 | `update-leaderboard.sh` not wired in settings.json SessionEnd | Re-verify settings.json |
| Pattern hit-count never increments | pattern-lifecycle.sh not reading session file | Check sentinel emission in update-leaderboard.sh |
| Promotion file `learned-*.md` overwrites rule | Should not happen — uses marker | Check marker syntax in pattern-lifecycle.sh |

## References

- CLAUDE.md §Self-Learning Protocol
- `.claude/config/hook-registry.md`
- `.claude/config/name-pool.md`
