---
name: Clean Code
description: >
  Clean code principles, software engineering best practices, and code quality
  standards. This skill is MANDATORY for all coding tasks across all tiers.
  Enforces SOLID, DRY, KISS, YAGNI, and strict code hygiene rules.
estimated-tokens: 2700
used-by: [T1, T2, T3, T4]
tiers:
  T1: mandatory
  T2: mandatory
  T3: mandatory
  T4: mandatory
---

# Clean Code Skill

## Scope

This skill is **mandatory** for every agent that produces code (Tier 1, Tier 2, and Tier 3).
Tier 4 (Lead Analyst) also loads this skill for code quality awareness during reviews.
It must be applied to ALL coding tasks without exception.

---

## Core Principles

### SOLID

| Principle | Rule | Violation Sign |
| --- | --- | --- |
| **SRP** | A module/function has exactly one reason to change | Function does more than its name suggests |
| **OCP** | Open for extension, closed for modification | Adding a feature requires changing existing code |
| **LSP** | Subtypes are substitutable for their base types | Overridden method changes behavior contract |
| **ISP** | No client depends on methods it doesn't use | Large interface forces empty implementations |
| **DIP** | Depend on abstractions, not concretions | Direct instantiation of dependencies |

### DRY (Don't Repeat Yourself)

- Extract shared logic when the **same pattern appears 3+ times** (Rule of Three).
- Avoid premature abstraction — duplication is cheaper than wrong abstraction.
- Shared types, constants, and utilities belong in a `shared/` or `common/` module.

### KISS (Keep It Simple, Stupid)

- Choose the simplest correct solution.
- Avoid clever tricks — readable code beats compact code.
- If a junior developer can't understand it in 30 seconds, simplify it.

### YAGNI (You Aren't Gonna Need It)

- Never add functionality "just in case".
- No speculative abstractions, interfaces, or config options.
- Build for today's requirements, refactor for tomorrow's.

---

## Strict Code Hygiene Rules

### 🔴 NEVER Include Comments in Code

```typescript
// ❌ FORBIDDEN — No comments
// This function calculates the total price
function calculateTotalPrice(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// ✅ CORRECT — Self-documenting code, no comments needed
function calculateTotalPrice(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}
```

**Rules**:

- Code must be **self-documenting** through clear naming.
- No inline comments (`//`), no block comments (`/* */`).
- No TODO, FIXME, HACK, or XXX comments.
- No commented-out code — use version control instead.
- **Exception**: JSDoc/TSDoc for public API interfaces is allowed (not implementation).

### 🔴 NEVER Leave Console Statements

```typescript
// ❌ FORBIDDEN — No console output
console.log("user data:", userData);
console.warn("deprecated method called");
console.error("something went wrong");
console.debug("debug info");
console.info("processing...");
console.table(data);
console.time("operation");
console.trace();

// ✅ CORRECT — Use a proper logging service
logger.error("Payment processing failed", { orderId, error });
```

**Rules**:

- No `console.log`, `console.warn`, `console.error`, `console.debug`, `console.info`.
- No `console.table`, `console.time`, `console.timeEnd`, `console.trace`.
- No `alert()`, `confirm()`, `prompt()` in production code.
- Use a structured logging service (e.g., `winston`, `pino`, or a custom `Logger` class).
- Logging must include context (correlation ID, user ID, operation name).

### 🔴 NEVER Leave Debug Artifacts

- No `debugger` statements.
- No test-only code in production files.
- No hardcoded test values, mock data, or placeholder strings.
- No `any` type in TypeScript — use proper typing.

---

## Naming Conventions

### General Rules

| Element               | Convention                 | Example                       |
| --------------------- | -------------------------- | ----------------------------- |
| Files                 | `kebab-case`               | `user-service.ts`             |
| Variables / Functions | `camelCase`                | `getUserById`                 |
| Classes / Interfaces  | `PascalCase`               | `UserService`                 |
| Constants             | `UPPER_SNAKE_CASE`         | `MAX_RETRY_COUNT`             |
| Booleans              | `is`/`has`/`should` prefix | `isActive`, `hasPermission`   |
| Event handlers        | `handle` + Event           | `handleSubmit`, `handleClick` |
| Async functions       | Verb describing the action | `fetchUsers`, `createOrder`   |

### Naming Quality Checks

- **Intention-revealing**: Name tells what it does, not how.
- **No abbreviations**: `button` not `btn`, `message` not `msg`, `response` not `res`.
- **No generic names**: No `data`, `info`, `item`, `thing`, `stuff`, `temp`, `val`.
- **Consistent vocabulary**: Pick one term and use it everywhere (e.g., `fetch` vs `get` vs `retrieve` — pick one).

---

## Function Rules

### Size and Complexity

- **Maximum 20 lines** per function (excluding type definitions).

> **Java gate vs standard**: Java Checkstyle enforces MethodLength=80 as a build-failure gate. The 20-line standard is the team's quality target; Checkstyle's 80-line limit prevents extreme violations.

- **Maximum 3 parameters** — use an options object for more.

> **Java gate vs standard**: Java Checkstyle enforces ParameterNumber=7 as a build-failure gate. The 3-parameter standard is the team's quality target; Checkstyle's 7-parameter limit prevents extreme violations.
- **Maximum 2 levels of nesting** — use early returns and extraction.
- **Cyclomatic complexity ≤ 8** per function.
- **One function, one job** — if "and" appears in the name, split it.

### Structure

```typescript
// ✅ Early return pattern
function getDiscount(user: User): number {
  if (!user.isPremium) return 0;
  if (user.membershipYears < 1) return 5;
  if (user.membershipYears < 5) return 10;
  return 15;
}

// ❌ Deeply nested
function getDiscount(user: User): number {
  if (user.isPremium) {
    if (user.membershipYears >= 5) {
      return 15;
    } else if (user.membershipYears >= 1) {
      return 10;
    } else {
      return 5;
    }
  } else {
    return 0;
  }
}
```

---

## Error Handling

### Rules

- Every `catch` block performs a meaningful action (log, transform, rethrow).
- Empty `catch` blocks are **forbidden**.
- Use domain-specific error classes, not generic `Error`.
- Separate user-facing errors from internal errors.
- Never use exceptions for control flow.

### Pattern: Result Type

```typescript
type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E };
```

---

## File Structure

- **Maximum 250 lines** per file.

> **Domain-specific overrides**: Frontend components may extend to 300 lines when logic/style splitting is impractical (see `frontend-development/SKILL.md`). Java files use Checkstyle FileLength=2000 as a build-failure gate while 250 lines remains the team standard (see `java-quality-tooling/SKILL.md`).

- **One concept per file** — one component, one service, one hook.
- **Barrel exports** (`index.ts`) for public API of a module.
- **Co-locate related files** — tests next to source, types next to implementation.

---

## Import Hygiene

- No circular dependencies.
- No wildcard imports (`import * as`).
- Group imports: framework → third-party → internal → relative.
- Remove unused imports immediately.

---

## Code Quality Checklist

Before submitting any code, verify:

- [ ] No comments in code (self-documenting naming)
- [ ] No `console.*` statements
- [ ] No `debugger` statements
- [ ] No `any` types
- [ ] No commented-out code
- [ ] No magic numbers (use named constants)
- [ ] No deep nesting (max 2 levels)
- [ ] Functions under 20 lines
- [ ] Files under 250 lines
- [ ] All errors are handled
- [ ] Naming is intention-revealing
- [ ] No abbreviations in names
- [ ] DRY — no duplicated logic
- [ ] Single responsibility per function/file
