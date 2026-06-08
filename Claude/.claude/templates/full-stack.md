# Full-Stack Project Template

## Architecture Overview

```
┌─────────────────────────────────────────┐
│              Frontend (React SPA)         │
│  React 18 + TypeScript + Vite + Ant Design│
├─────────────────────────────────────────┤
│              API Gateway / BFF            │
│         REST API (JSON, camelCase)        │
├─────────────────────────────────────────┤
│            Backend (Spring Boot)          │
│  Java 11+ + Spring Boot 3.x + Maven      │
├─────────────────────────────────────────┤
│              Database Layer               │
│     PostgreSQL / MySQL + Redis Cache      │
└─────────────────────────────────────────┘
```

## API Contract

### Response Format (shared)

```typescript
interface ApiResponse<T> {
  success: boolean;
  message: string;
  data: T | null;
  errors?: ApiError[];
  timestamp: string;
}
```

### Communication Standards

| Aspect | Convention |
|--------|-----------|
| JSON fields | camelCase |
| Date format | ISO 8601 UTC in transit, localized on display |
| Timezone | Europe/Istanbul for UI display |
| Pagination | 1-based frontend, 0-based backend |
| Auth | Bearer JWT in Authorization header |
| Error codes | UPPERCASE_SNAKE_CASE |

### HTTP Methods

| Method | Frontend Action | Backend Handler |
|--------|---------------|-----------------|
| GET | TanStack Query fetch | @GetMapping |
| POST | mutation + invalidation | @PostMapping |
| PUT | mutation + invalidation | @PutMapping |
| PATCH | mutation + invalidation | @PatchMapping |
| DELETE | mutation + invalidation | @DeleteMapping |

## Shared Types Strategy

- Frontend defines TypeScript interfaces matching backend DTOs
- Backend generates OpenAPI spec, frontend can auto-generate types
- Enum values shared via constants (not string literals)
- Pagination params and response metadata standardized

## Development Workflow

1. Backend defines API contract (OpenAPI spec)
2. Frontend and backend develop in parallel against the contract
3. Integration testing validates contract compliance
4. Both stacks follow the same code review and PR standards

## Environment Configuration

| Environment | Frontend | Backend |
|-------------|----------|---------|
| Development | localhost:5173 | localhost:8080 |
| Staging | staging.app.com | staging-api.app.com |
| Production | app.com | api.app.com |

Frontend uses Vite proxy in development to avoid CORS issues.
