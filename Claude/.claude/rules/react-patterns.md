---
paths:
  - "src/**/*.tsx"
  - "src/**/*.ts"
  - "!src/**/*.spec.*"
  - "!src/**/*.test.*"
  - "!src/**/*.stories.*"
---

# React & Frontend Development Standards

## Version Detection (ZORUNLU — Her Projede Uygula) [REVIEW]

React veya Ant Design kodu yazmadan önce hedef projenin `package.json` dosyasını oku:

```bash
# Okuma örneği
cat package.json | grep -E '"react"|"antd"'
```

| Bağımlılık | Versiyon | Uygulanan Kural Seti |
|-----------|---------|---------------------|
| `"react": "^18.x"` | React 18 | Bu dosyadaki tüm kurallar geçerli |
| `"react": "^19.x"` | React 19 | Bu dosyadaki kurallar + React 19 bölümü |
| `"antd": "^5.x"` | AntD 5.x | Bu dosyadaki AntD kuralları geçerli |
| `"antd": "^6.x"` | AntD 6.x | Bu dosyadaki AntD kuralları + AntD 6.x bölümü |

**React 18 + AntD 5 (mevcut varsayılan)**: Dosyadaki tüm mevcut kurallar geçerlidir.
**React 19 + AntD 5**: Mevcut kurallar + React 19 bölümü + `@ant-design/v5-patch-for-react-19` paketi zorunlu.
**React 18 + AntD 6**: Mevcut kurallar + AntD 6.x bölümü.
**React 19 + AntD 6**: Mevcut kurallar + React 19 bölümü + AntD 6.x bölümü.

## Component Design [REVIEW]

| Principle | Rule |
|---|---|
| Single Responsibility | One component = one UI concern |
| Composition over Inheritance | Build complex UI from small, composable pieces |
| Colocation | Keep related files together (component + hook + types + test) |
| Minimal Props | Maximum 5 props — use composition or context for more |
| Controlled by Default | Components are controlled unless explicitly uncontrolled |

- Components declared with `function` keyword (not `const` arrow function). [REVIEW]
- Component files: PascalCase. Non-component files: kebab-case. [REVIEW]
- Maximum **300 lines** per component — split logic/styles when exceeded. [REVIEW]
- Prefer `interface` for object shapes (props, state, API responses). Use `type` only for unions/intersections. [REVIEW]

## TypeScript Strict Rules [HOOK]

- `strict: true` always enabled. [REVIEW]
- No `any` — use `unknown` and narrow with type guards. [HOOK]
- Use `as const` for literal types and `satisfies` for type validation. [REVIEW]
- Discriminated unions over optional properties for state modeling: [REVIEW]

```typescript
type AsyncState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: Error };
```

- Prefer `const` over `let`. Never use `var`. [REVIEW]
- Use spread operator or `structuredClone` for copies. No direct mutation. [REVIEW]

## Hooks Rules [REVIEW]

| Hook | When to Use | Rule |
|---|---|---|
| `useState` | Simple local state | Keep state minimal — derive what you can |
| `useReducer` | Complex state logic (3+ related states) | Use discriminated union for actions |
| `useMemo` | Expensive computation or referential stability | Only when profiler confirms need |
| `useCallback` | Stable callback refs (passed to memoized children) | Not needed for inline event handlers |
| `useRef` | DOM access or mutable value without re-render | Never for state that affects render |
| `useEffect` | External system synchronization | Not for derived state or event-driven logic |

Custom hooks must return typed state. Use `AbortController` for cleanup in async hooks. [REVIEW]

## State Management Hierarchy [REVIEW]

1. **Local state first** — `useState` / `useReducer` in the owning component.
2. **Lift state up** — only when siblings need the same state.
3. **Context** — for low-frequency global state (theme, auth, locale).
4. **External store** — Zustand for high-frequency shared state. Store names: `{project}/{storeName}`.
5. **Server state** — TanStack Query for API data. Use `select` for transformation, not component logic.
6. **Never duplicate** server state in client state.

## Ant Design 5.x Standards [REVIEW]

- Use `items` prop pattern (not JSX children) for Menu, Breadcrumb, Tabs. [REVIEW]
- Data entry components wrapped with React Hook Form `Controller`. [REVIEW]
- Tables require `rowKey` and paginate 20+ items. [REVIEW]
- Feedback via static methods: `message.success()`, `notification.error()`. [REVIEW]
- Theme via `ConfigProvider` — never override CSS directly. Use `theme.useToken()`. [HOOK]

**Anti-patterns (forbidden)**:
- CSS `!important` to override Ant Design styles [HOOK]
- Importing entire library — always use named imports [REVIEW]
- Deprecated API patterns (JSX children for Menu/Table columns) [REVIEW]
- Mixing Ant Design with another UI library [REVIEW]
- Hardcoded colors — use design tokens [HOOK]

## Form Management (React Hook Form + Yup) [REVIEW]

