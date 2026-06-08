---
name: Frontend Development
description: >
  Frontend development skill covering JavaScript/TypeScript, React version-aware development,
  UI state modeling, component architecture, forms, accessibility, and design-system compliance.
estimated-tokens: 7200
used-by: [T1, T2, T3]
tiers:
  T1: optional
  T2: mandatory when frontend
  T3: mandatory when frontend
---

# Frontend Development Skill

## Scope

This skill is mandatory for all meaningful frontend tasks.

It covers:
- version-aware React work
- component architecture
- state management
- hooks discipline
- forms and validation
- accessibility baseline
- performance hygiene
- design-system alignment

## Version Detection Protocol

Before writing frontend code, inspect the relevant `package.json` and determine:
- `react`
- `react-dom`
- UI library version if present
- form library if present
- `typescript`

Report detected versions in the task summary when they materially affect implementation.

If exact version cannot be found, state the assumption explicitly.

## Component Architecture

### Rules
- one component = one UI concern
- prefer composition over giant prop surfaces
- extract domain logic when component state becomes hard to reason about
- keep public props minimal and intention-revealing

### Example

```tsx
interface UserFormProps {
  initialValue: UserFormValue;
  onSubmit: (value: UserFormValue) => void;
}

export function UserForm({ initialValue, onSubmit }: UserFormProps) {
  const [value, setValue] = useState(initialValue);
  const [isSubmitting, setIsSubmitting] = useState(false);

  async function handleSubmit() {
    setIsSubmitting(true);
    try {
      onSubmit(value);
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <Form layout="vertical">
      <UserNameField value={value.name} onChange={(name) => setValue({ ...value, name })} />
      <Button loading={isSubmitting} onClick={handleSubmit}>Save</Button>
    </Form>
  );
}
```

## UI State Modeling

Always think in explicit states:
- loading
- empty
- success
- error
- disabled/permission-limited

### Example

```tsx
type ViewState<T> =
  | { status: "loading" }
  | { status: "empty" }
  | { status: "success"; data: T }
  | { status: "error"; message: string };
```

## Hooks Rules

- call hooks unconditionally at top level
- create custom hooks when stateful logic is shared or too dense
- do not hide network or side-effect behavior behind misleading names

### Example

```tsx
function useUserPreferences(userId: string) {
  const [state, setState] = useState<ViewState<UserPreferences>>({ status: "loading" });

  useEffect(() => {
    let active = true;
    fetchPreferences(userId)
      .then((data) => {
        if (!active) return;
        setState(data ? { status: "success", data } : { status: "empty" });
      })
      .catch(() => {
        if (!active) return;
        setState({ status: "error", message: "Preferences could not be loaded." });
      });

    return () => {
      active = false;
    };
  }, [userId]);

  return state;
}
```

## Form Standards

- validation should be explicit
- disabled, pending, and invalid states should be visible
- error messaging should be user-readable

## Accessibility Baseline

- semantic controls first
- labels tied to inputs
- keyboard path should remain usable
- loading and error feedback should not be silent

## Performance Hygiene

- avoid unnecessary re-renders
- memoize only when measurement or clear cost justifies it
- keep derived state minimal
- large lists need rendering strategy awareness

## Anti-Patterns

- giant components mixing API orchestration and rendering
- implicit state transitions nobody can explain
- optimistic UI with no failure recovery plan
- local fixes that violate design-system standards
