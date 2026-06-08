# Hook Registry

## Runtime Positioning

This repository ships hook scripts as reusable enforcement assets.

Important:
- hooks are not assumed to be auto-wired in every environment
- teams may run them through wrapper scripts, local guards, or CI
- each team should explicitly decide which hooks are blocking vs advisory

## Hook Lifecycle Table

| Hook | Purpose | Typical Trigger Point | Default Posture | Surface |
|---|---|---|---|---|
| `git-safety-check.sh` | Blocks write-level git actions without explicit consent | before git write actions | blocking | wrapper / local guard / CI |
| `context-mode-guard.sh` | Warns or blocks large-output / exfiltration-prone patterns | before wide scans or risky reads | advisory | wrapper / local guard |
| `secret-guard.sh` | Detects likely hardcoded secrets | before commit/review/CI | blocking | local guard / CI |
| `review-tracker.sh` | Tracks edit churn and repeated revisions | post-edit / pre-review | advisory | wrapper / CI |
| `self-learning-collector.sh` | Captures repeated rework into learned patterns | post-task | advisory | wrapper / CI |
| `graphify-audit.sh` | Warns about stale/aged graph artifacts | pre-graphify / pre-analysis | advisory | wrapper / local guard |
| `update-leaderboard.sh` | Records leaderboard refresh placeholder | post-task / scheduled | advisory | wrapper / CI |
| `block-any-type.sh` | Blocks `any`, `@ts-ignore`, `@ts-expect-error` | pre-commit / CI | blocking | local guard / CI |
| `block-comments.sh` | Blocks TODO/FIXME-like debt or comment noise | pre-commit / CI | blocking or advisory by team choice | local guard / CI |
| `block-console-log.sh` | Blocks console/debug dialog usage | pre-commit / CI | blocking | local guard / CI |
| `sql-injection-check.sh` | Flags likely SQL string concatenation | pre-review / CI | blocking | local guard / CI |
| `xss-prevention-check.sh` | Blocks dangerous HTML/eval patterns | pre-review / CI | blocking | local guard / CI |
| `path-traversal-check.sh` | Flags unsafe path composition | pre-review / CI | blocking | local guard / CI |
| `cors-wildcard-check.sh` | Blocks wildcard CORS patterns | pre-review / CI | blocking | local guard / CI |
| `field-injection-check.sh` | Blocks field injection patterns | pre-review / CI | blocking | local guard / CI |
| `analysis-scope-guard.sh` | Enforces analysis write-scope boundaries | during analysis-tier writes | blocking | wrapper / local guard |
| `graphify-rebuild.sh` | Marks graph stale when source files change | post-edit / scheduled | advisory | wrapper / CI |
| `pattern-lifecycle.sh` | Archives or rotates low-signal learned patterns | scheduled maintenance | advisory | CI / scheduled job |

## Integration Modes

1. wrapper-script preflight/postflight
2. local developer guard scripts
3. CI validation stage

## Recommended Default

- treat security and git-consent hooks as blocking
- treat context, graph, metrics, and pattern hooks as advisory until the team matures
- promote advisory hooks to blocking only when the workflow is proven stable
