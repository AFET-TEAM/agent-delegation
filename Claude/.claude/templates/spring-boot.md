# Spring Boot Project Template

## Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| Language | Java | 11+ |
| Framework | Spring Boot | 3.x |
| Build | Maven | 3.9+ |
| API Docs | OpenAPI / Swagger | 3.x |
| Validation | Bean Validation (Jakarta) | 3.x |
| Testing | JUnit 5 + Mockito + AssertJ | Latest |
| Coverage | JaCoCo | Latest |
| Code Style | Checkstyle | 10.12+ |
| Bug Detection | SpotBugs | Latest |
| Database | Spring Data JPA + Hibernate | — |

## Project Structure

```
src/
  main/
    java/com/company/project/
      config/             # Spring config, security, CORS
      controller/         # REST controllers
      service/            # Business logic
      repository/         # Data access
      model/
        entity/           # JPA entities
        dto/              # Request/Response DTOs
        mapper/           # Entity-DTO mappers
      exception/          # Custom exceptions + handler
      security/           # JWT, filters, auth
      util/               # Utility classes
    resources/
      application.yml
      application-dev.yml
      application-prod.yml
  test/
    java/com/company/project/
      controller/         # Controller tests
      service/            # Service tests
      repository/         # Integration tests
```

## Key Patterns

- **Architecture**: Controller → Service → Repository (layered)
- **DI**: Constructor injection only (no @Autowired on fields)
- **DTO/Entity**: Never expose entities in API — always use DTOs
- **Exception**: GlobalExceptionHandler + domain-specific exceptions
- **Validation**: Bean Validation on DTOs (@NotNull, @Size, @Pattern)
- **Auth**: JWT Bearer tokens, 15-30 min access, httpOnly refresh cookie
- **Response**: `ApiResponse<T>` wrapper with success/message/data/errors

## Quality Gates

| Metric | Threshold |
|--------|-----------|
| Line coverage | 80% |
| Branch coverage | 70% |
| Code duplication | ≤ 3% |
| Method length | ≤ 80 lines |
| Max parameters | 7 |
| Line length | 120 chars |

## Maven Profiles

- `default` — compile and test
- `quality-checks` — Checkstyle + SpotBugs + JaCoCo
- `docker` — Container image build
