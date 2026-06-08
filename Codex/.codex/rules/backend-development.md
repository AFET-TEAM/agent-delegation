# Backend Development Standards

## 1. Layering

- controller/handler thin
- service/use-case owns business logic
- repository/data layer hidden behind service boundary
- mapping between DTO and entity explicit

## 2. Contracts

- request/response shapes explicit
- validation at boundary
- persistence model should not leak as public contract accidentally

## 3. Dependency Injection

- constructor injection preferred
- field injection prohibited in codebases where maintainability matters

### Example

```java
@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
}
```

## 4. DTO vs Entity Separation

```java
public record CreateUserRequest(String email, String name) {}
public record UserResponse(String id, String email, String name) {}
```

## 5. Operational Quality

- failure paths explicit
- side effects visible
- auth assumptions documented
- do not bury orchestration inside controller helpers

## 6. Quality Gates

If Java/Spring stack exists, preserve compatibility with:
- Checkstyle
- SpotBugs
- coverage gates
- test suites
