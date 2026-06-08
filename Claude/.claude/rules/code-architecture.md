# Code Architecture Standards

## Layered Architecture

### Layer Dependency Direction

Presentation → Application → Domain → Infrastructure

| Layer | Responsibility | Allowed Dependencies |
|-------|---------------|---------------------|
| Presentation | UI components, routing, user interaction | Application layer only |
| Application | Use cases, orchestration, DTOs | Domain layer only |
| Domain | Business rules, entities, value objects | None (pure logic) |
| Infrastructure | Database, APIs, external services | Domain layer (implements interfaces) |

### Dependency Rule

Every import must point inward. The domain layer never imports from infrastructure or presentation. Infrastructure implements domain-defined interfaces (Dependency Inversion).

## Feature-Based Modular Structure (Frontend)

```
src/
  features/
    user/
      components/
      hooks/
      services/
      types/
      utils/
      index.ts
    order/
      components/
      hooks/
      services/
      types/
      utils/
      index.ts
  shared/
    components/
    hooks/
    services/
    types/
    utils/
    index.ts
```

### Module Rules

- Each feature is self-contained with its own components, hooks, services, and types
- Cross-feature communication happens through the application layer or shared module
- The `shared/` directory contains only truly reusable, feature-agnostic code
- Every module exposes its public API through `index.ts` barrel exports
- Internal module files are never imported directly from outside the module

## SOLID Application Guide

| Principle | Frontend Application | Backend Application |
|-----------|---------------------|---------------------|
| SRP | One component renders one UI concern | One service handles one business domain |
| OCP | Extend via composition and props | Extend via strategy pattern and plugins |
| LSP | Shared component contracts are honored | Interface implementations are substitutable |
| ISP | Small, focused hook interfaces | Fine-grained service interfaces |
| DIP | Inject services via context/hooks | Constructor injection for all dependencies |

## Hexagonal Architecture (Backend)

```
src/
  domain/
    model/
    port/
      input/
      output/
  application/
    service/
    usecase/
  adapter/
    input/
      rest/
      graphql/
    output/
      persistence/
      messaging/
```

- **Ports**: Interfaces defined in the domain layer (what the application needs)
- **Adapters**: Implementations in the infrastructure layer (how needs are fulfilled)
- The domain never depends on any adapter or framework

## ADR (Architecture Decision Record) Format

```
# ADR-NNNN: [Title]

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-NNNN]

## Context
[What forces are at play? What is the problem?]

## Decision
[What is the change being proposed?]

## Consequences
[What are the positive, negative, and neutral outcomes?]

## Alternatives Considered
[What other options were evaluated and why were they rejected?]
```

## Scalability Decision Criteria

| Trigger | Action |
|---------|--------|
| Feature module exceeds 15 files | Evaluate sub-module extraction |
| Shared component used by 3+ features | Promote to shared library |
| Service handles 3+ unrelated concerns | Split into focused services |
| API response time exceeds 200ms | Evaluate caching or query optimization |
| Bundle size grows beyond 250KB per route | Implement code splitting |

## Composition vs Inheritance

**Always prefer composition.** Use inheritance only when:

- There is a genuine "is-a" relationship (not "has-a")
- The base class is abstract and defines a template method pattern
- Framework requires it (React class components in legacy code)

For all other cases, use composition through hooks (frontend), dependency injection (backend), or strategy pattern.

## Micro-Frontend Module Federation Rules

- **Shell Application**: Read-only reference. Never modify shell configuration without architecture team approval.
- **Shared Library**: Read-only reference. Propose changes through ADR process.
- **Feature Modules**: Each team owns their module. Communicate through shared contracts only.
- **Shared Dependencies**: React, Ant Design, and state management library versions are locked by the shell.
- **Runtime Integration**: Modules are loaded at runtime. No build-time coupling between feature modules.