- All forms use `useForm` with `yupResolver`. [REVIEW]
- Ant Design inputs wrapped with `Controller`. [REVIEW]
- Complex schemas extracted into separate files per form. [REVIEW]
- Use `mode: "all"` and `reValidateMode: "onChange"`. [REVIEW]

## Props and Event Handlers [REVIEW]

- Props from parent to child: prefix with `handle` (e.g., `handleSubmit`). [REVIEW]
- Internal event handlers: prefix with `on` (e.g., `onButtonClick`). [REVIEW]
- String props without expressions: omit curly braces (`variant="h5"` not `variant={"h5"}`). [REVIEW]

## JSX Rules [REVIEW]

- No functions defined inside render/return — keep logic outside JSX. [REVIEW]
- Use `Fragment` (`<>...</>`) when no wrapper needed. [REVIEW]
- Import hooks directly (not `React.useState`). [REVIEW]
- Never use index as `key` for dynamic lists. [REVIEW]
- Use `&&` for conditional rendering (no ternary with empty fragment). For multiple conditions, use map/record pattern. [REVIEW]

## Performance [REVIEW]

- Code splitting with `React.lazy()` at route boundaries. [REVIEW]
- Dynamic import for large modules. [REVIEW]
- `useMemo` for expensive computations, `useCallback` for stable refs — do not overuse. [REVIEW]
- Lists with 50+ items must be virtualized (react-window, react-virtuoso). [REVIEW]
- Bundle size minimized — avoid importing entire libraries. [REVIEW]

## Project Structure (Feature-Based)

```
src/
  app/                    # App shell, routing, providers
  features/               # Feature modules (flat — no sub-folders within features)
    auth/
      auth.tsx
      auth-form.tsx
      auth.hook.ts
      auth.service.ts
      auth.types.ts
      auth.module.scss
      auth.spec.tsx
  shared/                 # Shared across features
    components/
    hooks/
    utils/
    types/
  services/               # API clients, external integrations
  config/                 # App configuration
```

## Micro-Frontend (Module Federation)

- Shell and Shared Library modules are **read-only reference**.
- Modifying Shell or Shared Library requires RFC with impact analysis and team approval.
- Copy patterns into your own micro-frontend rather than editing shared code.

## Accessibility (a11y) [REVIEW]

- All interactive elements keyboard accessible. [REVIEW]
- Semantic HTML (`<button>`, `<nav>`, `<main>`, not `<div onClick>`). [HOOK]
- Images have `alt` text — decorative images use `alt=""`. [REVIEW]
- Color contrast ratio >= 4.5:1 (WCAG). [REVIEW]
- Form fields have associated labels and proper `aria` attributes. [REVIEW]
- Tab navigation uses React Router (each tab = unique URL). [REVIEW]

## Figma MCP Integration Rules

When implementing components from Figma designs:
- Convert ALL Figma components to Ant Design equivalents (native HTML forbidden for UI elements) [HOOK]
- Map Figma colors to design tokens — never use hardcoded hex values [HOOK]
- Convert Figma spacing values to rem() — never use px [HOOK]
- Map Figma typography to theme.useToken() values [HOOK]
- Convert Figma auto-layout to Ant Design Flex/Row/Col [HOOK]
- Validate that every Figma layer maps to a semantic HTML element or Ant Design component [HOOK]
- Figma frame names become component names (convert to PascalCase) [HOOK]

## TanStack Query Patterns

- Use `queryKey` arrays with entity type and identifier: `["users", userId]`
- Use `select` option for data transformation — not component logic
- Invalidate queries after mutations: `queryClient.invalidateQueries(["users"])`
- Use `enabled` option for conditional fetching
- Set `staleTime` based on data volatility (static data: 5min, dynamic: 30sec)
- Use `useInfiniteQuery` for paginated lists
- Prefetch on hover for predictive loading

## Zustand Store Patterns

- Store naming: `use{Feature}Store`
- Keep stores small and focused — one store per feature domain
- Use `immer` middleware for complex state updates
- Derive computed values with selectors, not stored state
- Use `subscribeWithSelector` for fine-grained subscriptions
- Store only client state — server state belongs in TanStack Query
- Reset store slices on logout/route change when appropriate

## React 19 Specific Patterns

> Apply ONLY when target project uses React 19 (`"react": "^19.x"` in package.json).
> React 18 patterns still apply unless explicitly superseded below.

### use() Hook

`use()` handles Promises and Context reads directly in render — replaces many useEffect+useState patterns.

```typescript
// React 19: Read promise in render (Suspense handles loading)
const userData = use(fetchUserPromise);

// React 19: Read context (replaces useContext in some cases)
const theme = use(ThemeContext);
```

### useOptimistic()

For mutations that should update UI immediately before server confirmation.

```typescript
const [optimisticItems, addOptimistic] = useOptimistic(
  items,
  (currentItems, newItem: Item) => [...currentItems, newItem]
);

const handleAdd = async (newItem: Item) => {
  addOptimistic(newItem);
  await saveItem(newItem);
};
```

