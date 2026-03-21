---
name: API Integration
description: >
  Frontend-backend integration contract covering response format,
  HTTP standards, pagination, error handling, authentication,
  and environment configuration for all full-stack tasks.
used-by: [T1, T1.5, T2]
estimated-tokens: 5200
tiers:
  T1: optional
  T1.5: optional
  T2: optional
core-sections: ["Scope", "Response Format", "HTTP Standards", "Error Handling", "Authentication"]
extended-sections: ["Pagination Patterns", "File Upload", "WebSocket", "Environment Configuration", "Examples"]
---

# API Integration Skill

## 1. Response Format

All endpoints wrap responses in `ApiResponse<T>`.

> **Note**: `ApiResponse<T>` is the **frontend-backend contract** wrapper. For internal service-layer communication in Spring Boot, `ServiceResponse<T>` (defined in `backend-development` skill) includes additional fields like `traceId` for observability. Agents should use `ApiResponse<T>` for controller/API responses and `ServiceResponse<T>` for internal service orchestration.

### TypeScript

```typescript
export interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T | null;
  errors?: ApiError[];
  timestamp: string;
}

export interface ApiError {
  field?: string;
  code: string;
  message: string;
}
```

> **Canonical format**: This `ApiResponse<T>` is the canonical API contract for all frontend-backend communication. The `backend-development/SKILL.md` Node.js section defines a simplified internal `ServiceResponse` pattern — when building API endpoints, always conform to this `ApiResponse<T>` shape for external responses.

### Java

```java
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private List<ApiError> errors;
    private LocalDateTime timestamp;
}

public class ApiError {
    private String field;
    private String code;
    private String message;
}
```

---

## 2. HTTP Standards

### Method Mapping

| Method   | Purpose              | Idempotent | Example                          |
| -------- | -------------------- | ---------- | -------------------------------- |
| `GET`    | Read / list          | Yes        | `GET /api/v1/documents/{id}`     |
| `POST`   | Create / search      | No         | `POST /api/v1/documents`         |
| `PUT`    | Full update          | Yes        | `PUT /api/v1/documents/{id}`     |
| `PATCH`  | Partial update       | No         | `PATCH /api/v1/documents/{id}/status` |
| `DELETE` | Remove               | Yes        | `DELETE /api/v1/documents/{id}`  |

> `POST /search` is acceptable for complex filters that exceed GET URL length limits.

### Status Code Mapping

| Code | Usage                              |
| ---- | ---------------------------------- |
| 200  | Successful read or update          |
| 201  | Successful creation                |
| 204  | Successful deletion (no body)      |
| 400  | Validation error, malformed input  |
| 401  | Unauthenticated                    |
| 403  | Unauthorized (insufficient perms)  |
| 404  | Resource not found                 |
| 409  | Conflict (duplicate, state issue)  |
| 422  | Unprocessable entity               |
| 500  | Internal server error              |

### JSON Convention

All request/response bodies use **camelCase** field names.

| Layer      | Convention  | Example                        |
| ---------- | ----------- | ------------------------------ |
| JSON       | camelCase   | `documentName`, `createdAt`    |
| Database   | snake_case  | `DOCUMENT_NAME`, `CREATED_AT`  |
| TypeScript | camelCase   | `documentName: string`         |

---

## 3. Pagination Contract

Frontend sends **1-based** page numbers. Backend converts to **0-based** internally.

### TypeScript

```typescript
export interface PaginationParams {
  page: number;
  pageSize: number;
  sortField?: string;
  sortDirection?: 'ASC' | 'DESC';
}

export interface PaginationMetadata {
  currentPage: number;
  pageSize: number;
  totalRecords: number;
  totalPages: number;
}
```

### Java

```java
public class PaginationParams {
    private Integer page;
    private Integer pageSize;
    private String sortField;
    private String sortDirection;
}

public class PaginationMetadata {
    private Integer currentPage;
    private Integer pageSize;
    private Long totalRecords;
    private Integer totalPages;
}
```

### Backend Conversion (Spring Data)

```java
int zeroBasedPage = request.getPagination().getPage() - 1;
int size = request.getPagination().getPageSize();
Pageable pageable = PageRequest.of(zeroBasedPage, size, sort);
```

---

## 4. Search & Filter

Complex search uses `POST /search` with a structured body.

### Request Structure

```typescript
export interface SearchRequest<F> {
  filters: F;
  pagination: PaginationParams;
}
```

```java
public class SearchRequest<F> {
    private F filters;
    private PaginationParams pagination;
}
```

### Response Structure

```typescript
export interface SearchResponse<R> {
  records: R[];
  pagination: PaginationMetadata;
}
```

```java
public class SearchResponse<R> {
    private List<R> records;
    private PaginationMetadata pagination;
}
```

### Filter Rules

- Filter fields use `camelCase` matching the resource property names.
- Unset filters are sent as `null` — backend ignores `null` filter values.
- On filter change, frontend resets page to `1`.

---

## 5. Date & Time

| Layer              | Format              | Timezone       |
| ------------------ | ------------------- | -------------- |
| Backend → Frontend | ISO 8601 UTC        | UTC            |
| Frontend → Backend | ISO 8601 UTC        | UTC            |
| Database           | TIMESTAMP           | Server default |
| UI Display         | Localized string    | User timezone  |

### Java Serialization

```java
@JsonFormat(
    pattern = "yyyy-MM-dd'T'HH:mm:ss'Z'",
    timezone = "UTC"
)
private LocalDateTime createdAt;
```

### TypeScript Display

```typescript
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc';
import timezone from 'dayjs/plugin/timezone';

dayjs.extend(utc);
dayjs.extend(timezone);

const formatDate = (iso: string): string => {
  if (!iso) return '-';
  return dayjs(iso).tz('Europe/Istanbul').format('DD.MM.YYYY HH:mm');
};
```

