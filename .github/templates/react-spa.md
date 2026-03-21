# React SPA Project Template

Project template for React single-page applications using the MADS boilerplate.

## Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Framework | React | 18+ |
| Language | TypeScript | 5.x |
| Build | Vite | 5.x |
| UI Library | Ant Design | 5.x |
| State | Zustand / React Context | latest |
| Forms | React Hook Form + Yup | latest |
| Testing | Vitest + React Testing Library | latest |
| Styling | CSS Modules / Ant Design tokens | — |

## Recommended Directory Structure

```
src/
  components/        # Shared UI components
  features/          # Feature-based modules
    auth/
      components/
      hooks/
      services/
      types/
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
| Page layout scaffolding | T2 | Templated, boilerplate-heavy |
| Complex form with validation | T1.5 | Business logic integration |
| Custom hook implementation | T1.5 | Requires deep React knowledge |
| Component unit tests | T2 | Standard pattern-based |
| Architecture decisions (routing, state) | T1 | High-impact design choices |
| Dependency analysis | T3 | Read-only research |

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
