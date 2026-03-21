---
name: Backend Security
description: >
  Spring Boot security standards covering SQL injection, XSS, input validation,
  password hashing, JWT handling, and rate limiting for all backend tasks.
used-by: [T1, T1.5]
estimated-tokens: 4700
tiers:
  T1: optional
  T1.5: optional
---

# Backend Security Skill

> Scope: Spring Boot security standards — mandatory rules for every backend task.

---

## 1. SQL Injection Prevention

Parameterized queries are **mandatory**. String concatenation in SQL is **banned**.

| Rule                                  | Enforcement |
| ------------------------------------- | ----------- |
| String concatenation in SQL           | ❌ Banned    |
| Parameterized queries                 | ✅ Required  |
| Spring Data JPA derived queries       | ✅ Preferred |
| JPA `@Query` with named parameters    | ✅ Required  |

### ❌ Vulnerable — Auto-Reject

```java
public User findByUsername(String username) {
    String sql = "SELECT * FROM users WHERE username = '" + username + "'";
    return jdbcTemplate.queryForObject(sql, userRowMapper);
}
```

### ✅ Safe Approaches

```java
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
}
```

```java
public User findByUsername(String username) {
    String sql = "SELECT * FROM users WHERE username = ?";
    return jdbcTemplate.queryForObject(sql, userRowMapper, username);
}
```

```java
public List<User> findByStatus(String status) {
    String sql = "SELECT * FROM users WHERE status = :status";
    MapSqlParameterSource params = new MapSqlParameterSource();
    params.addValue("status", status);
    return namedParameterJdbcTemplate.query(sql, params, userRowMapper);
}
```

```java
@Query("SELECT u FROM User u WHERE u.username = :username")
Optional<User> findByUsername(@Param("username") String username);
```

---

## 2. XSS Prevention

All user-supplied text rendered in HTML must be escaped. JSON responses via Jackson are escaped automatically — but DTO validation adds a mandatory second layer.

### Output Encoding with HtmlUtils

```java
@GetMapping("/greeting")
public String greeting(@RequestParam String name, Model model) {
    String sanitized = HtmlUtils.htmlEscape(name);
    model.addAttribute("message", "Hello " + sanitized);
    return "greeting";
}
```

### DTO Pattern Validation

```java
public class CreateCommentRequest {

    @NotBlank
    @Size(max = 1000)
    @Pattern(regexp = "^[^<>]*$", message = "HTML characters are not allowed")
    private String content;
}
```

### Content-Type Enforcement

```java
@PostMapping(value = "/api/comments", consumes = MediaType.APPLICATION_JSON_VALUE)
public ResponseEntity<ServiceResponse<CommentDto>> create(
        @Valid @RequestBody CreateCommentRequest request) {
    CommentDto dto = commentService.create(request);
    return ResponseEntity.status(HttpStatus.CREATED).body(ServiceResponse.success(dto));
}
```

> Controllers map ServiceResponse<T> → ApiResponse<T> at the boundary. See api-integration skill for the frontend-facing contract.

---

## 3. Input Validation

### Bean Validation on DTOs

```java
public class CreateUserRequest {

    @NotBlank(message = "Email is required")
    @Email(message = "Must be a valid email address")
    @Size(max = 100)
    private String email;

    @NotBlank
    @Pattern(regexp = "^[a-zA-Z0-9_-]{3,20}$",
             message = "Username must be 3-20 alphanumeric characters")
    private String username;

    @NotBlank
    @ValidPassword
    private String password;

    @Past(message = "Birth date must be in the past")
    private LocalDate birthDate;
}
```

### Controller-Level @Valid

```java
@PostMapping("/api/users")
public ResponseEntity<ServiceResponse<UserDto>> register(
        @Valid @RequestBody CreateUserRequest request) {
    UserDto user = userService.register(request);
    return ResponseEntity.status(HttpStatus.CREATED).body(ServiceResponse.success(user));
}
```

### Whitelist Validation & Path Traversal Prevention

```java
@Service
public class FileService {

    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "pdf");
    private static final Path SAFE_DIR = Paths.get("/safe/directory");

    public void processFile(String filename) {
        if (!filename.matches("^[a-zA-Z0-9_.-]+$")) {
            throw new ValidationException("filename", "Invalid filename");
        }

        String extension = filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new ValidationException("filename", "File type not allowed");
        }

        if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
            throw new SecurityException("Path traversal detected");
        }

        Path filePath = SAFE_DIR.resolve(filename).normalize();
        if (!filePath.startsWith(SAFE_DIR)) {
            throw new SecurityException("Path traversal detected");
        }
    }
}
```

### File Upload Size Limit

```yaml
spring:
  servlet:
    multipart:
      max-file-size: 5MB
      max-request-size: 10MB
```

---

## 4. Password Security

Passwords must be hashed with **BCrypt at 12 rounds**. Plaintext storage or logging is **banned**.

### BCrypt Configuration

```java
@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }
}
```

### Registration Flow

