# Team Entrypoint Wrapper

## Purpose

Provide one standard team-facing entrypoint for common operating modes:
- PCD
- Context Mode
- Graphify
- Delegate
- Review
- Caveman

## Preferred Team Command

```bash
./bin/team <mode> "<prompt>"
```

## Supported Modes

- `pcd`
- `context`
- `graphify`
- `delegate`
- `review`
- `caveman`

## Examples

```bash
./bin/team pcd "analyze this repo"
./bin/team context "analyze auth flow and keep reads minimal"
./bin/team graphify "map notification hotspots"
./bin/team delegate "build notification preferences x5"
./bin/team review "check latest changes for risk"
./bin/team caveman "full /status"
```

## What It Adds

- one shared team entrypoint
- repeatable preflight behavior
- lower operator inconsistency
- usage logging when writable
- delegate prompt linting for missing `xN`
- optional strict mode for delegate prompts
- mode counts under `.codex/metrics/wrapper-mode-counts.md`

## Logging

When writable, wrapper usage is appended to:
- `.codex/logs/wrapper-usage.log`

## Reporting Scripts

```bash
./bin/team-report
./bin/team-report --markdown
python3 .codex/scripts/wrapper_usage_trend_analyzer.py
```

## Strict Mode

Enable strict delegate enforcement:

```bash
CODEX_STRICT_DELEGATE=1 ./bin/team delegate "build notification preferences"
```

In strict mode, missing `xN` becomes a blocking error.
