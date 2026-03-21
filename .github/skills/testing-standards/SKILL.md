---
name: Testing Standards
description: >
  Testing standards for frontend and backend teams.
  Frontend: Vitest, React Testing Library, AAA methodology, Storybook.
  Backend: JUnit 5, Mockito, AssertJ, Spring Boot Test, JaCoCo.
  Used by Tier 1 (Principal), Tier 1.5 (Staff Engineer), and Tier 2 (MidCoder) agents.
estimated-tokens: 6600
used-by: [T1, T1.5, T2]
tiers:
  T1: optional
  T1.5: optional
  T2: optional
core-sections: ["Scope", "Testing Pyramid", "General Rules", "Frontend Testing Standards", "Backend Testing Standards"]
extended-sections: ["Advanced Patterns", "Mocking Strategy", "Test Data Management", "Performance Testing", "Examples"]
---

# Testing Standards Skill

## Scope

This skill defines testing standards for all code-producing agents.
Every new feature or component must include appropriate tests.

---

## Test Stack

| Tool                     | Purpose                  |
| ------------------------ | ------------------------ |
| **Vitest**               | Test runner (Jest-compatible API) |
| **React Testing Library**| Component testing        |
| **Vitest built-in**      | Assertions               |
| **Vitest vi**            | Mocking (Jest mock compatible) |
| **@vitest/coverage-v8**  | Coverage reporting       |
| **jsdom**                | DOM simulation           |

---

## Coverage Targets

| Scope               | Minimum Coverage |
| -------------------- | ---------------- |
| **Overall**          | 80%              |
| **Critical functions** | 90%            |
| **UI Components**    | 85%              |
| **Utilities**        | 95%              |

---

## AAA Pattern (Arrange-Act-Assert)

Every test must follow the AAA pattern:

```typescript
describe("ComponentName", () => {
  it("should do something when condition is met", () => {
    const mockProps = { title: "Test Title", type: "success" };
    const mockFunction = vi.fn();

    const { getByRole } = render(
      <Component {...mockProps} onClick={mockFunction} />
    );
    fireEvent.click(getByRole("button"));

    expect(mockFunction).toHaveBeenCalledWith(expectedValue);
    expect(getByRole("button")).toHaveAttribute("aria-pressed", "true");
  });
});
```

---

## Test Naming Convention

- Format: `should [expected behavior] when [condition]`
- Language: **English** only — no Turkish in test names.
- Be specific and descriptive.

```typescript
it("should display error message when email is invalid", () => {});
it("should call onSubmit when form is valid and button is clicked", () => {});
it("should render loading spinner when data is fetching", () => {});
```

---

## File Structure and Naming

```
component-name/
├── component-name.tsx
├── component-name.module.scss
├── component-name.types.ts
├── component-name.spec.tsx
├── component-name.integration.spec.tsx
├── component-name.e2e.spec.tsx
└── component-name.stories.tsx
```

| File Type         | Naming Pattern                        |
| ----------------- | ------------------------------------- |
| Unit tests        | `component-name.spec.tsx`             |
| Integration tests | `component-name.integration.spec.tsx` |
| Utils tests       | `util-function.spec.ts`               |
| Hook tests        | `use-hook-name.spec.ts`               |

---

## Component Test Patterns

### Atom Component Test

```typescript
import { render, screen, fireEvent } from "@testing-library/react";
import { describe, it, expect, vi } from "vitest";
import { AtomButton } from "./atom-button";

describe("AtomButton", () => {
  const createProps = (overrides = {}) => ({
    children: "Click me",
    variant: "primary",
    size: "medium",
    disabled: false,
    ...overrides,
  });

  describe("Rendering", () => {
    it("should render button with correct text", () => {
      render(<AtomButton {...createProps()} />);
      expect(
        screen.getByRole("button", { name: "Click me" })
      ).toBeInTheDocument();
    });
  });

  describe("User Interactions", () => {
    it("should call onClick when clicked", () => {
      const mockOnClick = vi.fn();
      render(<AtomButton {...createProps({ onClick: mockOnClick })} />);
      fireEvent.click(screen.getByRole("button"));
      expect(mockOnClick).toHaveBeenCalledTimes(1);
    });

    it("should not call onClick when disabled", () => {
      const mockOnClick = vi.fn();
      render(
        <AtomButton {...createProps({ onClick: mockOnClick, disabled: true })} />
      );
      fireEvent.click(screen.getByRole("button"));
      expect(mockOnClick).not.toHaveBeenCalled();
    });
  });

  describe("Accessibility", () => {
    it("should have correct ARIA attributes", () => {
      render(<AtomButton {...createProps({ "aria-label": "Custom label" })} />);
      expect(screen.getByRole("button")).toHaveAttribute(
        "aria-label",
        "Custom label"
      );
    });
  });
});
```

### Molecule Component Test (with Providers)

