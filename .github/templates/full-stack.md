# Full-Stack Project Template

Project template for full-stack applications (React frontend + Spring Boot backend) using the MADS boilerplate.

## Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend | React + TypeScript + Ant Design | 18+ / 5.x / 5.x |
| Backend | Spring Boot + Java | 3.2+ / 21+ |
| Build (FE) | Vite | 5.x |
| Build (BE) | Maven | 3.9+ |
| API Contract | OpenAPI / Swagger | 3.0 |
| Testing (FE) | Vitest + RTL | latest |
| Testing (BE) | JUnit 5 + Mockito | latest |

## Recommended Directory Structure

```
project-root/
  frontend/            # React SPA (see react-spa.md)
    src/
    package.json
    vite.config.ts
  backend/             # Spring Boot API (see spring-boot.md)
    src/
    pom.xml
  .github/             # MADS boilerplate (shared)
    agents/
    config/
    hooks/
    instructions/
    skills/
    templates/
  docs/
    api-contract.yaml  # OpenAPI specification
    architecture.md    # System architecture document
```

## Skill Activation by Domain

| Domain | Task | Skills to Load |
|--------|------|---------------|
| Frontend | Component dev | clean-code, frontend-development |
| Frontend | API calls | clean-code, api-integration |
| Backend | REST endpoint | clean-code, backend-development |
| Backend | Security | clean-code, backend-security |
| Integration | Contract alignment | clean-code, api-integration |
| Quality | Both sides | clean-code, testing-standards, java-quality-tooling |

## Agent Assignment Strategy

Full-stack tasks benefit from parallel agent execution:

### x5 Mode (Recommended Minimum)

| Agent | Tier | Responsibility |
|-------|------|---------------|
| Principal | T1 | Architecture decisions, API contract review |
| Staff Engineer | T1.5 | Complex backend logic, frontend-backend integration |
| MidCoder | T2 | CRUD endpoints, component scaffolding |
| Lead Analyst | T2.5 | Review analyst outputs |
| Analyst | T3 | Dependency audit, security scan |

### x7/x10 Mode (Complex Features)

Split frontend and backend work across separate Staff Engineers and MidCoders for maximum parallelism.

## Integration Contract Rules

1. **API contract first**: Define the OpenAPI spec before implementing endpoints or API calls.
2. **Shared types**: Generate TypeScript types from OpenAPI spec for frontend.
3. **Error format**: Standardized error response format per `api-integration` skill.
4. **Pagination**: Cursor-based or offset-based, decided once and applied consistently.
5. **Authentication**: JWT token flow defined in the API contract.

## Quality Gates

### Frontend
- TypeScript strict mode, zero `any` types.
- Component test coverage > 80%.
- Bundle size per route < 200KB gzipped.

### Backend
- Checkstyle + SpotBugs: zero violations.
- JaCoCo: 80% line / 70% branch coverage.
- All endpoints documented in OpenAPI.
- No N+1 query patterns.

### Integration
- API contract (OpenAPI) is the single source of truth.
- Frontend and backend must independently validate request/response shapes.
- End-to-end smoke tests for critical user flows.

## Setup Commands

```bash
# Copy boilerplate to project root
cp -r .github/ /path/to/fullstack-project/

# Frontend setup
cd frontend && npm create vite@latest . -- --template react-ts
npm install antd @ant-design/icons

# Backend setup
cd backend
# Apply quality plugins from .github/config/pom-quality-plugins.xml.template

# Verify
cd frontend && npm run test
cd backend && mvn verify -Pquality-checks
```
