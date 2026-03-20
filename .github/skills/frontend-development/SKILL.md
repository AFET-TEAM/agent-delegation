---
name: Frontend Development
description: >
  Principal-level frontend development skill covering JavaScript (ES2024+),
  React 18+, Ant Design 5.x, and micro-frontend standards. This skill
  is MANDATORY for all frontend coding tasks. Covers component architecture,
  state management, React Hook Form + Yup, hooks patterns, performance
  optimization, and Ant Design best practices.
estimated-tokens: 6000
used-by: [T1, T1.5, T2]
---

# Frontend Development Skill

## Scope

This skill is **mandatory** for all frontend coding tasks. It covers:

- Modern JavaScript / TypeScript best practices
- React component architecture and patterns
- Ant Design component library usage
- React Hook Form + Yup form management
- Micro-frontend architecture patterns (Module Federation)
- Performance optimization
- Accessibility standards

---

## JavaScript / TypeScript Standards

### Modern Syntax (ES2024+)

```typescript
// ✅ Use optional chaining and nullish coalescing
const userName = user?.profile?.name ?? "Anonymous";

// ✅ Use structured clone for deep copy
const copy = structuredClone(originalObject);

// ✅ Use Array.at() for index access
const lastItem = items.at(-1);

// ✅ Use Object.groupBy for grouping
const grouped = Object.groupBy(users, (user) => user.role);

// ✅ Use Promise.withResolvers for deferred promises
const { promise, resolve, reject } = Promise.withResolvers<Data>();
```

### TypeScript Strict Rules

- `strict: true` always enabled in `tsconfig.json`.
- No `any` — use `unknown` and narrow with type guards.
- Prefer `interface` for object shapes, `type` for unions/intersections.
- Use `as const` for literal types and `satisfies` for type validation.
- Discriminated unions over optional properties for state modeling.

```typescript
// ✅ Discriminated union for state
type AsyncState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: Error };

// ❌ Optional properties
interface BadState<T> {
  isLoading?: boolean;
  data?: T;
  error?: Error;
}
```

### Immutability

- Prefer `const` over `let`. Never use `var`.
- Use spread operator or `structuredClone` for copies.
- No direct mutation of objects or arrays — always return new references.
- Use `readonly` modifier for properties that shouldn't change.

---

## React Architecture

### Component Design Principles

| Principle                        | Rule                                                          |
| -------------------------------- | ------------------------------------------------------------- |
| **Single Responsibility**        | One component = one UI concern                                |
| **Composition over Inheritance** | Build complex UI from small, composable pieces                |
| **Colocation**                   | Keep related files together (component + hook + types + test) |
| **Minimal Props**                | Maximum 5 props — use composition or context for more         |
| **Controlled by Default**        | Components are controlled unless explicitly uncontrolled      |

### Component Structure

```typescript
// ✅ Standard component file structure
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

### Hooks Best Practices

| Hook          | When to Use                                        | Rule                                        |
| ------------- | -------------------------------------------------- | ------------------------------------------- |
| `useState`    | Simple local state                                 | Keep state minimal — derive what you can    |
| `useReducer`  | Complex state logic (3+ related states)            | Use discriminated union for actions         |
| `useMemo`     | Expensive computation or referential stability     | Only when profiler confirms need            |
| `useCallback` | Stable callback refs (passed to memoized children) | Not needed for inline event handlers        |
| `useRef`      | DOM access or mutable value without re-render      | Never for state that affects render         |
| `useEffect`   | External system synchronization                    | Not for derived state or event-driven logic |

### Custom Hook Patterns

Custom hooks must return typed state. Use `AbortController` for cleanup in async hooks:

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

### State Management Rules

1. **Local state first** — `useState` / `useReducer` in the owning component.
2. **Lift state up** — only when siblings need the same state.
3. **Context** — for low-frequency global state (theme, auth, locale).
4. **External store** — for high-frequency shared state (Zustand, Jotai).
5. **Server state** — use TanStack Query / SWR for API data.
6. **Never duplicate** server state in client state.

### Performance Rules (Quick Reference)

> **Canonical list**: See the "Performance Rules" section below for the full consolidated list.

- Use `React.memo()` only for components that re-render with same props.
- Use `React.lazy()` + `Suspense` for code splitting at route boundaries.
- Never use index as `key` for dynamic lists.
- Virtualize lists with 50+ items.

---

## Ant Design 5.x Patterns

### Component Usage Rules

| Category         | Components                         | Rules                                                      |
| ---------------- | ---------------------------------- | ---------------------------------------------------------- |
| **Layout**       | `Layout`, `Grid`, `Space`, `Flex`  | Use `Flex` for one-dimensional, `Grid` for two-dimensional |
| **Navigation**   | `Menu`, `Breadcrumb`, `Tabs`       | Use `items` prop (not JSX children)                        |
| **Data Entry**   | `Input`, `Select`, `DatePicker`    | Use with React Hook Form `Controller` for form binding     |
| **Data Display** | `Table`, `List`, `Card`            | Provide `rowKey` for Table, paginate 20+ items             |
| **Feedback**     | `message`, `notification`, `Modal` | Use static methods: `message.success()` not `<Message>`    |

### Form Patterns (React Hook Form + Yup)

```typescript
import { useForm, Controller } from "react-hook-form";
import { yupResolver } from "@hookform/resolvers/yup";
import { object, string, InferType } from "yup";
import { Input, Button } from "antd";

