---
name: Backend Development
description: >
  Dual-stack backend skill covering Node.js/TypeScript AND Java/Spring Boot.
  API design, layered architecture, exception handling, database patterns,
  authentication, and server-side standards for all backend coding tasks.
used-by: [T1, T1.5, T2]
estimated-tokens: 4800
tiers:
  T1: optional
  T1.5: optional
  T2: optional
---

# Backend Development Skill

## API Design Standards

### RESTful Conventions

- Resources are nouns in plural form: `/users`, `/orders`, `/products`.
- HTTP methods map to CRUD: GET (read), POST (create), PUT/PATCH (update), DELETE (remove).
- Nested resources express relationships: `/users/{id}/orders`.
- Query parameters for filtering, sorting, pagination: `?status=active&sort=createdAt&page=2&limit=20`.
- API versioning via URL prefix: `/api/v1/users`.

### Response Format — Node.js (TypeScript)

```typescript
interface ServiceResponse<T> {
  success: boolean;
  data: T;
  meta?: PaginationMeta;
}

interface ServiceErrorResponse {
  success: boolean;
  error: {
    code: string;
    message: string;
    details?: unknown[];
  };
}
```

### Response Format — Java (Spring Boot)

All endpoints return `ServiceResponse<T>` via factory methods:

> **Note**: `ServiceResponse<T>` is the **internal service-layer** wrapper with `traceId` for observability. For frontend-facing API responses, use `ApiResponse<T>` (defined in `api-integration` skill) which omits internal fields. Controllers should map `ServiceResponse<T>` → `ApiResponse<T>` at the controller boundary.

```java
public class ServiceResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private List<ServiceError> errors;
    private LocalDateTime timestamp;
    private String traceId;

    public static <T> ServiceResponse<T> success(T data) { ... }
    public static <T> ServiceResponse<T> success(T data, String message) { ... }
    public static <T> ServiceResponse<T> error(String message, List<ServiceError> errors) { ... }
}
```

Controller usage:

```java
return ResponseEntity.ok(ServiceResponse.success(dto));
return ResponseEntity.status(HttpStatus.CREATED)
        .body(ServiceResponse.success(dto, messageService.getMessage("user.created")));
```

### HTTP Status Codes

| Code | Usage                             |
| ---- | --------------------------------- |
| 200  | Successful read or update         |
| 201  | Successful creation               |
| 204  | Successful deletion (no content)  |
| 400  | Validation error, malformed input |
| 401  | Unauthenticated                   |
| 403  | Unauthorized (insufficient perms) |
| 404  | Resource not found                |
| 409  | Conflict (duplicate, state issue) |
| 422  | Unprocessable entity              |
| 429  | Rate limited                      |
| 500  | Internal server error             |

---

## Java/Spring Boot Architecture

### Layered Architecture

```
Controller → Service → Repository → Database
```

| Layer | Annotations | Responsibility |
| --- | --- | --- |
| Controller | `@RestController`, `@RequestMapping`, `@Tag` | HTTP mapping, `@Valid`, `ResponseEntity` only |
| Service | `@Service`, `@Transactional(readOnly=true)`, `@Slf4j` | Business logic, validation, exceptions |
| Repository | `@Repository`, extends `JpaRepository` | Data access only |

Rules: no business logic in controllers. No try-catch in controllers. No `ObjectMapper` in controllers.

### Constructor Injection (Mandatory)

Use `@RequiredArgsConstructor` with `private final` fields. `@Autowired` is **BANNED** — field injection and setter injection are also banned.

```java
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {
    private final UserRepository userRepository;
    private final UserMapper userMapper;
    private final MessageService messageService;
}
```

### Spring Annotation Standards

| Context | Required Annotations |
| --- | --- |
| Controller | `@RestController`, `@RequestMapping("/api/v1/...")`, `@RequiredArgsConstructor`, `@Tag` |
| Service | `@Service`, `@RequiredArgsConstructor`, `@Transactional(readOnly=true)` at class level, `@Slf4j` |
| Write methods | `@Transactional` at method level (without `readOnly`) |
| Config classes | `@Configuration`, `@RequiredArgsConstructor` |
| Logging | `@Slf4j` via Lombok — never use manual `LoggerFactory` |

### MessageService for i18n

Hardcoded user-facing messages are **BANNED**. Use `MessageService` with `messages.properties`:

```java
@Service
@RequiredArgsConstructor
public class MessageService {
    private final MessageSource messageSource;

    public String getMessage(String code, Object... args) {
        return messageSource.getMessage(code, args, LocaleContextHolder.getLocale());
    }
}
```

