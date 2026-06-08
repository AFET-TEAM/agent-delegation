# Code Architecture Standards

## 1. Dependency Direction

Prefer coherent layered or feature-based boundaries. Whatever the chosen structure, dependency direction must remain understandable and intentional.

Typical allowed flow:
- presentation -> application -> domain -> infrastructure

## 2. Boundary Rules

- presentation should not own core business logic
- application layer coordinates use cases
- infrastructure details should not leak upward
- modules should expose minimal public API

## 3. Decision Heuristics

Ask:
- who should own this behavior?
- does this change create hidden coupling?
- is a new abstraction actually justified?
- can the change be reversed easily if wrong?

## 4. Anti-Patterns

- feature code reaching directly into unrelated modules
- shared folder becoming a junk drawer
- infra concerns mixed into domain logic
- global state used to bypass clear interfaces

## 5. Refactor Triggers

Consider structural refactor when:
- one module changes for many unrelated reasons
- call chains obscure ownership
- shared utilities become de facto architecture centers
