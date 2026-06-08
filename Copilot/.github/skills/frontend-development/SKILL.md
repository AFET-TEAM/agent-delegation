---
name: Frontend Development
description: >
  Frontend development skill covering JavaScript (ES2024+),
  React 18/19, Ant Design 5.x/6.x, and micro-frontend standards.
  Supports version-aware development via package.json detection.
  Covers component architecture, state management, hooks patterns,
  performance optimization, and design system best practices.
estimated-tokens: 7200
used-by: [T1, T2, T3]
tiers:
  T1: optional
  T2: optional
  T3: optional
core-sections: ["Scope", "Version Detection Protocol", "Component Architecture", "State Management", "Hooks Rules", "Ant Design Standards"]
extended-sections: ["Performance Optimization", "Advanced Patterns", "Micro-Frontend Integration", "Examples"]
---

# Frontend Development Skill

## Scope

This skill is **mandatory** for all frontend coding tasks. It covers:

- Modern JavaScript / TypeScript best practices
- React component architecture and patterns (React 18 and React 19)
- Ant Design component library usage (v5.x and v6.x)
- React Hook Form + Yup/Zod form management
- Micro-frontend architecture patterns (Module Federation)
- Performance optimization
- Accessibility standards

---

## Version Detection Protocol

**Before writing any frontend code**, the agent MUST detect the project's framework versions:

### Step 1: Read package.json

```
Read the project's root package.json (or the relevant micro-frontend's package.json).
Extract these dependency versions:
- react / react-dom → determines React 18 vs 19 rules
- antd → determines Ant Design 5 vs 6 rules
- typescript → determines TS feature availability
```

### Step 2: Apply Version-Conditional Rules

| Dependency | Version | Rule Set |
|-----------|---------|----------|
| `react` | `^18.x` | React 18 rules (see §React 18 Specifics) |
| `react` | `^19.x` | React 19 rules (see §React 19 Specifics) |
| `antd` | `^5.x` | Ant Design 5 rules (CSS-in-JS tokens) |
| `antd` | `^6.x` | Ant Design 6 rules (CSS Variables, new APIs) |

### Step 3: Report Version Context

Include detected versions in task output:

```
**Stack**: React {version}, Ant Design {version}, TypeScript {version}
**Rule Set**: React 19 + Ant Design 6
```

> **If package.json is unavailable**: Default to React 18 + Ant Design 5 rules. Note the assumption in output.

---

## JavaScript / TypeScript Standards

### Modern Syntax (ES2024+)

```typescript
const userName = user?.profile?.name ?? "Anonymous";
const copy = structuredClone(originalObject);
const lastItem = items.at(-1);
const grouped = Object.groupBy(users, (user) => user.role);
const { promise, resolve, reject } = Promise.withResolvers<Data>();
```

### TypeScript Strict Rules

- `strict: true` always enabled in `tsconfig.json`.
- No `any` — use `unknown` and narrow with type guards.
- Prefer `interface` for object shapes, `type` for unions/intersections.
- Use `as const` for literal types and `satisfies` for type validation.
- Discriminated unions over optional properties for state modeling.

```typescript
type AsyncState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: Error };
```

### Immutability

- Prefer `const` over `let`. Never use `var`.
- Use spread operator or `structuredClone` for copies.
- No direct mutation of objects or arrays — always return new references.
- Use `readonly` modifier for properties that should not change.

---

## React Architecture

### Component Design Principles

| Principle | Rule |
|-----------|------|
| **Single Responsibility** | One component = one UI concern |
| **Composition over Inheritance** | Build complex UI from small, composable pieces |
| **Colocation** | Keep related files together (component + hook + types + test) |
| **Minimal Props** | Maximum 5 props — use composition or context for more |
| **Controlled by Default** | Components are controlled unless explicitly uncontrolled |

### Component Declaration

- Components must be declared using `function` keyword (not `const` arrow function).
- Component files use PascalCase naming. Non-component files use kebab-case.
- Maximum **300 lines** per component — split logic/styles when exceeded.

> **Alignment with clean-code**: The general file limit is 250 lines (`clean-code/SKILL.md`). Frontend components are allowed 300 lines as a domain-specific override.

- Prefer `interface` for props. Use `type` only for unions, intersections, and mapped types.

### Component Structure

