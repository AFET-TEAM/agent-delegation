# Hook Registry

Complete cross-reference of all enforcement and metric-tracking hooks.

## PreToolUse:Edit/Write/MultiEdit

| Hook | Purpose | Rules Enforced |
|------|---------|----------------|
| block-any-type.sh | Block TypeScript `any` type and @ts-ignore | clean-code.md §Absolute Prohibitions |
| block-comments.sh | Block inline comments and TODO/FIXME | clean-code.md §Absolute Prohibitions |
| block-console-log.sh | Block console.* and alert/confirm/prompt | clean-code.md §Absolute Prohibitions |
| secret-guard.sh | Block hardcoded credentials and API keys | backend-security.md §Password Security |
| analysis-scope-guard.sh | Advisory for analysis/raw and analysis/consolidated; block analysis/ root | CLAUDE.md §File Ownership Rules |
| figma-standards-guard.sh | Block inline styles, hardcoded colors, non-semantic HTML, px units, AntD mapping | react-patterns.md §Figma Standards |
| sql-injection-check.sh | Detect SQL string concatenation | backend-security.md §SQL Injection Prevention |
| xss-prevention-check.sh | Block innerHTML, dangerouslySetInnerHTML, eval | backend-security.md §XSS Prevention |
| path-traversal-check.sh | Detect unsanitized file path operations | backend-security.md §Path Traversal Prevention |
| cors-wildcard-check.sh | Block CORS wildcard origin | backend-security.md §CORS |
| field-injection-check.sh | Prevent @Autowired field injection | backend-development.md §Dependency Injection |

## PreToolUse:Bash

| Hook | Purpose | Rules Enforced |
|------|---------|----------------|
| git-safety-check.sh | Block destructive/write git ops without consent | git-safety.md §Consent Requirement |
| context-mode-guard.sh | Block exfiltration tools and sensitive path access; advise on large-output commands | context-mode-usage.md §Mandatory Routing Rules |

## PostToolUse:Edit/Write/MultiEdit

| Hook | Purpose | Writes To |
|------|---------|-----------|
| review-tracker.sh | Count edits per file; alert at 5 and 10 | .claude/metrics/edit-counts.log |
| self-learning-collector.sh | Record repeated edits as learned patterns | .claude/memory/learned-patterns/ |
| graphify-rebuild.sh | Mark graphify graph as stale when source files change | graphify-out/.graphify-stale (in analyzed codebase) |

## SessionEnd

| Hook | Purpose | Writes To | Order |
|------|---------|-----------|-------|
| update-leaderboard.sh | Apply scoring deltas from session to leaderboard | .claude/metrics/leaderboard.md, .claude/config/name-pool.md, .claude/metrics/.session-complete (sentinel) | 1 |
| pattern-lifecycle.sh | Scan patterns; increment hit-count; promote at 3+ hits; archive at 5+ sessions without hit | .claude/memory/learned-patterns/, .claude/rules/learned-*.md, .claude/memory/learned-patterns/archive/ | 2 (waits for sentinel) |
| graphify-audit.sh | Warn if graphify graph is stale or >7 days old at session end | graphify-usage.md §Stale Marker Protocol | 3 (after pattern-lifecycle.sh) |

## Dependencies

- `jq` (recommended): Most PreToolUse hooks use conditional jq with grep+sed fallback
- `awk`: update-leaderboard.sh uses awk for table parsing
- `flock`: update-leaderboard.sh uses flock for atomic file updates

## Total Hook Count: 19

11 PreToolUse:Edit/Write + 2 PreToolUse:Bash + 3 PostToolUse:Edit/Write + 3 SessionEnd = 19 hooks.

Note: graphify-rebuild.sh enforces the stale marker protocol defined in `.claude/rules/graphify-usage.md`. It is non-blocking (always exits 0) and only writes a `.graphify-stale` marker file when a source file in a codebase containing a `graphify-out/` directory is edited.
