# Spring Boot Template

## Suggested Structure

```text
src/main/java/
  controller/
  service/
  dto/
  repository/
  mapper/
src/test/java/
```

## Conventions

- constructor injection only
- DTO/entity separation
- service/controller boundary preserved
- validation explicit at the edge

## Quality Gates

- checkstyle/spotbugs compatibility
- service tests for core logic
- contract clarity for endpoints