```java
@Service
@RequiredArgsConstructor
public class UserService {

    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;

    public UserDto register(CreateUserRequest request) {
        String encodedPassword = passwordEncoder.encode(request.getPassword());

        User user = User.builder()
                .username(request.getUsername())
                .password(encodedPassword)
                .build();

        return UserMapper.toDto(userRepository.save(user));
    }
}
```

### @ValidPassword Annotation

```java
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PasswordConstraintValidator.class)
public @interface ValidPassword {
    String message() default "Invalid password";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

```java
public class PasswordConstraintValidator
        implements ConstraintValidator<ValidPassword, String> {

    @Override
    public boolean isValid(String password, ConstraintValidatorContext ctx) {
        if (password == null) return false;

        return password.length() >= 8
                && password.matches(".*[A-Z].*")
                && password.matches(".*[a-z].*")
                && password.matches(".*[0-9].*")
                && password.matches(".*[@#$%^&+=].*");
    }
}
```

---

## 5. JWT Security

| Rule                                   | Detail                              |
| -------------------------------------- | ----------------------------------- |
| Access token lifetime                  | 15–30 minutes                       |
| Refresh token lifetime                 | 7–30 days, httpOnly cookie          |
| SECRET_KEY source                      | Environment variable — never hardcoded |
| Token payload                          | Only `sub`, `iat`, `exp`, `roles`   |
| Sensitive data in payload              | ❌ Banned                            |
| Token in URL query parameter           | ❌ Banned (leaks to logs)            |
| Transport                              | HTTPS only                          |

### Token Generation

```java
@Service
public class JwtTokenProvider {

    @Value("${jwt.secret}")
    private String secretKey;

    @Value("${jwt.expiration:900000}")
    private Long jwtExpiration;

    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("roles", userDetails.getAuthorities()
                .stream()
                .map(GrantedAuthority::getAuthority)
                .toList());

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + jwtExpiration))
                .signWith(SignatureAlgorithm.HS512, secretKey)
                .compact();
    }
}
```

### Application Configuration

```yaml
jwt:
  secret: ${JWT_SECRET}
  expiration: 900000
```

### Refresh Token Rotation

Issue a **new** refresh token on every refresh request and invalidate the previous one. This limits the window of a stolen refresh token.

---

## 6. Rate Limiting

Apply per-endpoint rate limits — especially on authentication, registration, and password-reset routes.

```java
@Configuration
public class RateLimitConfig {

    @Bean
    public FilterRegistrationBean<RateLimitFilter> rateLimitFilter() {
        FilterRegistrationBean<RateLimitFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new RateLimitFilter());
        registration.addUrlPatterns("/api/auth/*");
        registration.setOrder(1);
        return registration;
    }
}
```

| Endpoint Pattern      | Max Requests | Window   |
| --------------------- | ------------ | -------- |
| `/api/auth/login`     | 10           | 1 minute |
| `/api/auth/register`  | 5            | 1 minute |
| `/api/auth/refresh`   | 20           | 1 minute |
| `/api/**` (default)   | 100          | 1 minute |

---

## 7. Security Checklist

### Development

- [ ] All inputs validated with Bean Validation and `@Valid`.
- [ ] All SQL queries use parameterized binding.
- [ ] Passwords hashed with BCrypt (12 rounds).
- [ ] No sensitive data in logs.
- [ ] Error messages do not expose internal details.
- [ ] File uploads restricted by whitelist and size limit.
- [ ] XSS protection active (output encoding + DTO validation).

### Production

- [ ] All secrets loaded from environment variables.
- [ ] HTTPS enforced.
- [ ] Error responses contain no stack traces or internal paths.
- [ ] Sensitive data masked in logs.
- [ ] Password policy enforced via `@ValidPassword`.
- [ ] Rate limiting enabled on auth endpoints.

### Code Review

- [ ] No hardcoded secrets or passwords.
- [ ] No SQL string concatenation.
- [ ] No unescaped user input in HTML output.
- [ ] No path traversal risk in file operations.
- [ ] No sensitive data logged.
- [ ] Input validation present on every mutation endpoint.

---

## 8. Anti-Patterns — Auto-Reject

Any PR containing the following patterns **must be rejected** without further review:

| Anti-Pattern                                    | Reason                          |
| ----------------------------------------------- | ------------------------------- |
| SQL built with string concatenation              | SQL injection                   |
| Plaintext password stored or logged              | Credential exposure             |
| Hardcoded `SECRET_KEY` or `jwt.secret` in source | Secret leakage                  |
| `@Query` without named parameters                | SQL injection risk              |
| Missing `@Valid` on `@RequestBody`               | Unvalidated input               |
| JWT expiration > 30 minutes                      | Excessive token lifetime        |
| File path built from raw user input              | Path traversal                  |
| Sensitive data in JWT payload                    | Token is not encrypted          |
| `catch (Exception e) {}` with empty body         | Silent failure hides attacks    |
| Disabled CSRF/CORS without documented reason     | Weakened security posture       |
