# Frontend Development Standards

## 1. State and Interaction

UI state must be explicit. Do not hide loading/error/empty behavior in ad-hoc condition chains.

## 2. Component Boundaries

- keep components focused
- move heavy business logic out of UI components when it obscures intent
- keep prop contracts explicit

## 3. UX Safety

- user-visible failures should have a clear treatment
- async actions should expose pending and failure states
- design-system conventions should be followed when present

## 4. Example

A settings screen should show loading, retry, and empty states instead of a silent blank panel.

## 5. Anti-Patterns

- rendering API orchestration directly in presentational components
- silent failure states
- duplicating form validation logic across many screens
