# Multi-Agent AI Development Framework

Enterprise-grade, multi-platform AI agent orchestration system for software development teams. Provides unified configuration templates for **Claude Code**, **GitHub Copilot**, and **OpenAI Codex** with shared architecture patterns.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Orchestrator (T0)                      │
│         Coordination · Delegation · Review Gate          │
├──────────┬──────────┬──────────┬──────────┬─────────────┤
│ T1       │ T2       │ T3       │ T4       │ T5          │
│Principal │Staff Eng │MidCoder  │Lead Anl. │Analyst      │
│Arch+Rev  │Features  │Standard  │Consolidate│Raw Research │
└──────────┴──────────┴──────────┴──────────┴─────────────┘
```

## Platform Support

| Platform | Directory | Config Format | Status |
|----------|-----------|---------------|--------|
| Claude Code | `Claude/` | CLAUDE.md + .claude/ | ✅ Production |
| GitHub Copilot | `Copilot/` | .github/ agents + instructions | ✅ Production |
| OpenAI Codex | `Codex/` | .codex/ | ✅ Production |

## Key Features

- **5-Tier Agent Hierarchy** — Principal → Staff → Mid → Lead Analyst → Analyst
- **xN Delegation** — Dynamic workload distribution (x2 through x10)
- **Review Chain** — Mandatory cross-tier review with quality gates
- **19 Security Hooks** — Pre/Post tool-use and session-end guards
- **Skills System** — Domain-specific capabilities (caveman, context-mode, graphify, etc.)
- **Context Efficiency** — Token budget management and progressive disclosure
- **Memory & Learning** — Session history, learned patterns, knowledge graphs
- **Metrics & Leaderboard** — Agent performance tracking and scoring

## Quick Start

### For Claude Code Users
```bash
cp -r Claude/.claude /your-project/
cp Claude/CLAUDE.md /your-project/
```

### For GitHub Copilot Users
```bash
cp -r Copilot/.github /your-project/
cp -r Copilot/.vscode /your-project/
```

### For OpenAI Codex Users
```bash
cp -r Codex/.codex /your-project/
```

## Slash Commands

| Command | Description |
|---------|-------------|
| `/context-mode` | Enable context-efficient operation |
| `/caveman` | Minimal token output mode |
| `/graphify` | Build/query knowledge graphs |
| `/x2` — `/x10` | Delegation multiplier |
| `/review` | Trigger review chain |
| `/plan` | Create structured task plan |

## Documentation

- **Full HTML Documentation**: `docs/index.html`
- **Claude Guide**: `Claude/README.md`
- **Copilot Guide**: `Copilot/README.md` + `Copilot/USAGE.md`
- **Codex Guide**: `Codex/README.md` + `Codex/START_HERE.md`

## Contributing

1. Changes to shared architecture must be reflected in all 3 platforms
2. New hooks must be registered in the respective config files
3. Skills must follow the `SKILL.md` template format
4. All PRs require cross-platform consistency check

## License

Internal — Turkcell Digital