const loginSchema = object({
  email: string().email("Invalid email").required("Email is required"),
  password: string().required("Password is required"),
});

export function LoginForm({ onSubmit }: LoginFormProps) {
  const { control, handleSubmit, formState: { isValid } } = useForm<LoginFormValues>({
    mode: "all",
    resolver: yupResolver(loginSchema),
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <Controller name="email" control={control}
        render={({ field, fieldState }) => (
          <Input {...field} placeholder="Email" status={fieldState.error ? "error" : ""} />
        )} />
      <Button type="primary" htmlType="submit" disabled={!isValid} block>Sign In</Button>
    </form>
  );
}
```

### Table Patterns

```typescript
import { Table } from "antd";
import type { ColumnsType } from "antd/es/table";

const columns: ColumnsType<User> = [
  { title: "Name", dataIndex: "name", key: "name", sorter: (a, b) => a.name.localeCompare(b.name) },
  { title: "Email", dataIndex: "email", key: "email", ellipsis: true },
];

<Table<User> columns={columns} dataSource={users} rowKey="id" pagination={{ pageSize: 20, showSizeChanger: true }} />
```

### Theme Customization

Use `ConfigProvider` for theming — never override CSS directly. Customize via `theme.token` (global tokens) and `theme.components` (component-level). Access tokens in components via `theme.useToken()`.

### Ant Design Anti-Patterns

- ❌ Never use CSS `!important` to override Ant Design styles.
- ❌ Never import the entire library — always use named imports.
- ❌ Never use deprecated API patterns (JSX children for Menu, Table columns as JSX).
- ❌ Never mix Ant Design with another UI library (MUI, Chakra, etc.).
- ❌ Never hardcode colors — use design tokens via `theme.useToken()`.

---

## Project Structure (Feature-Based)

```
src/
├── app/                    # App shell, routing, providers
│   ├── routes.tsx
│   ├── providers.tsx
│   └── app.tsx
├── features/               # Feature modules (flat — no sub-folders)
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
├── shared/                 # Shared across features
│   ├── components/
│   ├── hooks/
│   ├── utils/
│   └── types/
├── services/               # API clients, external integrations
│   ├── api-client.ts
│   └── http.ts
└── config/                 # App configuration
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

## React Coding Rules

### Component Declaration

- Components must be declared using `function` keyword (not `const` arrow function).
- Component files use PascalCase naming. Non-component files use kebab-case.
- Maximum **300 lines** per component — split logic/styles when exceeded.

> **Alignment with clean-code**: The general file limit is 250 lines (`clean-code/SKILL.md`). Frontend components are allowed 300 lines as a domain-specific override when logic/style splitting within a single component is impractical.

- Prefer `interface` for object shapes (props, state, API responses). Use `type` only for unions, intersections, and mapped types.

### Props and Event Handlers

- Props passed from parent to child: prefix with `handle` (e.g., `handleSubmit`).
- Internal event handlers within a component: prefix with `on` (e.g., `onButtonClick`).
- Props use `camelCase` naming — never `snake_case` or `PascalCase`.
- String props without expressions: omit curly braces.

```typescript
// ✅ Correct
<Paragraph variant="h5" heading="good" />

// ❌ Wrong
<Paragraph variant={"h5"} heading={"bad"} />
```

### JSX Best Practices

- Do NOT define functions inside render/return — keep logic outside JSX.
- Use `Fragment` (`<>...</>`) instead of `div` when no wrapper is needed.
- Avoid `React.useState`, `React.useEffect` — import hooks directly.
- Do NOT use index as `key` for dynamic lists.

### Conditional Rendering

- Use `&&` when there is no else branch. Do NOT use ternary with empty fragment.
- For multiple conditions, use a map/record pattern instead of repeated if statements.
- When nested ternaries are needed, extract into a function.
- Maximum **3 levels** of optional chaining — restructure if deeper.

### Import Rules

- Import sorting: Framework → Third-party → Internal → Relative.
- Remove unused and duplicate imports immediately.
- Do NOT use `import * as` (wildcard imports).
- Use library-provided barrel exports (e.g., `import { Button } from '@shared-ui'`).

---

## Data Fetching and State Management

### TanStack Query (React Query)

- All data fetching must use TanStack Query (React Query v5).
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

### Form Management (React Hook Form + Yup)

> See "Ant Design 5.x Patterns → Form Patterns" above for the code example.

- All forms must use React Hook Form with `useForm` hook and Yup schema validation via `yupResolver`.
- Ant Design input components are wrapped with `Controller`.
- Complex validation schemas must be extracted into separate files per form.
- Use `mode: "all"` and `reValidateMode: "onChange"` for real-time validation feedback.

### Store Management (Zustand)

- Store names must include project prefix with slash notation: `{project}/{storeName}`.
- Use Zustand's native `setState` — do NOT create individual setter methods unless business logic is involved.
- Filtering and sorting operations belong in the store, NOT in components.
- Always use immutable state updates (spread operator, never direct mutation).

### Error Handling in Services

> See `clean-code/SKILL.md` for core error handling rules.

- Every `catch` block must perform a meaningful action (dispatch error, throw).
- Do NOT wrap in try-catch if only rethrowing — let the error propagate naturally.

---

## SCSS / Style Standards

### BEM Methodology

- All style naming must follow BEM (Block-Element-Modifier) convention with nested SCSS.
- BEM prefix by component type: `a-` for atoms, `m-` for molecules, `o-` for organisms.

```scss
.a-customerSearch { &__input {} &--disabled {} }
.m-searchForm { &__field {} &--compact {} }
```

### Units

- Use `rem` instead of `px` for responsive design.
- Use the project's `rem()` function for conversion.
- The `rem()` function is **auto-imported** by Webpack — do NOT manually import SCSS abstracts.
- Do NOT use percentage-based margins (except for `position: absolute` cases).

### Color and Font Management

- Colors and fonts must come from shared style files — never hardcoded hex values.
- Use design token variables from `_color.scss` and `fonts.scss`.

### Style Anti-Patterns

- ❌ No `!important` — if unavoidable, document the reason.
- ❌ No inline styles — if unavoidable, document the reason.
- ❌ No empty SCSS classes.
- ❌ No `isMobile` boolean for responsive design — use CSS media queries.
- ❌ No unnecessary `classNames()` for single static classes.
- ❌ No hardcoded colors — use design tokens.

### Correct classNames Usage

- Use `@extend` for combining utility classes in SCSS.
- Do NOT use `classNames()` for static single classes — use direct class references.

---

## Tab Navigation — Router Standard

- Multi-tab/multi-page modules must use React Router for navigation.
- Each tab/page must have its own unique URL (deep linking support).
- Ant Design Tabs can be combined with router-based navigation.
- ❌ Never use state-based tab switching without URL change.

---

## Shared Components

- Shared components must be developed under the shared component library (`libs/shared-ui`).
- Components must be generalized for reuse across projects.
- Every shared component requires: unit test, Storybook story, documentation.
- Import via barrel export: `import { Component } from '@shared-ui'`.

---

## Accessibility (a11y) & SEO

- All interactive elements must be keyboard accessible.
- Use semantic HTML (`<button>`, `<nav>`, `<main>`, not `<div onClick>`).
- Images have `alt` text — decorative images use `alt=""`.
- Color contrast ratio ≥ 4.5:1 for normal text (WCAG compliance).
- Form fields have associated labels and proper `aria` attributes.
- Ant Design's built-in a11y props must be used when available.
- Focus states must be visible for all interactive elements.
- Screen reader compatibility must be verified.
- Semantic HTML heading hierarchy must be correct for SEO.
- Lazy loading for images and links.
- Lighthouse audit must pass for both mobile and web.

---

## Performance Rules

> **Note**: Code splitting and image optimization are also referenced in the React Architecture section above. This section is the canonical, consolidated list.

- Code splitting with `React.lazy()` at route boundaries.
- Dynamic import for large modules.
- Image lazy loading with proper sizing and WebP format.
- `useMemo` for expensive computations, `useCallback` for stable refs — do not overuse.
- Minimize re-renders: proper key usage, minimal props changes.
- Third-party scripts loaded async/defer.
- Bundle size must be minimized — avoid importing entire libraries.
- Lists with 50+ items must be virtualized (react-window, react-virtuoso).

---

## Frontend Quality Checklist

Before submitting any frontend code, verify:

- [ ] TypeScript strict mode — no `any`, no `@ts-ignore`
- [ ] Components follow single responsibility (≤ 300 lines, ≤ 5 props)
- [ ] Custom hooks extract reusable logic
- [ ] Ant Design components used with `items` API (not JSX children)
- [ ] Forms use React Hook Form + Yup schema validation
- [ ] Data fetching uses TanStack Query with `select` for transformation
- [ ] Tables have `rowKey` and pagination
- [ ] Theme tokens used — no hardcoded colors or CSS overrides
- [ ] BEM methodology applied for SCSS
- [ ] Code splitting at route boundaries
- [ ] Router-based navigation for multi-tab modules
- [ ] Lists with 50+ items are virtualized
- [ ] Keyboard navigation and Lighthouse scores acceptable
