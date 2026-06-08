# React SPA Template

## Stack Detection

- inspect `package.json`
- capture React/UI library/TypeScript/testing versions

## Suggested Structure

```text
src/
  app/
  features/
  shared/
  hooks/
  services/
  components/
```

## Conventions

- feature boundaries explicit
- UI states complete
- API calls isolated from rendering where practical
- tests for critical flows

## Quality Gates

- lint/typecheck pass
- component state coverage
- loading/error/empty states handled
- tests for critical flows
