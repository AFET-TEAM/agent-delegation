# Wrapper Settings

## Delegate Strict Mode

Environment variable:

```bash
CODEX_STRICT_DELEGATE=1
```

Effect:
- if enabled, `delegate` mode blocks when the prompt does not include an explicit `xN` suffix
- if disabled or unset, the wrapper only warns

## Recommended Team Default

For disciplined team rollout:
- enable strict mode in CI or shared shell profile
- keep warning mode for individual experimentation if needed
