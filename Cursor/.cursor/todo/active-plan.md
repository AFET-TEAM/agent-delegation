# Active Plan — Cursor Boilerplate v1.0.0

## Completed

- Cursor/ package scaffold (AGENTS.md, README.md, .cursor/)
- Port Codex rules, skills (21), agents, config, contracts, instructions
- Cursor-native hooks.json + adapter scripts
- Runtime spawn-packets (--plan-only) for Task delegation
- bin/team, bin/ctx, bin/verify, wrappers, setup.sh
- Default-on caveman/context-mode/graphify rules (.mdc)
- verify-install pass (35 checks)

## Pending (Cycle 2)

- Host monorepo: run `setup.sh` on mayacore-mfe-context root for live hooks
- parity_validator three-way diff automation in CI
- Richer subagentStop manifest parsing with wave boundaries
- Optional Cursor SDK integration for programmatic Task spawn
- Graphify CLI install step in setup when network available

## Resume

```bash
cd Cursor && ./bin/team delegate "your task x5"
```

Then spawn Task subagents from latest `runs/*/spawn-packets/`.
