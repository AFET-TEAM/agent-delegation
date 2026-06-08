# Implementation Standards

## General Coding Rules

- TypeScript strict mode enabled (`strict: true` in tsconfig)
- Target ES2024 or later
- Use `const` by default, `let` when reassignment is necessary, never `var`
- Use `===` and `!==` exclusively (no loose equality)
- Use template literals instead of string concatenation
- Use optional chaining (`?.`) and nullish coalescing (`??`) over manual checks
- Use `readonly` for properties that should not be reassigned
- Prefer `interface` over `type` for object shapes (use `type` for unions, intersections, mapped types)

## Import Ordering

Imports must follow this exact group order with a blank line between each group:

1. Framework imports (`react`, `next`, `vue`)
2. Third-party library imports (`antd`, `axios`, `lodash-es`)
3. Internal absolute imports (`@/features/`, `@/shared/`)
4. Relative imports (`./`, `../`)

Within each group, sort alphabetically. Remove unused imports immediately.

## Error Handling

### Domain-Specific Error Classes

```typescript
class ApplicationError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

class NotFoundError extends ApplicationError {
  constructor(resource: string, identifier: string) {
    super(
      `${resource} with identifier ${identifier} not found`,
      'RESOURCE_NOT_FOUND',
      404
    );
  }
}

class ValidationError extends ApplicationError {
  constructor(
    public readonly field: string,
    public readonly constraint: string
  ) {
    super(
      `Validation failed for ${field}: ${constraint}`,
      'VALIDATION_ERROR',
      400
    );
  }
}
```

### Error Handling Rules

- Every `catch` block must perform a meaningful action: log, transform, or rethrow
- Empty catch blocks are forbidden
- Never use exceptions for control flow (use result types or early returns)
- Transform infrastructure errors into domain errors at the boundary
- Provide user-friendly messages separate from technical error details

## Common Patterns

### Factory Pattern

```typescript
interface NotificationSender {
  send(recipient: string, message: string): Promise<void>;
}

const createNotificationSender = (channel: NotificationChannel): NotificationSender => {
  const senders: Record<NotificationChannel, () => NotificationSender> = {
    email: () => new EmailSender(),
    sms: () => new SmsSender(),
    push: () => new PushSender(),
  };

  const createSender = senders[channel];

  if (!createSender) {
    throw new ValidationError('channel', `Unsupported channel: ${channel}`);
  }

  return createSender();
};
```

### Repository Pattern

```typescript
interface UserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<User>;
  delete(id: string): Promise<void>;
}
```

### Composition Over Inheritance

```typescript
const useFormField = (initialValue: string) => {
  const [value, setValue] = useState(initialValue);
  const [touched, setTouched] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleChange = (newValue: string) => {
    setValue(newValue);
    setTouched(true);
  };

  return { value, touched, error, setError, handleChange };
};
```

## Test Writing Guide

### Structure: AAA Pattern

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should return created user when input is valid', async () => {
      const repository = createMockUserRepository();
      const service = new UserService(repository);
      const input = buildValidUserInput();

      const result = await service.createUser(input);

      expect(result.email).toBe(input.email);
      expect(repository.save).toHaveBeenCalledWith(
        expect.objectContaining({ email: input.email })
      );
    });

    it('should throw ValidationError when email is already taken', async () => {
      const repository = createMockUserRepository({
        findByEmail: async () => buildExistingUser(),
      });
      const service = new UserService(repository);

      await expect(
        service.createUser(buildValidUserInput())
      ).rejects.toThrow(ValidationError);
    });
  });
});
```

### Test Naming Convention

`should [expected behavior] when [condition]`

### Test Rules

- One assertion per test (logical assertion, not literal)
- Use factory functions for test data (`buildValidUser()`, `createMockRepository()`)
- No implementation detail testing (test public API behavior)
- Mock at the boundary (repository, HTTP client), not internal functions
- Cover happy path, error path, and edge cases for every public function

## Task Completion Standards for Coding Agents

- Run the linter and fix all violations before marking a task complete
- Run the relevant test suite and ensure all tests pass
- Verify the build succeeds without errors or warnings
- Self-review against the code review checklist
- Ensure no `console.log`, `any`, `@ts-ignore`, or inline comments remain
