# Spring Boot Project Template

Project template for Java/Spring Boot backend applications using the MADS boilerplate.

## Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Framework | Spring Boot | 3.2+ |
| Language | Java | 21+ |
| Build | Maven | 3.9+ |
| ORM | Spring Data JPA / Hibernate | latest |
| Security | Spring Security | 6.x |
| Testing | JUnit 5 + Mockito + AssertJ | latest |
| API Docs | SpringDoc OpenAPI | 2.x |
| Code Gen | Lombok + MapStruct | latest |

## Recommended Directory Structure

```
src/main/java/com/company/project/
  config/              # Spring configuration classes
  controller/          # REST controllers
  service/             # Business logic layer
    impl/
  repository/          # Data access layer
  model/
    entity/            # JPA entities
    dto/               # Data transfer objects
    mapper/            # MapStruct mappers
  exception/           # Custom exception classes
    handler/           # Global exception handlers
  security/            # Security configuration
  common/              # Shared utilities
src/test/java/com/company/project/
  controller/          # Controller integration tests
  service/             # Service unit tests
  repository/          # Repository tests
```

## Skill Activation

| Task Type | Skills to Load |
|-----------|---------------|
| REST endpoint | clean-code, backend-development, implementation |
| Security config | clean-code, backend-security |
| Unit testing | clean-code, testing-standards |
| Quality setup | clean-code, java-quality-tooling |
| API contract | clean-code, api-integration |
| PR submission | clean-code, commit-standards, pr-standards |

## Agent Assignment Recommendations

| Task | Recommended Tier | Rationale |
|------|-----------------|-----------|
| Entity/DTO creation | T3 | Boilerplate, Lombok-based |
| CRUD endpoint | T3 | Templated pattern |
| Complex business logic | T2 | Domain knowledge required |
| Security audit | T5 | Read-only analysis |
| Architecture (hexagonal, DDD) | T1 | High-impact design |
| JaCoCo/Checkstyle setup | T3 | Configuration task |

## Quality Gates

- Checkstyle: zero violations at `warning` severity.
- SpotBugs: zero bugs at `Low` threshold.
- JaCoCo: 80% line coverage, 70% branch coverage.
- No `@Autowired` field injection — constructor injection only.
- All public API endpoints documented with OpenAPI annotations.
- CyclomaticComplexity per method: max 8.

## Setup Commands

```bash
cp -r .github/ /path/to/spring-boot-project/

# Add to pom.xml <properties>:
# <quality.dir>${project.basedir}/.github/config</quality.dir>

# Copy quality plugin configs from .github/config/pom-quality-plugins.xml.template
# into your pom.xml <build><plugins> section.

mvn checkstyle:check
mvn spotbugs:check
mvn verify -Pquality-checks
```
