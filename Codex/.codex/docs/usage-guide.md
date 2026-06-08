# Usage Guide

## Default Mode Baseline

Unless explicitly disabled, this package now assumes these modes are active by default:
- `/caveman`
- `/context-mode`
- `/graphify`

This means a short prompt like:

```text
Auth feature x5
```

should be interpreted operationally closer to:

```text
/context-mode /graphify /caveman Auth feature x5
```

## Quick Examples

- `Analyze the payment module x3`
- `build notification service x5`
- `large refactor x7`
- `migration audit x10`

## Recommended Sequence

1. `README.md`
2. `.codex/instructions/reference/slash-commands.instructions.md`
3. `.codex/docs/runtime-preflight.md`
4. `.codex/demo/end-to-end-x7.md`

## Operator Hint

If you do not explicitly opt out, the system should behave as if compressed output, context discipline, and graph-first narrowing are on by default.
