# Getting Started — Cursor Multi-Agent

## 1. Install once

```bash
Cursor/.cursor/scripts/setup.sh /your/project
```

## 2. Use in Cursor chat (no terminal)

Write tasks in natural language.

### Automatic multi-agent

Add **xN** anywhere in the prompt:

```
payment service x5
x3 fix login bug
pcd onboarding flow x7
```

The IDE hook builds the spawn manifest; the Orchestrator runs Task subagents in order.

### Keywords (no slash, no bin)

| Write | Gets |
|-------|------|
| `pcd …` | Project context discovery first |
| `caveman …` | Short answers |
| `graphify …` | Topology-first search |
| `ctx …` or `context-mode …` | Context discipline |
| `review …` | Review-first |
| `architect …` | Architecture focus |

Combine freely: `pcd graphify api audit x10`

### Turn off defaults

`no caveman` · `graphify off` · `context-mode off`

## 3. What you should not need

- `bin/team`, `bin/ctx` — maintainer tools only
- `/delegate`, `/pcd` — legacy; plain words work

## 4. Verify install (optional)

```bash
Cursor/bin/verify
```