### TypeScript Submission

```typescript
const toUtcIso = (value: dayjs.Dayjs): string => {
  return dayjs(value).utc().toISOString();
};
```

---

## 6. Null & Empty Handling

| Scenario      | Backend Response | Frontend Handling      |
| ------------- | ---------------- | ---------------------- |
| No value      | `null`           | `null` or `undefined`  |
| Empty string  | `""`             | `""`                   |
| Empty array   | `[]`             | `[]`                   |
| Empty object  | `{}`             | `{}`                   |

### TypeScript Conventions

- Required fields: `fieldName: string`.
- Optional nullable fields: `fieldName?: string | null`.
- Use nullish coalescing: `value ?? fallback`.
- Use optional chaining: `data?.field` (max 3 levels deep).
- Default arrays: `const items = data?.records ?? []`.

### Java Conventions

- Use `@JsonInclude(JsonInclude.Include.NON_NULL)` on optional fields.
- Return `Optional<T>` from repository lookup methods.
- Throw `EntityNotFoundException` instead of returning `null`.

---

## 7. Error Handling Contract

### Error Codes (UPPERCASE_SNAKE_CASE)

| Code                      | HTTP | Description                          |
| ------------------------- | ---- | ------------------------------------ |
| `REQUIRED_FIELD`          | 400  | Required field is missing            |
| `INVALID_FORMAT`          | 400  | Value format is invalid              |
| `DUPLICATE_ENTRY`         | 409  | Unique constraint violation          |
| `NOT_FOUND`               | 404  | Resource does not exist              |
| `BUSINESS_RULE_VIOLATION` | 422  | Domain rule violated                 |
| `UNAUTHORIZED`            | 401  | Invalid or expired token             |
| `FORBIDDEN`               | 403  | Insufficient permissions             |
| `INTERNAL_ERROR`          | 500  | Unexpected server error              |

### Java Global Handler

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidation(
        MethodArgumentNotValidException ex
    ) {
        List<ApiError> errors = ex.getBindingResult()
            .getFieldErrors().stream()
            .map(e -> new ApiError(e.getField(), "REQUIRED_FIELD", e.getDefaultMessage()))
            .toList();
        return ResponseEntity.badRequest()
            .body(new ApiResponse<>(false, "Validation failed", null, errors, LocalDateTime.now()));
    }
}
```

### TypeScript Axios Interceptor

```typescript
axiosInstance.interceptors.response.use(
  (response) => response,
  (error: AxiosError<ApiResponse<null>>) => {
    const apiResponse = error.response?.data;
    if (apiResponse && !apiResponse.success) {
      notification.error({ message: apiResponse.message });
    }
    return Promise.reject(error);
  }
);
```

---

## 8. CORS Configuration

Backend must define an explicit origin allowlist per environment.

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
            .allowedOrigins(
                "http://localhost:4200",
                "http://localhost:4201"
            )
            .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true)
            .maxAge(3600);
    }
}
```

- Never use `allowedOrigins("*")` with `allowCredentials(true)`.
- Define separate origin lists per Spring profile (`dev`, `test`, `prod`).

---

## 9. Authentication Contract

- **Header**: `Authorization: Bearer <token>`.
- **Access token**: short-lived (15–30 min).
- **Refresh token**: long-lived (7–30 days), stored in httpOnly cookie.
- **401 response**: token expired or invalid — redirect to login.
- **403 response**: valid token but insufficient permissions — show error.

### TypeScript Request Interceptor

```typescript
axiosInstance.interceptors.request.use((config) => {
  const token = localStorage.getItem('authToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

### TypeScript 401 Handler

```typescript
axiosInstance.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('authToken');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);
```

---

## 10. Environment Configuration

Base URL comes from environment config. All endpoints use `/api/v1/` prefix.

```typescript
export interface SharedEnvironment {
  name: 'DEVELOPMENT' | 'TEST' | 'PRODUCTION';
  baseUrl: string;
  endpoints: Record<string, string>;
}

export const environment: SharedEnvironment = {
  name: 'DEVELOPMENT',
  baseUrl: 'http://localhost:8080',
  endpoints: {
    searchDocuments: '/api/v1/documents/search',
    saveDocuments: '/api/v1/documents/batch',
    deleteDocument: '/api/v1/documents',
  },
};
```

### Axios Instance

```typescript
import axios from 'axios';
import { environment } from '../environments/environment';

const axiosInstance = axios.create({
  baseURL: environment.baseUrl,
  timeout: 30000,
  headers: { 'Content-Type': 'application/json' },
});

export default axiosInstance;
```

---

## 11. Integration Checklist

| #  | Check                                                     | Owner    |
| -- | --------------------------------------------------------- | -------- |
| 1  | All endpoints return `ApiResponse<T>` wrapper             | Backend  |
| 2  | HTTP methods and status codes follow the mapping tables   | Backend  |
| 3  | JSON field names are camelCase                            | Both     |
| 4  | Pagination uses 1-based page numbers in the contract      | Both     |
| 5  | Dates are ISO 8601 UTC in transit, localized on display   | Both     |
| 6  | Null fields use `null` (not `undefined`) in JSON          | Backend  |
| 7  | Error codes are UPPERCASE_SNAKE_CASE                      | Backend  |
| 8  | Axios interceptor handles global errors and 401 redirect  | Frontend |
| 9  | CORS allows only explicit origins per environment         | Backend  |
| 10 | Bearer JWT token sent on every authenticated request      | Frontend |
| 11 | Base URL and endpoints come from environment config       | Frontend |
| 12 | Frontend and backend types match field-for-field          | Both     |
