---
name: test-gen
description: Generate test suites from implementation files. Supports Jest, Vitest, and pytest. Produces AAA-structured tests covering happy path, error paths, and edge cases.
---

# Test Generation Skill

## Purpose

Generates test suites for existing implementation files. Takes one or more source files as input and produces corresponding test files following the AAA (Arrange-Act-Assert) pattern.

## Activation

Use this skill via the T3 MidCoder agent when:
- A new feature or service has been implemented without tests
- An existing module needs test coverage increased
- The task explicitly requests test generation

## Supported Frameworks

| Framework | Language | Config Detection |
|-----------|----------|-----------------|
| Jest | TypeScript / JavaScript | `jest.config.*` or `"jest"` in `package.json` |
| Vitest | TypeScript / JavaScript | `vitest.config.*` or `"vitest"` in `package.json` |
| pytest | Python | `pytest.ini`, `pyproject.toml [tool.pytest]`, or `setup.cfg [tool:pytest]` |

## Usage

### Trigger Phrase

Ask the Orchestrator or T3 agent:
```
"Generate tests for src/features/user/user-service.ts"
"Add test coverage for the auth module"
"Write tests for UserRepository"
```

### What Gets Generated

For each source file, the skill produces:

1. **Unit tests** — covering each exported function/class method
2. **Error path tests** — for every `catch` block and thrown error
3. **Edge case tests** — boundary values, null/undefined inputs, empty collections

### Output Location

Tests are co-located with the source file:
- `src/features/user/user-service.ts` → `src/features/user/user-service.test.ts`
- `src/features/user/user-repository.ts` → `src/features/user/user-repository.test.ts`

For Python:
- `src/services/user_service.py` → `tests/test_user_service.py`

## Test Structure (TypeScript/Jest/Vitest)

Generated tests follow the pattern from `.claude/rules/implementation.md`:

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should return created user when input is valid', async () => {
      // Arrange
      const repository = createMockUserRepository();
      const service = new UserService(repository);
      const input = buildValidUserInput();

      // Act
      const result = await service.createUser(input);

      // Assert
      expect(result.email).toBe(input.email);
    });

    it('should throw ValidationError when email is already taken', async () => {
      // Arrange
      const repository = createMockUserRepository({
        findByEmail: async () => buildExistingUser(),
      });
      const service = new UserService(repository);

      // Act & Assert
      await expect(service.createUser(buildValidUserInput())).rejects.toThrow(ValidationError);
    });
  });
});
```

## Naming Convention

Test function naming follows: `should [expected behavior] when [condition]`

Examples:
- `should return null when user not found`
- `should throw ValidationError when email format is invalid`
- `should call repository.save with correct user data when input is valid`

## Quality Checklist

Before marking test generation complete:

- [ ] Every exported function/method has at least one test
- [ ] Every error path (catch block, thrown error) has a test
- [ ] Factory functions used for test data (no inline object literals)
- [ ] Mocks placed at the boundary (repository, HTTP client), not internal functions
- [ ] Test file passes the test runner with zero failures
- [ ] No `console.log` in test files
- [ ] No `any` type in test files

## Limitations

- Does not generate integration tests (those require environment setup)
- Does not generate snapshot tests for React components (use Storybook for visual regression)
- Does not infer business rules from comments — reads only the actual function signatures and code paths

## References

- `.claude/rules/implementation.md` §Test Writing Guide — AAA pattern, naming convention, rules
- `.claude/rules/code-review.md` §Testing — review checklist for tests
