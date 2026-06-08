---
paths:
  - "src/services/**"
  - "src/**/service.*"
  - "src/**/*.service.*"
  - "src/config/env*"
  - "src/environments/**"
---

# API Integration Contract

## Response Format

All API responses follow `ApiResponse<T>`:

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

## HTTP Standards

| Method | Purpose | Idempotent |
|---|---|---|
| `GET` | Read / list | Yes |
| `POST` | Create / search | No |
| `PUT` | Full update | Yes |
| `PATCH` | Partial update | No |
| `DELETE` | Remove | Yes |

`POST /search` is acceptable for complex filters exceeding GET URL length limits.

## Status Codes

| Code | Usage |
|---|---|
| 200 | Successful read or update |
| 201 | Successful creation |
| 204 | Successful deletion (no body) |
| 400 | Validation error |
| 401 | Unauthenticated |
| 403 | Unauthorized |
| 404 | Not found |
| 409 | Conflict |
| 500 | Server error |

## Pagination

Frontend sends **1-based** page numbers:

```typescript
export interface PaginationParams {
  page: number;
  pageSize: number;
  sortField?: string;
  sortDirection?: "ASC" | "DESC";
}

export interface PaginationMetadata {
  currentPage: number;
  pageSize: number;
  totalRecords: number;
  totalPages: number;
}
```

On filter change, frontend resets page to `1`.

## Date & Time

- Backend <-> Frontend: ISO 8601 UTC.
- UI Display: Localized via dayjs with `Europe/Istanbul` timezone.
- Format: `DD.MM.YYYY HH:mm`.

## Null & Empty Handling

- Required fields: `fieldName: string`.
- Optional nullable: `fieldName?: string | null`.
- Nullish coalescing: `value ?? fallback`.
- Optional chaining: `data?.field` (max 3 levels deep).
- Default arrays: `const items = data?.records ?? []`.

## Error Codes (UPPERCASE_SNAKE_CASE)

`REQUIRED_FIELD` (400), `INVALID_FORMAT` (400), `DUPLICATE_ENTRY` (409), `NOT_FOUND` (404), `BUSINESS_RULE_VIOLATION` (422), `UNAUTHORIZED` (401), `FORBIDDEN` (403), `INTERNAL_ERROR` (500).

## Axios Patterns

- Auth interceptor: Attach `Authorization: Bearer <token>` from localStorage.
- Error interceptor: Show `notification.error` for API errors.
- 401 handler: Remove token, redirect to `/login`.
- Base URL from environment config. All endpoints use `/api/v1/` prefix.

## JSON Convention

All request/response bodies use **camelCase** field names.

## Authentication

- Header: `Authorization: Bearer <token>`.
- Access token: short-lived (15-30 min).
- Refresh token: long-lived, httpOnly cookie.

## CORS Configuration

- Allowed origins: configured per environment (never wildcard in production)
- Allowed methods: GET, POST, PUT, PATCH, DELETE, OPTIONS
- Allowed headers: Authorization, Content-Type, X-Request-ID
- Max age: 3600 seconds
- Credentials: true (for cookie-based refresh tokens)

## Retry & Circuit Breaker

- Retry policy: max 3 attempts with exponential backoff (1s, 2s, 4s)
- Circuit breaker: open after 5 consecutive failures, half-open after 30s
- Timeout: 10s for standard requests, 30s for file uploads, 60s for reports
- Idempotent operations (GET, PUT, DELETE) are safe to retry
- Non-idempotent operations (POST) require idempotency key header

## File Upload

- Max file size: 10MB (configurable per endpoint)
- Allowed types: validated by MIME type AND extension
- Upload endpoint: multipart/form-data
- Response includes file URL, size, and content type
- Progress tracking via upload events