```typescript
import { useState, useCallback } from "react";
import { Button, Space } from "antd";

import type { UserFormProps } from "./types";
import { useUserValidation } from "./hooks/use-user-validation";
import { UserNameField } from "./components/user-name-field";

export function UserForm({ onSubmit, initialValues }: UserFormProps) {
  const [formData, setFormData] = useState(initialValues);
  const { validate, errors } = useUserValidation();

  const handleSubmit = useCallback(() => {
    const result = validate(formData);
    if (result.ok) onSubmit(result.value);
  }, [formData, validate, onSubmit]);

  return (
    <Space direction="vertical" size="middle">
      <UserNameField
        value={formData.name}
        error={errors.name}
        onChange={(name) => setFormData((prev) => ({ ...prev, name }))}
      />
      <Button type="primary" onClick={handleSubmit}>
        Submit
      </Button>
    </Space>
  );
}
```

---

## React 18 Specifics

> **Applies when**: `react` version in package.json is `^18.x`

### Hooks

| Hook | When to Use | Rule |
|------|-------------|------|
| `useState` | Simple local state | Keep state minimal — derive what you can |
| `useReducer` | Complex state logic (3+ related states) | Use discriminated union for actions |
| `useMemo` | Expensive computation or referential stability | Only when profiler confirms need |
| `useCallback` | Stable callback refs (passed to memoized children) | Not needed for inline event handlers |
| `useRef` | DOM access or mutable value without re-render | Never for state that affects render |
| `useEffect` | External system synchronization | Not for derived state or event-driven logic |
| `useTransition` | Non-urgent state updates | Wrap expensive re-renders for responsiveness |
| `useDeferredValue` | Deferred rendering of expensive UI | Alternative to debouncing for search inputs |

### Concurrent Features (React 18)

- Use `<Suspense>` for code splitting at route boundaries with `React.lazy()`.
- Use `useTransition` for non-blocking updates (search, filtering, tab switching).
- Use `useDeferredValue` for derived values that can lag behind.
- Automatic batching is enabled — no need for `unstable_batchedUpdates`.

### Memoization (React 18)

- `React.memo()` — only for components that re-render with identical props.
- `useMemo` / `useCallback` — only when profiler confirms performance gain.
- Do NOT wrap every component in `React.memo` — measure first.

### forwardRef (React 18)

```typescript
const Input = forwardRef<HTMLInputElement, InputProps>(function Input(props, ref) {
  return <input ref={ref} {...props} />;
});
```

---

## React 19 Specifics

> **Applies when**: `react` version in package.json is `^19.x`

### New Hooks (React 19)

| Hook | Purpose | Replaces |
|------|---------|----------|
| `use()` | Read promises and context in render | `useEffect` for data fetching, `useContext` |
| `useActionState` | Form action state management | Manual `useState` + `useTransition` combos |
| `useFormStatus` | Pending state for parent `<form>` | Custom loading state management |
| `useOptimistic` | Optimistic UI updates | Manual optimistic patterns with rollback |

### use() Hook

```typescript
function UserProfile({ userPromise }: { userPromise: Promise<User> }) {
  const user = use(userPromise);
  return <h1>{user.name}</h1>;
}

function UserPage({ userId }: { userId: string }) {
  const userPromise = fetchUser(userId);
  return (
    <Suspense fallback={<Spin />}>
      <UserProfile userPromise={userPromise} />
    </Suspense>
  );
}
```

### use() for Context

```typescript
function ThemeButton() {
  const theme = use(ThemeContext);
  return <Button style={{ color: theme.primary }}>Themed</Button>;
}
```

### Form Actions (React 19)

```typescript
function CreateTodoForm() {
  const [state, formAction, isPending] = useActionState(createTodoAction, { error: null });

  return (
    <form action={formAction}>
      <Input name="title" />
      {state.error && <Alert type="error" message={state.error} />}
      <SubmitButton />
    </form>
  );
}

function SubmitButton() {
  const { pending } = useFormStatus();
  return <Button type="primary" htmlType="submit" loading={pending}>Create</Button>;
}
```

### useOptimistic (React 19)

