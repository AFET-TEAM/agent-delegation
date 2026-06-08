---
name: Testing Standards
description: >
  Test design skill for validating behavior changes with happy-path, edge, failure, and regression coverage.
estimated-tokens: 3000
used-by: [T1, T2, T3]
tiers:
  T1: optional
  T2: mandatory
  T3: mandatory
---

# Testing Standards Skill

## Purpose

Turns “I changed code” into “I have evidence the change is safe enough.”

## Coverage Model

- happy path
- edge cases
- failure modes
- regression path for bug fixes

## Framework-Aware Examples

### Frontend
```tsx
it("renders empty state when user list is empty", async () => {
  render(<UserListScreen />);
  expect(await screen.findByText(/no users/i)).toBeInTheDocument();
});
```

### Backend
```java
@Test
void shouldThrowWhenUserDoesNotExist() {
    when(userRepository.findById("1")).thenReturn(Optional.empty());
    assertThatThrownBy(() -> userService.getById("1")).isInstanceOf(UserNotFoundException.class);
}
```

## Anti-Patterns

- asserting implementation details over behavior
- no failure-path coverage on risky logic
- brittle giant test setup

## Quality Goal

Tests should increase confidence, not just increase line count.
