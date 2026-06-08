# React SPA Project Template

Project template for React single-page applications using the MADS boilerplate.

## Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Framework | React | 18+ / 19 |
| Language | TypeScript | 5.x |
| Build | Vite | 5.x |
| UI Library | Ant Design | 5.x / 6.x |
| State | Zustand / React Context | latest |
| Forms | React Hook Form + Yup | latest |
| Testing | Vitest + React Testing Library | latest |
| Styling | CSS Modules / Ant Design tokens | — |

> **Version Detection**: Agents must read `package.json` to detect the installed React and Ant Design versions. The detected version determines which patterns and APIs are applicable (e.g., React 19 `use()`, `useActionState`, `useOptimistic`; Ant Design 6.x APIs).

## Recommended Directory Structure

```
src/
  components/        # Shared UI components
  features/          # Feature-based modules (flat folder convention)
    auth/
      auth-login.tsx
      auth-register.tsx
      auth-service.ts
      auth-types.ts
      auth-store.ts
      index.ts
    dashboard/
  hooks/             # Global custom hooks
  services/          # API service layer
  stores/            # State management
  types/             # Shared TypeScript types
  utils/             # Utility functions
  App.tsx
  main.tsx
```

> **Flat folder convention**: Feature folders must NOT contain sub-folders like `components/`, `hooks/`, `services/`. All feature files live flat inside the feature folder, prefixed with the feature name (e.g., `auth-login.tsx`, `auth-service.ts`). See `frontend-development/SKILL.md` for details.

## Skill Activation

| Task Type | Skills to Load |
|-----------|---------------|
| Component development | clean-code, frontend-development, implementation |
| Form implementation | clean-code, frontend-development, api-integration |
| Testing | clean-code, testing-standards |
| API integration | clean-code, api-integration |
| PR submission | clean-code, commit-standards, pr-standards |

## Agent Assignment Recommendations

| Task | Recommended Tier | Rationale |
|------|-----------------|-----------|
| Page layout scaffolding | T3 | Templated, boilerplate-heavy |
| Complex form with validation | T2 | Business logic integration |
| Custom hook implementation | T2 | Requires deep React knowledge |
| Component unit tests | T3 | Standard pattern-based |
| Architecture decisions (routing, state) | T1 | High-impact design choices |
| Dependency analysis | T5 | Read-only research |

## Quality Gates

- All components must have at least one unit test.
- No `any` types — strict TypeScript mode enforced.
- Ant Design components preferred over custom implementations.
- Bundle size monitored per feature module.
- Accessibility: WCAG 2.1 AA compliance for all interactive elements.

## Setup Commands

```bash
cp -r .github/ /path/to/react-project/
npm create vite@latest . -- --template react-ts
npm install antd @ant-design/icons
npm install -D vitest @testing-library/react @testing-library/jest-dom
```
