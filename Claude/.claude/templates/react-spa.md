# React SPA Project Template

## Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| Framework | React | 18+ |
| Language | TypeScript | 5.x (strict mode) |
| Build Tool | Vite | 5.x |
| UI Library | Ant Design | 5.x |
| State (Client) | Zustand | Latest |
| State (Server) | TanStack Query | v5 |
| Forms | React Hook Form + Yup | Latest |
| Routing | React Router | v6 |
| Styling | SCSS Modules (BEM) | — |
| Testing | Vitest + RTL | Latest |
| Storybook | Storybook | 8.x |

## Project Structure

```
src/
  app/                    # App shell, routing, providers
    app.tsx
    router.tsx
    providers.tsx
  features/               # Feature modules (flat)
    auth/
      auth.tsx
      auth-form.tsx
      auth.hook.ts
      auth.service.ts
      auth.types.ts
      auth.module.scss
      auth.spec.tsx
    dashboard/
      ...
  shared/                 # Shared across features
    components/
    hooks/
    utils/
    types/
  services/               # API clients, Axios config
    api-client.ts
    interceptors.ts
  config/                 # App configuration
    env.ts
    routes.ts
    theme.ts
```

## Configuration Files

- `vite.config.ts` — Vite config with React plugin, path aliases, proxy
- `tsconfig.json` — Strict TypeScript with path aliases
- `vitest.config.ts` — Vitest with jsdom, coverage thresholds
- `.env.example` — Environment variable template

## Key Patterns

- **Component**: Function declaration, max 300 lines, max 5 props
- **State**: Local first → Lift up → Context → Zustand → TanStack Query
- **Forms**: useForm + yupResolver, Controller for Ant Design inputs
- **API**: Axios with interceptors, ApiResponse<T> contract
- **Routing**: Feature-based lazy loading with React.lazy()
- **Theme**: ConfigProvider + theme.useToken(), no direct CSS overrides
- **Testing**: AAA pattern, 80% overall coverage, Storybook for all UI components

## Module Federation (MFE)

- Shell and Shared Library are read-only reference
- Each MFE exposes its routes via a federated module
- Shared dependencies: react, react-dom, antd, react-router-dom
- Communication between MFEs via custom events or shared store