```typescript
function TodoList({ todos, addTodoAction }: TodoListProps) {
  const [optimisticTodos, addOptimistic] = useOptimistic(
    todos,
    (state: Todo[], newTodo: string) => [...state, { id: crypto.randomUUID(), title: newTodo, pending: true }]
  );

  async function handleAdd(formData: FormData) {
    const title = formData.get("title") as string;
    addOptimistic(title);
    await addTodoAction(title);
  }

  return (
    <form action={handleAdd}>
      <List dataSource={optimisticTodos} renderItem={(todo) => (
        <List.Item style={{ opacity: todo.pending ? 0.5 : 1 }}>{todo.title}</List.Item>
      )} />
    </form>
  );
}
```

### ref as Prop (React 19)

```typescript
function Input({ ref, ...props }: InputProps & { ref?: React.Ref<HTMLInputElement> }) {
  return <input ref={ref} {...props} />;
}
```

> `forwardRef` is **deprecated** in React 19. Pass `ref` as a regular prop instead.

### React Compiler (React 19)

When React Compiler is enabled in the project:
- **Remove** manual `useMemo`, `useCallback`, and `React.memo` — the compiler handles memoization automatically.
- Check `babel.config.js` or `vite.config.ts` for `babel-plugin-react-compiler` or `reactCompiler` plugin.
- If compiler is NOT enabled, continue using manual memoization as in React 18 rules.

### Migration Notes (18 → 19)

When working on a project migrating from React 18 to 19:
- Replace `forwardRef` wrappers with direct `ref` prop.
- Replace `useContext(Ctx)` calls with `use(Ctx)` where beneficial.
- Replace manual `useEffect` data fetching with `use(promise)` + `<Suspense>`.
- Remove manual memoization if React Compiler is enabled.
- Replace `ReactDOM.render()` if still present (was removed in 18, some projects still have it).

---

## Ant Design Standards

### Version Detection

Read `antd` version from package.json to determine which rule set applies.

### Ant Design 5.x Rules

> **Applies when**: `antd` version is `^5.x`

#### Theming (CSS-in-JS Token System)

- Use `ConfigProvider` with `theme.token` for global customization.
- Use `theme.components` for component-level overrides.
- Access tokens in components via `theme.useToken()`.
- Never override styles with CSS `!important`.

```typescript
<ConfigProvider theme={{
  token: { colorPrimary: "#1677ff", borderRadius: 6 },
  components: { Button: { colorPrimary: "#52c41a" } }
}}>
  <App />
</ConfigProvider>
```

#### Component API (v5)

| Category | Components | Rules |
|----------|-----------|-------|
| **Layout** | `Layout`, `Grid`, `Space`, `Flex` | Use `Flex` for 1D, `Grid` for 2D |
| **Navigation** | `Menu`, `Breadcrumb`, `Tabs` | Use `items` prop (not JSX children) |
| **Data Entry** | `Input`, `Select`, `DatePicker` | Wrap with React Hook Form `Controller` |
| **Data Display** | `Table`, `List`, `Card` | Provide `rowKey`, paginate 20+ items |
| **Feedback** | `message`, `notification`, `Modal` | Use static methods: `message.success()` |

### Ant Design 6.x Rules

> **Applies when**: `antd` version is `^6.x`

#### CSS Variables (v6 Default)

Ant Design 6 uses **CSS Variables** by default instead of CSS-in-JS runtime:

```typescript
<ConfigProvider theme={{
  cssVar: true,
  token: { colorPrimary: "#1677ff" }
}}>
  <App />
</ConfigProvider>
```

- CSS Variables are enabled by default in v6 — no opt-in needed.
- Performance is significantly better than v5 CSS-in-JS (no runtime style injection).
- Custom themes work via CSS variable overrides: `--ant-color-primary: #1677ff;`
- `theme.useToken()` still works but returns CSS variable references.

#### Component API Changes (v6)

- `Tabs` — `destroyInactiveTabPane` renamed to `destroyOnHide`.
- `Modal` / `Drawer` — `destroyOnClose` is now `true` by default.
- `Tooltip` / `Popover` — `getPopupContainer` renamed to `getTooltipContainer`.
- `DatePicker` — dayjs is still the default, but date-fns adapter is first-class.
- `Form` — Native form validation integration improved with React 19 Actions.
- `Spin` — New `percent` prop for determinate progress spinners.
- `Splitter` — New component for resizable panels.

#### Migration Notes (5 → 6)

