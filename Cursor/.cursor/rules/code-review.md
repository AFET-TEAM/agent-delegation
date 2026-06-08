# Code Review Standards

## 1. Severity Model

- Critical: correctness/security/data-loss
- Major: architectural drift, broken contract, missing validation
- Minor: naming/clarity/consistency

## 2. Review Output Template

```markdown
- Severity: Major
- File: src/auth/service.ts:42
- Issue: Token refresh path does not invalidate prior token.
- Why it matters: Allows replay risk and inconsistent session semantics.
- Recommendation: Add prior-token invalidation or explicit rotation handling.
```

## 3. Good Review Characteristics

A good review finding says:
- what is wrong
- where it is
- why it matters
- what should change

## 4. Bad Review Characteristics

- vague language
- style-only nit while missing critical risk
- no file reference
- no recommended correction

## 5. No-Merge Signals

Do not approve if:
- critical path is unvalidated
- fallback/security risk is hidden
- architecture drift is significant and unacknowledged
