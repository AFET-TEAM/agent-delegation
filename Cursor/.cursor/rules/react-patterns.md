# React Patterns

## 1. Version-Aware Frontend Development

Before writing any React code, inspect the relevant `package.json` and determine:
- `react`
- `react-dom`
- UI library version
- testing library stack
- TypeScript version

If exact versions are missing, state the assumption explicitly.

## 2. UI State Discipline

Always account for:
- loading
- empty
- success
- error
- disabled/permission-limited

### Example

```tsx
type ScreenState<T> =
  | { status: "loading" }
  | { status: "empty" }
  | { status: "success"; data: T }
  | { status: "error"; message: string };
```

## 3. Component Boundaries

- keep components focused
- move business logic to hooks/services when component intent blurs
- use explicit prop contracts
- avoid giant multi-purpose presentational/behavioral hybrids

### Example

```tsx
interface UserListProps {
  state: ScreenState<User[]>;
  onRetry: () => void;
}

export function UserList({ state, onRetry }: UserListProps) {
  if (state.status === "loading") {
    return <Spin />;
  }

  if (state.status === "error") {
    return <Button onClick={onRetry}>Retry</Button>;
  }

  if (state.status === "empty") {
    return <Empty />;
  }

  return <List dataSource={state.data} renderItem={(user) => <List.Item>{user.name}</List.Item>} />;
}
```

## 4. Hooks Rules

- hooks at top level only
- custom hooks for reusable stateful logic
- async hooks should make pending/failure behavior explicit
- do not hide side effects behind misleading names

## 5. Forms

- validation explicit
- submit disabled/pending states visible
- user-readable error messages
- form schema or validation rules should be discoverable

## 6. Anti-Patterns

- hidden state transitions
- local component state representing server truth with no sync strategy
- optimistic updates without rollback/failure UX
- design-system bypasses for speed