When working on a project migrating from Ant Design 5 to 6:
- Enable CSS Variables: Already default in v6, but verify `ConfigProvider` setup.
- Update renamed props: `destroyInactiveTabPane` → `destroyOnHide`, etc.
- Remove manual `cssVar: true` if upgrading from v5 with opt-in CSS vars.
- Test theme customizations — CSS variable naming may differ from v5 token keys.
- Check for deprecated component imports (some components restructured).

### Ant Design Anti-Patterns (All Versions)

- ❌ Never use CSS `!important` to override Ant Design styles.
- ❌ Never import the entire library — always use named imports.
- ❌ Never use deprecated API patterns (JSX children for Menu, Table columns as JSX).
- ❌ Never mix Ant Design with another UI library (MUI, Chakra, etc.).
- ❌ Never hardcode colors — use design tokens via `theme.useToken()`.

---

## Custom Hook Patterns

Custom hooks must return typed state. Use `AbortController` for cleanup in async hooks:

### React 18 Pattern

```typescript
function useAsyncData<T>(fetcher: () => Promise<T>): AsyncState<T> {
  const [state, setState] = useState<AsyncState<T>>({ status: "idle" });

  useEffect(() => {
    const controller = new AbortController();
    setState({ status: "loading" });
    fetcher()
      .then((data) => { if (!controller.signal.aborted) setState({ status: "success", data }); })
      .catch((error) => { if (!controller.signal.aborted) setState({ status: "error", error }); });
    return () => controller.abort();
  }, [fetcher]);

  return state;
}
```

### React 19 Pattern

```typescript
function UserData({ userId }: { userId: string }) {
  const data = use(fetchUser(userId));
  return <div>{data.name}</div>;
}
```

> In React 19, prefer `use()` + `<Suspense>` over custom async hooks with `useEffect`.

---

## State Management Rules

1. **Local state first** — `useState` / `useReducer` in the owning component.
2. **Lift state up** — only when siblings need the same state.
3. **Context** — for low-frequency global state (theme, auth, locale). In React 19, use `use(Context)` instead of `useContext`.
4. **External store** — for high-frequency shared state (Zustand, Jotai).
5. **Server state** — use TanStack Query / SWR for API data. In React 19, `use(promise)` is also available.
6. **Never duplicate** server state in client state.

---

## Data Fetching

### TanStack Query (React Query)

- All data fetching should use TanStack Query (React Query v5).
- Use `isFetching` / `isLoading` from query hooks — do NOT create separate loading state.
- Data transformation must happen in `select` method, NOT in the component.

```typescript
const useCustomerData = (customerId: string) =>
  useQuery({
    queryKey: ["customer", customerId],
    queryFn: () => fetchCustomerData(customerId),
    select: (data) => ({ ...data, fullName: `${data.firstName} ${data.lastName}` }),
  });
```

### Form Management

- All forms must use React Hook Form with Yup (or Zod) schema validation.
- Ant Design input components are wrapped with `Controller`.
- Complex validation schemas must be in separate files per form.
- In React 19 projects, consider `useActionState` + `useFormStatus` for server-integrated forms.

### Store Management (Zustand)

- Store names must include project prefix: `{project}/{storeName}`.
- Use Zustand's native `setState` — do NOT create individual setter methods unless business logic is involved.
- Filtering and sorting operations belong in the store, NOT in components.
- Always use immutable state updates.

---

## Project Structure (Feature-Based)

```
src/
├── app/
│   ├── routes.tsx
│   ├── providers.tsx
│   └── app.tsx
├── features/
│   ├── auth/
│   │   ├── auth.tsx
│   │   ├── auth-form.tsx
│   │   ├── auth.hook.ts
│   │   ├── auth.service.ts
│   │   ├── auth.types.ts
│   │   ├── auth.module.scss
│   │   └── auth.spec.tsx
│   └── dashboard/
│       └── ...
├── shared/
│   ├── components/
│   ├── hooks/
│   ├── utils/
│   └── types/
├── services/
│   ├── api-client.ts
│   └── http.ts
└── config/
    ├── constants.ts
    └── env.ts
```

> **Flat feature folders**: All files within a feature folder live at the same level.
> No `components/`, `hooks/`, or `services/` sub-folders inside features.
> Sub-folders inside a feature are only allowed for separate child features.

### Micro-Frontend (Module Federation)

- Shell and Shared Library modules are **read-only reference**.
- Modifying Shell or Shared Library requires an **RFC** with impact analysis and team approval.
- Copy patterns into your own micro-frontend rather than editing shared code directly.

