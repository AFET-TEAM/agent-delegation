# Backend Development Standards

paths:
  - "src/**/*.java"
  - "src/**/*.kt"
  - "**/*.gradle*"
  - "**/pom.xml"

## Java / Spring Boot

### Layered Architecture

```
Controller → Service → Repository
    ↓           ↓          ↓
  DTO      Domain Model   Entity
```

| Layer | Responsibility | Rules |
|-------|---------------|-------|
| Controller | HTTP handling, request validation, response mapping | No business logic. Delegates to service layer immediately. |
| Service | Business logic, orchestration, transaction management | No HTTP concerns. Works with domain models. |
| Repository | Data access, query execution | No business logic. Returns entities or projections. |

### Dependency Injection

Constructor injection is mandatory. Field injection with `@Autowired` is banned.

```java
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final EventPublisher eventPublisher;
}
```

### DTO / Entity Separation

- Never expose JPA entities in API responses
- Map between DTO and Entity at the service layer boundary
- Use dedicated request and response DTOs for each endpoint
- Use MapStruct or manual mapping (no reflection-based mappers in production)

### Exception Handling

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleNotFound(
            ResourceNotFoundException exception) {
        ApiResponse<Void> response = ApiResponse.error(
                exception.getMessage(),
                "RESOURCE_NOT_FOUND"
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
    }

    @ExceptionHandler(ValidationException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidation(
            ValidationException exception) {
        ApiResponse<Void> response = ApiResponse.error(
                exception.getMessage(),
                "VALIDATION_ERROR"
        );
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleUnexpected(
            Exception exception) {
        ApiResponse<Void> response = ApiResponse.error(
                "An unexpected error occurred",
                "INTERNAL_ERROR"
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(response);
    }
}
```

### Bean Validation

```java
public record CreateUserRequest(
        @NotBlank @Size(max = 100) String name,
        @NotBlank @Email String email,
        @NotBlank @ValidPassword String password,
        @NotNull @Past LocalDate birthDate
) {}
```

### Transaction Management

- `@Transactional` on service methods, never on controllers or repositories
- Read-only transactions for query methods: `@Transactional(readOnly = true)`
- Explicit rollback rules for checked exceptions: `@Transactional(rollbackFor = Exception.class)`

### OpenAPI Documentation

- Every controller method has `@Operation` annotation with summary and description
- Response types documented with `@ApiResponse` annotations
- Request body and parameters documented with `@Schema` annotations
- API versioning through URL path: `/api/v1/`, `/api/v2/`

## Node.js / TypeScript

### Middleware Architecture

```
Request → Auth Middleware → Validation Middleware → Route Handler → Service → Repository → Response
```

### Service Layer Pattern

```typescript
interface UserService {
  findById(id: string): Promise<User>;
  create(input: CreateUserInput): Promise<User>;
  update(id: string, input: UpdateUserInput): Promise<User>;
  delete(id: string): Promise<void>;
}
```

### Structured Logging

Use a structured logging service (Winston, Pino). Never use `console.log`, `console.warn`, or `console.error`.

```typescript
const logger = createLogger({ service: 'user-service' });

logger.info('User created', { userId: user.id, email: user.email });
logger.error('Failed to create user', { error: serializeError(err), input });
```

### Error Handling Middleware

```typescript
const errorHandler: ErrorRequestHandler = (err, req, res, _next) => {
  if (err instanceof ApplicationError) {
    res.status(err.statusCode).json(
      ApiResponse.error(err.message, err.code)
    );
    return;
  }

  logger.error('Unhandled error', { error: serializeError(err), path: req.path });
  res.status(500).json(ApiResponse.error('Internal server error', 'INTERNAL_ERROR'));
};
```

## Shared Standards (Both Stacks)

### RESTful API Design

| Method | Usage | Success Code |
|--------|-------|-------------|
| GET | Retrieve resource(s) | 200 |
| POST | Create resource | 201 |
| PUT | Full update | 200 |
| PATCH | Partial update | 200 |
| DELETE | Remove resource | 204 |

### Standard API Response Format

```typescript
interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T | null;
  errors: ErrorDetail[] | null;
  timestamp: string;
}
```

### Authentication

- Bearer JWT tokens in Authorization header
- Access token lifetime: 15-30 minutes
- Refresh tokens stored in httpOnly cookies
- Token refresh endpoint returns new access and refresh token pair

### Database Patterns

- Parameterized queries only (no string concatenation for SQL)
- Connection pooling configured for each environment
- Database migrations versioned and tracked (Flyway for Java, Knex/Prisma for Node)
- Indexes on frequently queried columns (foreign keys, status fields, timestamps)
- Soft delete preferred over hard delete for audit trails
