---
paths:
  - "**/*.spec.*"
  - "**/*.test.*"
  - "**/*.stories.*"
---

# Testing Standards

## Test Stack

| Tool | Purpose |
|---|---|
| **Vitest** | Test runner (Jest-compatible API) |
| **React Testing Library** | Component testing |
| **@vitest/coverage-v8** | Coverage reporting |
| **jsdom** | DOM simulation |

## Coverage Targets

| Scope | Minimum |
|---|---|
| Overall | 80% |
| Critical functions | 90% |
| UI Components | 85% |
| Utilities | 95% |

## AAA Pattern (Arrange-Act-Assert)

Every test must follow the AAA pattern with clear separation between setup, execution, and verification.

## Test Naming

- Format: `should [expected behavior] when [condition]`
- Language: **English** only.
- Be specific and descriptive.

```typescript
it("should display error message when email is invalid", () => {});
it("should call onSubmit when form is valid and button is clicked", () => {});
```

## File Naming

| File Type | Pattern |
|---|---|
| Unit tests | `component-name.spec.tsx` |
| Integration tests | `component-name.integration.spec.tsx` |
| Utils tests | `util-function.spec.ts` |
| Hook tests | `use-hook-name.spec.ts` |
| E2E tests | `feature-name.e2e.spec.tsx` |

## Component Test Pattern

```typescript
describe("ComponentName", () => {
  const createProps = (overrides = {}) => ({
    children: "Click me",
    variant: "primary",
    ...overrides,
  });

  describe("Rendering", () => { });
  describe("User Interactions", () => { });
  describe("Data Loading", () => { });
  describe("Error Handling", () => { });
  describe("Accessibility", () => { });
});
```

For components needing providers (QueryClient, Router), create a `renderWithProviders` helper.

## Hook Test Pattern

```typescript
import { renderHook, waitFor } from "@testing-library/react";

describe("useFormValidation", () => {
  it("should initialize with default values", () => {
    const { result } = renderHook(() => useFormValidation());
    expect(result.current.errors).toEqual({});
  });
});
```

## Mocking Strategies

- **API services**: `vi.mock("@services", () => ({ ... }))`
- **Router**: `vi.mock("react-router-dom", () => ({ useNavigate: () => vi.fn() }))`
- **Store**: `vi.mock("../store/use-store", () => ({ ... }))`
- Clear mocks in `beforeEach` with `vi.clearAllMocks()`.

## Test Data Factory

```typescript
export const createMockUser = (overrides = {}): User => ({
  id: "123",
  name: "John Doe",
  email: "john@example.com",
  ...overrides,
});
```

## Storybook Requirements

Every UI component must have a Storybook story covering: default state, all variants/sizes, loading state, error state, empty state, interactive states (hover, focus, disabled).

## What to Test vs What NOT to Test

| Test | Do NOT Test |
|---|---|
| Business logic | Framework internals |
| Edge cases | Getter/setter methods |
| Error paths | Third-party library internals |
| Public API | Private methods (test indirectly) |
| User interactions | Implementation details |
| Accessibility | CSS styling details |

## E2E Test Principles

- Test critical user journeys (login, checkout, form submission).
- Use `data-testid` attributes for element selection — never rely on CSS classes.
- Each E2E test must be independent and idempotent.
- Clean up test data after each test run.

## Backend Testing Standards (JUnit 5)

### Test Framework Stack

| Tool | Purpose |
|---|---|
| JUnit 5 | Test runner |
| Mockito | Mocking framework |
| AssertJ | Fluent assertions |
| Spring Boot Test | Integration testing |
| Testcontainers | Database integration tests |

### F.I.R.S.T. Principles

| Principle | Rule |
|---|---|
| Fast | Tests execute in milliseconds |
| Isolated | No shared state between tests |
| Repeatable | Same result every run, any environment |
| Self-validating | Pass or fail, no manual inspection |
| Timely | Written alongside or before production code |

### Coverage Targets (Backend)

| Scope | Minimum |
|---|---|
| Service layer | 90% |
| Controller layer | 80% |
| Repository layer | 70% (integration tests) |
| Utility classes | 95% |

### Parameterized Tests

Use `@ParameterizedTest` with `@CsvSource` or `@MethodSource` for multiple input scenarios.

### Integration Test Pattern

Use `@SpringBootTest` with `@Testcontainers` for database tests. Never mock the database in integration tests — use a real test database.

### Test Data Builder Pattern

Create builder classes for complex test objects to keep test setup clean and readable.
