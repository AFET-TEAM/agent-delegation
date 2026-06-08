# Clean Code Standards

These rules are **non-negotiable** and apply to ALL code in ALL files.

## Core Principles

| Principle | Rule | Violation Sign |
|---|---|---|
| **SRP** | One module/function = one reason to change | Function does more than its name suggests |
| **OCP** | Open for extension, closed for modification | Adding a feature requires changing existing code |
| **LSP** | Subtypes are substitutable for base types | Overridden method changes behavior contract |
| **ISP** | No client depends on unused methods | Large interface forces empty implementations |
| **DIP** | Depend on abstractions, not concretions | Direct instantiation of dependencies |

- **DRY**: Extract shared logic after 3+ occurrences (Rule of Three). Premature abstraction is worse than duplication.
- **KISS**: Simplest correct solution wins. If a junior dev can't understand it in 30 seconds, simplify.
- **YAGNI**: Build only what is needed now. No speculative features, interfaces, or config options.

## Absolute Prohibitions

These are enforced by hooks — violations will be **blocked**:

- **No comments**: No `//`, `/* */`, TODO, FIXME, HACK, XXX. Code must be self-documenting. Exception: JSDoc on exported public API interfaces only.
- **No console statements**: No `console.log/warn/error/debug/info/table/time/trace`. Use a structured logging service.
- **No debug artifacts**: No `debugger`, no `any` type, no `@ts-ignore`, no hardcoded test values in production code.
- **No alert/confirm/prompt**: Use Ant Design Modal or notification components.

## Function Rules

- **Maximum 20 lines** per function (excluding type definitions).
- **Maximum 3 parameters** — use an options object for more.
- **Maximum 2 levels of nesting** — use early returns and extraction.
- **Cyclomatic complexity <= 8** per function.
- **One function, one job** — if "and" appears in the name, split it.

## File Rules

- **Maximum 250 lines** per file (300 for React components when logic/style splitting is impractical).
- **One concept per file** — one component, one service, one hook.
- **Barrel exports** (`index.ts`) for public API of a module.
- **Co-locate related files** — tests next to source, types next to implementation.

## Naming Convention

| Element | Convention | Example |
|---|---|---|
| Files | `kebab-case` | `user-service.ts` |
| Variables / Functions | `camelCase` | `getUserById` |
| Classes / Interfaces | `PascalCase` | `UserService` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| Booleans | `is`/`has`/`should` prefix | `isActive`, `hasPermission` |
| Event handlers | `handle` + Event | `handleSubmit`, `handleClick` |
| Async functions | Verb describing action | `fetchUsers`, `createOrder` |

**Quality checks**: Intention-revealing names only. No abbreviations (`button` not `btn`). No generic names (`data`, `info`, `item`, `temp`, `val`). Consistent vocabulary (pick one: `fetch` vs `get` vs `retrieve`).

## Error Handling

- Every `catch` block performs a meaningful action (log, transform, rethrow).
- Empty catch blocks are **forbidden**.
- Domain-specific error classes, not generic `Error`.
- Never use exceptions for control flow.

## Import Rules

- No circular dependencies.
- No wildcard imports (`import * as`).
- Group: framework -> third-party -> internal -> relative.
- Remove unused imports immediately.

## Code Smell Catalog

| Smell | Sign | Fix |
|---|---|---|
| Long Method | > 20 lines | Extract method |
| Long Parameter List | > 3 params | Introduce options object |
| Feature Envy | Method uses another class's data more than its own | Move method |
| Data Clump | Same group of variables appearing together | Extract class |
| Primitive Obsession | Using primitives instead of small objects | Introduce value object |
| Shotgun Surgery | One change requires editing many classes | Move related logic together |
| Divergent Change | One class changed for multiple reasons | Split class (SRP) |
| God Class | Class doing too much | Decompose into focused classes |

## Quality Checklist

- [ ] Every function has a single, clear purpose
- [ ] No function exceeds 20 lines
- [ ] No file exceeds 250 lines (300 for React components)
- [ ] All names are intention-revealing
- [ ] No abbreviations or generic names
- [ ] Every catch block performs meaningful action
- [ ] No circular dependencies
- [ ] Import groups: framework → third-party → internal → relative
- [ ] No unused imports, variables, or dead code
- [ ] DRY applied only after 3+ occurrences
