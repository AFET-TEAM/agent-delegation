# Backend Security Standards

paths:
  - "src/**/*.java"
  - "src/**/security/**"
  - "src/**/auth/**"

## SQL Injection Prevention

Parameterized queries are mandatory. String concatenation in SQL is an auto-reject finding.

### Safe Patterns

```java
@Query("SELECT u FROM User u WHERE u.email = :email")
Optional<User> findByEmail(@Param("email") String email);
```

```java
jdbcTemplate.query(
    "SELECT * FROM users WHERE status = ? AND role = ?",
    new Object[]{status, role},
    userRowMapper
);
```

### Banned Patterns

```java
String query = "SELECT * FROM users WHERE email = '" + email + "'";

String query = String.format("SELECT * FROM users WHERE id = %s", id);

"SELECT * FROM users WHERE name LIKE '%" + searchTerm + "%'";
```

### Dynamic Queries

When dynamic query construction is necessary, use Criteria API or Specification pattern:

```java
public Specification<User> hasRole(String role) {
    return (root, query, criteriaBuilder) ->
        criteriaBuilder.equal(root.get("role"), role);
}
```

## XSS Prevention

### Output Encoding

```java
import org.springframework.web.util.HtmlUtils;

String safeOutput = HtmlUtils.htmlEscape(userInput);
```

### Validation on Input DTOs

```java
public record CreateCommentRequest(
        @NotBlank
        @Size(max = 2000)
        @SafeHtml
        String content
) {}
```

### Content-Type Enforcement

- API responses always set `Content-Type: application/json`
- File download endpoints set explicit content types (never rely on browser sniffing)
- Add `X-Content-Type-Options: nosniff` header globally

## Input Validation

### Bean Validation on Every DTO

```java
public record UpdateProfileRequest(
        @NotBlank @Size(min = 2, max = 100) String displayName,
        @Size(max = 500) String bio,
        @Pattern(regexp = "^https://.*") String avatarUrl
) {}
```

### Whitelist Validation for Enums and Choices

```java
public record FilterRequest(
        @NotNull SortDirection sortDirection,
        @NotNull @AllowedValues({"name", "date", "status"}) String sortField,
        @Min(1) @Max(100) int pageSize
) {}
```

### Path Traversal Prevention

- Reject any path containing `..`, `~`, or absolute path separators
- Normalize file paths before processing
- Restrict file access to a configured base directory

### File Upload Limits

| Constraint | Value |
|-----------|-------|
| Max file size | 10 MB (configurable per endpoint) |
| Allowed extensions | Explicit whitelist only |
| Content-type validation | Verify magic bytes, not just extension |
| Filename sanitization | Strip special characters, generate UUID-based names |

## Password Security

### Hashing

- BCrypt with cost factor 12 (minimum)
- Never store plaintext passwords
- Never log passwords (even hashed)

### Custom Validation

```java
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PasswordValidator.class)
public @interface ValidPassword {
    String message() default "Password does not meet requirements";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

### Password Policy

| Rule | Requirement |
|------|------------|
| Minimum length | 12 characters |
| Maximum length | 128 characters |
| Character classes | At least 3 of: uppercase, lowercase, digit, special |
| Common password check | Reject top 10,000 common passwords |
| History | Cannot reuse last 5 passwords |

## JWT Security

### Token Configuration

| Token | Lifetime | Storage |
|-------|---------|---------|
| Access token | 15-30 minutes | Memory (frontend) or Authorization header |
| Refresh token | 7-30 days | httpOnly, secure, sameSite cookie |

### JWT Rules

- No sensitive data in payload (no passwords, no PII beyond user ID)
- Use RS256 or ES256 algorithm (no HS256 with weak secrets)
- Include `iss`, `sub`, `exp`, `iat`, `jti` claims
- Validate all claims on every request
- Implement refresh token rotation (invalidate old refresh token on use)
- Maintain a token blacklist for logout and password change events

### Refresh Token Rotation

```
Client → /auth/refresh (with refresh token cookie)
Server → Validate refresh token
       → Invalidate old refresh token
       → Issue new access token + new refresh token
       → Return new tokens
```

## Rate Limiting

| Endpoint Category | Limit |
|------------------|-------|
| Authentication | 5 requests per minute per IP |
| Password reset | 3 requests per hour per email |
| API general | 100 requests per minute per user |
| File upload | 10 requests per hour per user |
| Public endpoints | 30 requests per minute per IP |

## CORS Configuration

```java
@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOrigins(List.of(allowedOrigins));
    configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE"));
    configuration.setAllowedHeaders(List.of("Authorization", "Content-Type"));
    configuration.setAllowCredentials(true);
    configuration.setMaxAge(3600L);
    return new UrlBasedCorsConfigurationSource() {{
        registerCorsConfiguration("/api/**", configuration);
    }};
}
```

- Never use `*` for allowed origins in production
- Explicitly list allowed methods and headers
- Set `maxAge` to reduce preflight requests

## Security Headers

| Header | Value |
|--------|-------|
| `X-Content-Type-Options` | `nosniff` |
| `X-Frame-Options` | `DENY` |
| `X-XSS-Protection` | `0` (rely on CSP instead) |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains` |
| `Content-Security-Policy` | Configured per application requirements |
| `Referrer-Policy` | `strict-origin-when-cross-origin` |

## Auto-Reject Anti-Patterns

These patterns trigger an automatic Critical finding in code review:

- String concatenation in SQL queries
- Raw user input rendered in HTML responses without encoding
- Hardcoded credentials or API keys
- `@Autowired` on fields (use constructor injection)
- Disabled CSRF protection without documented justification
- Wildcard CORS origins in non-development profiles
- JWT secret shorter than 256 bits
- Missing `@Transactional` on write operations
- `Exception` caught without logging or rethrowing

## Enforcement Hooks

The following hooks automatically block violations at `PreToolUse:Edit/Write` events. See `.claude/config/hook-registry.md` for the complete registry.

| Rule Topic | Enforcing Hook | File Path |
|---|---|---|
| SQL Injection Prevention | sql-injection-check.sh | `.claude/hooks/sql-injection-check.sh` |
| XSS Prevention | xss-prevention-check.sh | `.claude/hooks/xss-prevention-check.sh` |
| Path Traversal Prevention | path-traversal-check.sh | `.claude/hooks/path-traversal-check.sh` |
| CORS Wildcard | cors-wildcard-check.sh | `.claude/hooks/cors-wildcard-check.sh` |
| Constructor Injection (no @Autowired on fields) | field-injection-check.sh | `.claude/hooks/field-injection-check.sh` |

## Security Checklist

### Development

- [ ] All endpoints require authentication unless explicitly public
- [ ] Input validation on every DTO
- [ ] Parameterized queries for all database access
- [ ] Output encoding for user-generated content
- [ ] Rate limiting configured for sensitive endpoints
- [ ] Security headers applied globally

### Code Review

- [ ] No hardcoded secrets in source code
- [ ] No string concatenation in SQL
- [ ] No raw user input in responses
- [ ] Proper error handling (no stack traces in API responses)
- [ ] Authorization checks at service layer
- [ ] Sensitive data excluded from logs
