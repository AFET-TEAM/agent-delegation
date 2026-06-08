# Clean Code Standards

These rules are non-negotiable and apply to all code produced under this Codex boilerplate.

## 1. Core Principles

| Principle | Meaning | Violation Signal |
|---|---|---|
| SRP | One module/function, one reason to change | function/class doing unrelated jobs |
| OCP | Extend behavior without constantly modifying stable core code | feature addition requires invasive edits everywhere |
| LSP | Substitutions preserve behavioral expectations | subtype changes contract in surprising ways |
| ISP | Consumers depend only on what they need | broad interfaces force irrelevant methods |
| DIP | Depend on abstractions or stable seams, not volatile details | high-level logic tightly coupled to low-level implementation |
| DRY | Duplication removed after clear repetition | same logic copied with small variation |
| KISS | simplest correct solution wins | abstraction heavier than the problem |
| YAGNI | build only what is needed now | future-proofing without present need |

## 2. SOLID Guidance

### Single Responsibility Principle (SRP)
- one function, one job
- one module, one main concept
- if “and” appears in the purpose statement, split may be needed

### Open/Closed Principle (OCP)
- prefer extension points over repeated edits to stable code paths
- avoid giant switch/if trees that grow with each new feature without structure

### Liskov Substitution Principle (LSP)
- subtypes must preserve expected behavior and invariants
- do not narrow valid inputs or widen surprising failure modes silently

### Interface Segregation Principle (ISP)
- avoid forcing callers to depend on broad, irrelevant surfaces
- split large interfaces by consumer use-cases when needed

### Dependency Inversion Principle (DIP)
- high-level policies should not depend on volatile infrastructure details directly
- isolate unstable concerns behind clear seams when the task warrants it

## 3. Absolute Prohibitions

Blocked by policy and should be treated as hard failures:
- `console.*`
- `debugger`
- `alert`, `confirm`, `prompt`
- `any`, `@ts-ignore`, `@ts-expect-error`
- dead code and debug leftovers
- TODO/FIXME/HACK in production output

## 4. Function Rules

- max 20 lines unless language/framework forces slight variation
- max 3 parameters; otherwise options object
- max 2 nesting levels
- cyclomatic complexity <= 8
- one function, one clear job

## 5. File Rules

- default max 250 lines
- one concept per file
- prefer co-location of related source/tests/types
- do not create barrel files unless they improve clarity

## 6. Naming Rules

- intention-revealing names only
- no generic names like `data`, `temp`, `info`, `value`
- no unnecessary abbreviations
- booleans start with `is/has/should`
- handlers start with `handle`

## 7. Error Handling

- no empty catch blocks
- every catch does meaningful work
- use domain-appropriate errors where relevant
- exceptions are not control flow

## 8. Imports and Dependencies

- no circular dependencies
- avoid wildcard imports
- keep import groups consistent
- remove unused imports immediately

## 9. Review Checklist

- function purpose obvious?
- file too broad?
- name tells truth?
- hidden coupling?
- debug artifact present?
- failure path covered?
- SOLID violated in a meaningful way?