---

## Props and Event Handlers

- Props passed from parent to child: prefix with `handle` (e.g., `handleSubmit`).
- Internal event handlers within a component: prefix with `on` (e.g., `onButtonClick`).
- Props use `camelCase` naming — never `snake_case` or `PascalCase`.
- String props without expressions: omit curly braces.

```typescript
<Paragraph variant="h5" heading="good" />
```

### JSX Best Practices

- Do NOT define functions inside render/return — keep logic outside JSX.
- Use `Fragment` (`<>...</>`) instead of `div` when no wrapper is needed.
- Import hooks directly — not `React.useState`, just `useState`.
- Do NOT use index as `key` for dynamic lists.

### Conditional Rendering

- Use `&&` when there is no else branch. Do NOT use ternary with empty fragment.
- For multiple conditions, use a map/record pattern instead of repeated ifs.
- Maximum **3 levels** of optional chaining — restructure if deeper.

### Import Rules

- Import sorting: Framework → Third-party → Internal → Relative.
- Remove unused and duplicate imports immediately.
- Do NOT use `import * as` (wildcard imports).
- Do NOT use `import React from "react"` — unnecessary with modern JSX transform.

---

## SCSS / Style Standards

### BEM Methodology

- All style naming must follow BEM convention with nested SCSS.
- BEM prefix by component type: `a-` for atoms, `m-` for molecules, `o-` for organisms.

```scss
.a-customerSearch { &__input {} &--disabled {} }
.m-searchForm { &__field {} &--compact {} }
```

### Units

- Use `rem` instead of `px` for responsive design.
- Use the project's `rem()` function for conversion.
- Do NOT use percentage-based margins (except for `position: absolute` cases).

### Style Anti-Patterns

- ❌ No `!important` — if unavoidable, document the reason.
- ❌ No inline styles — if unavoidable, document the reason.
- ❌ No empty SCSS classes.
- ❌ No `isMobile` boolean — use CSS media queries.
- ❌ No hardcoded colors — use design tokens.

---

## Tab Navigation — Router Standard

- Multi-tab modules must use React Router for navigation.
- Each tab must have its own unique URL (deep linking support).
- ❌ Never use state-based tab switching without URL change.

---

## Accessibility (a11y) & SEO

- All interactive elements must be keyboard accessible.
- Use semantic HTML (`<button>`, `<nav>`, `<main>`, not `<div onClick>`).
- Images have `alt` text — decorative images use `alt=""`.
- Color contrast ratio ≥ 4.5:1 (WCAG compliance).
- Form fields have associated labels and proper `aria` attributes.
- Ant Design's built-in a11y props must be used when available.
- Focus states must be visible for all interactive elements.

---

## Performance Rules

- Code splitting with `React.lazy()` at route boundaries.
- Dynamic import for large modules.
- Image lazy loading with proper sizing and WebP format.
- React 18: Use `useMemo`/`useCallback` when profiler confirms need.
- React 19 with Compiler: Remove manual memoization — compiler handles it.
- Minimize re-renders: proper key usage, minimal props changes.
- Bundle size must be minimized — avoid importing entire libraries.
- Lists with 50+ items must be virtualized (react-window, react-virtuoso).
- Ant Design 6: CSS Variables eliminate runtime style injection overhead.

---

## Frontend Quality Checklist

Before submitting any frontend code, verify:

- [ ] **Version detected**: React and Ant Design versions read from package.json
- [ ] TypeScript strict mode — no `any`, no `@ts-ignore`
- [ ] Components follow single responsibility (≤ 300 lines, ≤ 5 props)
- [ ] Custom hooks extract reusable logic
- [ ] Ant Design components used with `items` API (not JSX children)
- [ ] Forms use React Hook Form + Yup/Zod schema validation
- [ ] Data fetching uses TanStack Query with `select` for transformation
- [ ] Tables have `rowKey` and pagination
- [ ] Theme tokens used — no hardcoded colors or CSS overrides
- [ ] Code splitting at route boundaries
- [ ] Router-based navigation for multi-tab modules
- [ ] Lists with 50+ items are virtualized
- [ ] React 19: No `forwardRef`, no manual memoization with Compiler
- [ ] Ant Design 6: CSS Variables confirmed, renamed props updated
