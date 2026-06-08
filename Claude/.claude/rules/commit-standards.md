# Commit Standards

## Commit Types

| Type | Usage |
|---|---|
| `feat` | New feature |
| `feat!` | Breaking change |
| `fix` | Bug fix |
| `add` | Non-feature addition to existing code |
| `refactor` | Code restructuring without behavior change |
| `redesign` | UI/UX revision |
| `style` | Formatting changes (no logic change) |
| `chore` | Dependency updates, maintenance |
| `docs` | Documentation changes |
| `test` | Adding or modifying tests |

## Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Subject Line

- Lowercase after colon. Maximum **50 characters**. Imperative mood. No period.
- Scope = file path: `feat(Home/index.tsx): add banner module`

### Body

- Explain **why** and **how**. Blank line between subject and body. Bullet points for multiple changes.

### Footer

- Ticket/PR references: `Refs: #1234`

### Single-Line (small changes)

```
fix(Home/index.tsx): fix click counter returning wrong value #0001
```

## Rules

1. **One logical change per commit** — do not mix features, fixes, and refactors.
2. **Atomic commits** — each commit independently buildable.
3. **Language**: English (Conventional Commits format).
4. **No WIP commits** — squash or amend before pushing.
5. **Reference tickets** in footer when applicable.
6. **Never commit** generated files, `node_modules`, `dist`, or build artifacts.