### useActionState()

Replaces `useFormState` (deprecated). Manages form action state. Import from `'react'` (NOT `'react-dom'`).

```typescript
import { useActionState } from 'react';

const [state, formAction, isPending] = useActionState(
  async (previousState: FormState, formData: FormData) => {
    const result = await submitForm(formData);
    return result;
  },
  initialState
);
```

### useTransition() with Async

React 19 allows async functions in `startTransition`.

```typescript
const [isPending, startTransition] = useTransition();

const handleSubmit = () => {
  startTransition(async () => {
    await saveData(formData);
    router.navigate('/success');
  });
};
```

### ref as Prop (No forwardRef)

React 19 passes `ref` as a regular prop — `forwardRef` wrapper is no longer needed.

```typescript
// React 19: ref directly as prop
const Input = ({ ref, ...props }: InputProps & { ref?: React.Ref<HTMLInputElement> }) => (
  <input ref={ref} {...props} />
);

// React 18 pattern (still works but forwardRef is legacy in React 19):
// const Input = forwardRef<HTMLInputElement, InputProps>((props, ref) => ...)
```

### Context as Provider

React 19 allows `<MyContext>` directly as a provider without `.Provider`.

```typescript
// React 19
const ThemeContext = createContext('light');

<ThemeContext value="dark">
  <App />
</ThemeContext>

// React 18 (still works):
// <ThemeContext.Provider value="dark">
```

### React Compiler Compatibility

When React Compiler is enabled (opt-in in React 19), manual memoization is often unnecessary:

```typescript
// React Compiler (auto-memoizes): no useMemo/useCallback needed
const UserCard = ({ userId }: { userId: string }) => {
  const user = getUser(userId);
  return <div>{user.name}</div>;
};

// Only add useMemo/useCallback if:
// 1. React Compiler is NOT enabled (default)
// 2. Profiling confirms actual performance issue
// 3. Referential equality is semantically required
```

### useDeferredValue() for Heavy Computation

Defer expensive renders to keep UI responsive.

```typescript
const [inputValue, setInputValue] = useState('');
const deferredValue = useDeferredValue(inputValue);

// Heavy computation uses deferredValue (stale is OK)
const filteredList = useMemo(
  () => filterLargeList(deferredValue),
  [deferredValue]
);
```

## Ant Design 6.x Patterns

> Apply ONLY when target project uses AntD 6 (`"antd": "^6.x"` in package.json).
> AntD 5.x patterns still apply unless explicitly superseded below.

### CSS Variables Theming (New Default)

AntD 6 switches from design tokens to CSS variables as the primary theming mechanism.

```typescript
// AntD 6: CSS Variables approach
import { ConfigProvider } from 'antd';

<ConfigProvider
  theme={{
    cssVar: true,
    token: {
      colorPrimary: 'var(--brand-primary)',
      borderRadius: 8,
    },
  }}
>
  <App />
</ConfigProvider>

// AntD 5.x (still works but token-based):
// theme={{ token: { colorPrimary: '#1677ff' } }}
```

### Breaking API Changes (5.x → 6.x)

These props were renamed. Always use the new names in AntD 6 projects:

| Component | Old Prop (5.x) | New Prop (6.x) |
|-----------|---------------|----------------|
| Modal, Drawer, Dropdown | `visible` | `open` |
| Modal, Drawer, Dropdown | `onVisibleChange` | `onOpenChange` |
| Select, AutoComplete | `dropdownMatchSelectWidth` | `popupMatchSelectWidth` |
| Tooltip, Popover | `visible` | `open` |
| DatePicker | `visible` | `open` |

```typescript
// AntD 6: Use open
<Modal open={isOpen} onCancel={handleClose}>...</Modal>
<Drawer open={isVisible} onClose={handleClose}>...</Drawer>

// AntD 5.x (deprecated in 6.x):
// <Modal visible={isOpen} ...>
```

### Updated ConfigProvider API

Component-level theming has updated override syntax:

```typescript
// AntD 6: components override
<ConfigProvider
  theme={{
    components: {
      Button: {
        colorPrimary: '#ff4d4f',
        algorithm: true,
      },
      Table: {
        headerBg: '#fafafa',
      },
    },
  }}
>
```

### Import Path Updates

Some sub-components moved in AntD 6:

```typescript
// AntD 6: Tree-shakable imports (preferred)
import Button from 'antd/es/button';
import { Button } from 'antd'; // Still works

// Check AntD 6 changelog for specific component moves
// @ant-design/icons: verify version compatibility with AntD 6
```

### Migration Note: AntD 5.x + React 19

When using AntD 5.x with React 19 (before upgrading to AntD 6):

```bash
npm install @ant-design/v5-patch-for-react-19
```

```typescript
// Add to your app entry point (main.tsx / index.tsx)
import '@ant-design/v5-patch-for-react-19';
```