Property key format: `[module].[entity].[operation]` with `{0}`, `{1}` parameters.

### DTO / Entity Separation

- **Entity**: `@Data`, `@NoArgsConstructor`, `@AllArgsConstructor`, `@Builder`, `@EqualsAndHashCode(of = "id")`.
- **Request DTO**: `@Data`, `@Builder`, Bean Validation (`@NotBlank`, `@Email`, `@Size`).
- **Response DTO**: `@Data`, `@Builder`.
- Map between layers using **MapStruct** or a dedicated mapper class.
- Never expose entities directly in API responses.

### OpenAPI / Swagger (Mandatory)

Every controller method requires `@Operation` and `@ApiResponses`:

```java
@Operation(summary = "Get user by ID", description = "Returns a single user")
@ApiResponses({
    @ApiResponse(responseCode = "200", description = "Success"),
    @ApiResponse(responseCode = "404", description = "User not found")
})
@GetMapping("/{id}")
public ResponseEntity<ServiceResponse<UserDto>> getUser(@PathVariable Long id) {
    return ResponseEntity.ok(ServiceResponse.success(userService.getUser(id)));
}
```

Class-level `@Tag(name = "Users", description = "User management endpoints")` is required.

### Import Rules

- Star imports (`import java.util.*`) are **BANNED**.
- Remove all unused imports.
- Ordering: (1) `java.*` → (2) `jakarta.*` / `javax.*` → (3) third-party (`org.springframework.*`, `lombok.*`) → (4) project imports.

---

## Exception Handling (Java)

### Exception Hierarchy

```
BaseException (abstract, extends RuntimeException)
├── BusinessException          → 409 Conflict
├── ResourceNotFoundException  → 404 Not Found
└── ValidationException        → 400 Bad Request
```

```java
public abstract class BaseException extends RuntimeException {
    private final String errorCode;
    private final HttpStatus httpStatus;

    protected BaseException(String errorCode, String message, HttpStatus httpStatus) {
        super(message);
        this.errorCode = errorCode;
        this.httpStatus = httpStatus;
    }
}
```

### GlobalExceptionHandler

Centralized exception handling via `@RestControllerAdvice`. Controllers must **never** catch exceptions themselves.

```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ServiceResponse<Void>> handleNotFound(ResourceNotFoundException ex) {
        log.warn("Resource not found: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ServiceResponse.error(ex.getMessage(), List.of(
                    ServiceError.builder().code(ex.getErrorCode()).message(ex.getMessage()).build())));
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ServiceResponse<Void>> handleBusiness(BusinessException ex) {
        log.warn("Business error: code={}", ex.getErrorCode());
        return ResponseEntity.status(ex.getHttpStatus())
                .body(ServiceResponse.error(ex.getMessage(), List.of(
                    ServiceError.builder().code(ex.getErrorCode()).message(ex.getMessage()).build())));
    }
}
```

### Try-Catch Rules

| Scenario | Use try-catch? | Reason |
| --- | --- | --- |
| External API calls | Yes | Wrap in `BusinessException` |
| File / network I/O | Yes | Convert to domain exception |
| JSON parsing | Yes | Convert to `ValidationException` |
| Business logic | No | Throw exception, let handler catch |
| Controller methods | No | `GlobalExceptionHandler` handles it |
| Repository methods | No | JPA exceptions handled globally |

Never swallow exceptions. Always log then re-throw as a domain exception.

### Retry and Circuit Breaker

Use `@Retryable` for transient failures on external calls:

```java
@Retryable(
    value = {NetworkException.class, TimeoutException.class},
    maxAttempts = 3,
    backoff = @Backoff(delay = 1000, multiplier = 2)
)
public ApiResult callExternalApi(Request request) {
    return externalClient.call(request);
}

@Recover
public ApiResult recover(NetworkException ex, Request request) {
    throw new BusinessException("EXTERNAL_API_UNAVAILABLE", "Service unavailable", ex);
}
```

Use Resilience4j `CircuitBreaker` for sustained failure protection on critical integrations.

---

## Authentication & Authorization

- Access tokens: short-lived (15–30 min). Refresh tokens: long-lived (7–30 days), httpOnly cookie.
- Token payload: only `sub`, `iat`, `exp`, `roles`. Never store sensitive data in JWT.
- **Layer 1 — Authentication**: Middleware/filter validates token, attaches user to context.
- **Layer 2 — RBAC**: Guards routes/endpoints by user role.
- **Layer 3 — Resource-level**: Validates user owns or can access the specific resource.

