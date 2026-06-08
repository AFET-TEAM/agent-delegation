# Testing Standards

## 1. Baseline

Every meaningful change should come with a validation story.

## 2. Structure

Prefer AAA:
- Arrange
- Act
- Assert

## 3. Coverage Expectations

Think in three buckets:
- happy path
- edge cases
- failure path

## 4. Bug Fix Rule

A bug fix should include a regression test whenever practical.

## 5. Frontend Examples

```tsx
it("shows retry action when fetch fails", async () => {
  render(<UserListScreen />);
  expect(await screen.findByRole("button", { name: /retry/i })).toBeInTheDocument();
});
```

## 6. Backend Examples

```java
@Test
void shouldReturnUserWhenIdExists() {
    when(userRepository.findById("1")).thenReturn(Optional.of(user));
    UserResponse response = userService.getById("1");
    assertThat(response.id()).isEqualTo("1");
}
```

## 7. Anti-Patterns

- testing internals instead of behavior
- no negative-path coverage on risky logic
- giant brittle test setup with poor readability
