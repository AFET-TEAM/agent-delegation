# Prompt Keywords Reference (replaces slash-only UX)

## Purpose

Operators use **plain keywords** in Cursor chat. No `bin/` CLI and no leading `/` required.

## Multi-Agent (automatic)

If the prompt contains `x2`, `x3`, `x4`, `x5`, `x7`, or `x10`:

- Multi-agent mode activates automatically
- `beforeSubmitPrompt` runs `prompt-router.py` → `orchestrate.py --plan-only`
- Orchestrator spawns Task subagents from `spawn-packets/` in manifest order

Examples:

- `Auth feature x5`
- `Large refactor x10`
- `pcd payment module x3`

## Keyword Modifiers

| Keyword | Effect |
|---------|--------|
| `pcd` | Project context discovery before implementation |
| `caveman` | Compressed user-facing prose |
| `caveman lite` / `full` / `ultra` | Compression severity |
| `graphify` | Topology-first narrowing |
| `context-mode` or `ctx` | Strict context discipline |
| `review` | Review-first workflow |
| `architect` | Architecture-first (T1) |

## Opt-Out

- `no caveman`, `stop caveman`, `normal mode`
- `context-mode off`
- `graphify off`

## Default Baseline

Unless opted out: caveman + context-mode + graphify are active.

## Legacy (do not recommend to users)

- `/delegate`, `/pcd`, `bin/team` — still understood but unnecessary