```typescript
import { render, screen } from "@testing-library/react";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

describe("MoleculeUserCard", () => {
  let queryClient: QueryClient;

  beforeEach(() => {
    queryClient = new QueryClient({
      defaultOptions: { queries: { retry: false } },
    });
    vi.clearAllMocks();
  });

  const renderWithProviders = (component: React.ReactElement) => {
    return render(
      <QueryClientProvider client={queryClient}>
        {component}
      </QueryClientProvider>
    );
  };

  describe("Loading State", () => {
    it("should show loading spinner when data is loading", () => {
      renderWithProviders(<MoleculeUserCard userId="123" />);
      expect(screen.getByRole("status")).toBeInTheDocument();
    });
  });
});
```

---

## Hook Testing Pattern

```typescript
import { renderHook, waitFor } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import { useFormValidation } from "./use-form-validation";

describe("useFormValidation", () => {
  it("should initialize with default values", () => {
    const { result } = renderHook(() => useFormValidation());
    expect(result.current.errors).toEqual({});
    expect(result.current.isValid).toBe(true);
  });
});
```

---

## Mocking Strategies

### API Service Mocking

```typescript
vi.mock("@services", () => ({
  userApi: {
    useQuery: vi.fn(),
  },
}));
```

### Router Mocking

```typescript
vi.mock('react-router-dom', () => ({
  useNavigate: () => vi.fn(),
  useParams: () => ({ id: '123' }),
  useLocation: () => ({ pathname: '/test' }),
}));
```

### Store Mocking

```typescript
vi.mock('../store/use-user-store', () => ({
  useUserStore: vi.fn(() => ({
    users: [],
    isLoading: false,
    fetchUsers: vi.fn(),
  })),
}));
```

---

## Test Data Management

### Test Factories

```typescript
export const createMockUser = (overrides = {}): User => ({
  id: "123",
  name: "John Doe",
  email: "john@example.com",
  ...overrides,
});

export const createMockUsers = (count: number): User[] => {
  return Array.from({ length: count }, (_, index) =>
    createMockUser({ id: String(index + 1), name: `User ${index + 1}` }),
  );
};
```

---

## Test Organization

```typescript
describe("ComponentName", () => {
  describe("Rendering", () => {});
  describe("User Interactions", () => {});
  describe("Data Loading", () => {});
  describe("Error Handling", () => {});
  describe("Accessibility", () => {});
});
```

---

## Storybook Requirements

- Every UI component must have a Storybook story.
- Stories must cover:
  - Default state
  - All variants/sizes
  - Loading state
  - Error state
  - Empty state
  - Interactive states (hover, focus, disabled)
- Stories must be visually verified across different viewports.

---

## What to Test vs What NOT to Test

| Test              | Do NOT Test                       |
| ----------------- | --------------------------------- |
| Business logic    | Framework internals               |
| Edge cases        | Getter/setter methods             |
| Error paths       | Third-party library internals     |
| Public API        | Private methods (test indirectly) |
| User interactions | Implementation details            |
| Accessibility     | CSS styling details               |

---

## Test Checklist

### Component

- [ ] Rendering with default props
- [ ] Rendering with different prop combinations
- [ ] User interactions (clicks, input changes)
- [ ] Loading, error, and empty states
- [ ] Accessibility attributes
- [ ] Conditional rendering logic
- [ ] Event handler calls

### Hook

- [ ] Initial state
- [ ] State updates
- [ ] Side effects and cleanup
- [ ] Error handling

### Utility

- [ ] Happy path scenarios
- [ ] Edge cases and boundary values
- [ ] Error handling
- [ ] Input validation

---

## E2E Testing Standards

End-to-end tests validate complete user flows across the application.

### E2E File Naming

| File Type | Naming Pattern              |
| --------- | --------------------------- |
| E2E tests | `feature-name.e2e.spec.tsx` |
| E2E utils | `e2e-helpers.ts`            |

### E2E Test Principles

- Test critical user journeys (login, checkout, form submission).
- Use data-testid attributes for element selection — never rely on CSS classes.
- Each E2E test must be independent and idempotent.
- Clean up test data after each test run.
- E2E tests run in CI pipeline, not as part of unit test suite.

### E2E Coverage Targets

| Scope               | Minimum Coverage |
| ------------------- | ---------------- |
| Critical user flows | 100%             |
| Secondary flows     | 70%              |
| Edge case flows     | 50%              |

---

## Backend Testing Standards (Java / JUnit 5)

### Backend Test Stack

| Tool                    | Purpose                                          |
| ----------------------- | ------------------------------------------------ |
| **JUnit 5**             | Test framework                                   |
| **Mockito / BDDMockito**| Mocking (given/willReturn style)                 |
| **AssertJ**             | Fluent assertions (preferred over JUnit asserts)  |
| **ArgumentCaptor**      | Capture and inspect arguments passed to mocks    |
| **Spring Boot Test**    | Integration tests (@SpringBootTest, @DataJpaTest)|
| **JaCoCo**              | Coverage reporting and enforcement               |

### F.I.R.S.T. Principles

| Principle              | Rule                                                  |
| ---------------------- | ----------------------------------------------------- |
| **Fast**               | < 100 ms per unit test; mock all external calls       |
| **Independent**        | No shared state; use @BeforeEach for clean setup      |
| **Repeatable**         | Deterministic; fixed dates, no randomness             |
| **Self-validating**    | Explicit assertions; no manual output inspection      |
| **Timely**             | Tests ship in the same PR as production code          |