### Security Checklist

- Hash passwords with bcrypt (cost factor >= 12).
- Rate limit authentication endpoints.
- Implement CORS with explicit origin allowlist.
- Sanitize all input — never trust client data.
- Use parameterized queries — prevent SQL injection.
- Validate request bodies: Zod/Joi (Node.js) or Bean Validation (Java).
- Set security headers: Helmet.js (Node.js) or Spring Security headers (Java).

---

## Database Patterns

### Query Optimization

- Index frequently queried columns.
- Avoid N+1 queries — use eager loading, `JOIN FETCH`, or batch queries.
- Paginate all list endpoints — never return unbounded result sets.
- Use database transactions for multi-step mutations.
- Prefer soft deletes (`deletedAt` timestamp) over hard deletes.

### Migration Standards

- Every schema change requires a migration file.
- Migrations must be reversible (up/down) or forward-only with rollback plan.
- Never modify existing migrations — create new ones.
- Naming: `YYYYMMDDHHMMSS-descriptive-name` (Node.js) or Flyway/Liquibase conventions (Java).

---

## Middleware Architecture (Node.js)

1. **Security**: CORS, Helmet, rate limiting.
2. **Parsing**: Body parser, cookie parser.
3. **Authentication**: Token validation, session management.
4. **Authorization**: Role/permission checks.
5. **Validation**: Request schema validation.
6. **Business logic**: Route handlers.
7. **Error handling**: Global error handler (always last).

Catch all unhandled errors at the global level. Map domain errors to HTTP status codes. Never expose internal error details to clients in production.

---

## Service Layer Standards

- One service per domain concept: `UserService`, `OrderService`, `PaymentService`.
- Services never call each other's repositories directly — use service-to-service calls.
- Keep service methods focused: one business operation per method.
- Validate all inputs at the service boundary using DTOs. Separate creation DTOs from update DTOs.
- Wrap multi-step mutations in database transactions. Keep transactions short — pre-validate outside.

---

## Structured Logging

- **Node.js**: Winston, Pino, or equivalent.
- **Java**: `@Slf4j` via Lombok (never manual `LoggerFactory`).
- Log levels: `error`, `warn`, `info`, `debug`.
- Include correlation/trace IDs for request tracing.
- Log format: structured JSON for machine parsing.
- Never log sensitive data (passwords, tokens, PII).

---

## Testing Standards

> **Cross-reference**: For comprehensive testing standards, see `testing-standards/SKILL.md`. This section provides backend-specific testing context only.

### Node.js (Jest / Vitest)

- Test service methods in isolation with mocked repositories.
- Minimum 80% coverage for services, 90% for critical business logic.
- Naming convention:

```
describe('UserService')
  it('should create user with valid input')
  it('should throw ValidationError when email is missing')
```

### Java (JUnit 5 / Mockito)

- Unit-test services with `@ExtendWith(MockitoExtension.class)` and `@Mock` / `@InjectMocks`.
- Integration-test controllers with `@WebMvcTest` or `@SpringBootTest`.
- Use `@Sql` or Testcontainers for database state.
- Naming convention: `methodName_givenCondition_expectedResult`.

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    @Mock
    private UserRepository userRepository;
    @InjectMocks
    private UserService userService;
}
```

### Shared Testing Rules

- Test edge cases: empty inputs, boundary values, error paths. Reset database state between tests.
- Test authentication and authorization flows in integration tests.

---

## Checklist

Before submitting backend code, verify:

- [ ] All endpoints return the stack's standard response format (`ServiceResponse<T>` internally; mapped to `ApiResponse<T>` at controller boundary — see `api-integration` skill).
- [ ] Input validation on every mutation endpoint (Zod/Joi or `@Valid` + Bean Validation).
- [ ] Authentication and authorization applied to protected routes.
- [ ] Error handling returns appropriate status codes.
- [ ] Database queries optimized (no N+1, proper indexes).
- [ ] Structured logging — no raw print/console statements.
- [ ] Unit tests cover service layer logic.
- [ ] Integration tests cover API endpoints.
- [ ] Migrations are reversible and tested.
- [ ] No hardcoded secrets or configuration values.
- [ ] **(Java)** Constructor injection only — no `@Autowired`.
- [ ] **(Java)** OpenAPI annotations on every controller method.
- [ ] **(Java)** Messages via `MessageService`; no star imports.