### Coverage Targets

| Metric              | Minimum | Build Fails |
| ------------------- | ------- | ----------- |
| **Line coverage**   | 80%     | Yes         |
| **Branch coverage** | 70%     | Yes         |
| **Method coverage**  | 80%     | No          |

JaCoCo exclusions: `**/dto/**`, `**/entity/**`, `**/config/**`, `**/exception/**`, `**/*Application.class`, `**/mapper/*Impl.class`

### Test Class Structure and Naming

Name tests as `methodName_StateUnderTest_ExpectedBehavior`. Annotate with `@DisplayName`. Group related tests with `@Nested`.

```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private UserMapper userMapper;
    @InjectMocks
    private UserService userService;
    private User testUser;

    @BeforeEach
    void setUp() {
        testUser = User.builder().id(1L).username("john.doe")
                .email("john@example.com").active(true).build();
    }

    @Test
    @DisplayName("Should return dto when user exists")
    void getUserById_WhenUserExists_ShouldReturnUserDto() {
        given(userRepository.findById(1L)).willReturn(Optional.of(testUser));
        given(userMapper.toDto(testUser)).willReturn(expectedDto);
        UserDto result = userService.getUserById(1L);
        assertThat(result).isNotNull();
        assertThat(result.getUsername()).isEqualTo("john.doe");
        then(userRepository).should().findById(1L);
    }

    @Test
    @DisplayName("Should throw when user not found")
    void getUserById_WhenNotExists_ShouldThrowNotFoundException() {
        given(userRepository.findById(999L)).willReturn(Optional.empty());
        assertThatThrownBy(() -> userService.getUserById(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("999");
    }
}
```

### AssertJ, BDDMockito, and ArgumentCaptor

```java
assertThat(result).isNotNull();
assertThat(result.getName()).isEqualTo("John");
assertThat(list).hasSize(3).contains("a", "b");
assertThat(optional).isPresent().hasValue(expected);
assertThatThrownBy(() -> service.process(null))
        .isInstanceOf(IllegalArgumentException.class)
        .hasMessage("Input cannot be null");

given(repository.findById(1L)).willReturn(Optional.of(entity));
UserDto result = service.getUserById(1L);
then(repository).should().findById(1L);

ArgumentCaptor<User> captor = ArgumentCaptor.forClass(User.class);
then(userRepository).should().save(captor.capture());
assertThat(captor.getValue().getPassword()).isEqualTo("encoded");
```

### Parameterized Tests

```java
@ParameterizedTest
@CsvSource({"test@example.com, true", "invalid-email, false", "@bad.com, false"})
void validateEmail_ShouldMatchExpected(String email, boolean expected) {
    assertThat(validator.isValidEmail(email)).isEqualTo(expected);
}

@ParameterizedTest
@MethodSource("invalidPasswords")
void validatePassword_ShouldRejectInvalid(String password, String reason) {
    assertThat(validator.isValidPassword(password))
            .as("'%s' should fail: %s", password, reason).isFalse();
}

private static Stream<Arguments> invalidPasswords() {
    return Stream.of(
            Arguments.of("short", "fewer than 8 characters"),
            Arguments.of("nouppercase1", "no uppercase letter"),
            Arguments.of("NOLOWERCASE1", "no lowercase letter"));
}
```

### Integration Test Patterns

Use `@SpringBootTest` with `@AutoConfigureMockMvc` for controller tests and `@DataJpaTest` with `@TestPropertySource` for repository tests.

```java
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class UserControllerIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;
    @Autowired private UserRepository userRepository;

    @Test
    void createUser_ShouldReturn201() throws Exception {
        CreateUserRequest req = CreateUserRequest.builder()
                .username("john.doe").email("john@example.com")
                .password("password123").build();
        mockMvc.perform(post("/api/v1/users")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.data.username").value("john.doe"));
        assertThat(userRepository.findByEmail("john@example.com")).isPresent();
    }
}
```

### Test Data Builders

```java
public final class TestDataBuilder {
    public static User.UserBuilder aUser() {
        return User.builder().id(1L).username("default.user")
                .email("default@example.com").password("encoded").active(true);
    }
    public static CreateUserRequest.CreateUserRequestBuilder aCreateUserRequest() {
        return CreateUserRequest.builder().username("new.user")
                .email("new@example.com").password("password123");
    }
}
```

Usage: `User custom = TestDataBuilder.aUser().id(42L).username("custom").build();`

### Backend Test Checklist

- [ ] Service methods — happy path and error cases
- [ ] Controller endpoints — status codes and response shapes
- [ ] Input validation — reject malformed requests
- [ ] Authentication and authorization checks
- [ ] Database queries — correct data retrieval and mutation
- [ ] Error propagation — domain errors mapped to HTTP status codes
- [ ] Edge cases — null inputs, empty collections, boundary values
- [ ] Branch coverage — all if/else paths exercised
