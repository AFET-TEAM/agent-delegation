---
name: API Integration
description: >
  Integration skill for external/internal API consumption, contract alignment, mapping, error handling,
  and reliability concerns around network boundaries.
estimated-tokens: 2800
used-by: [T1, T2, T3]
tiers:
  T1: optional
  T2: mandatory when API
  T3: mandatory when API
---

# API Integration Skill

## Purpose

Provide robust patterns for consuming or exposing APIs without leaking inconsistency or fragile error semantics into the codebase.

## Contract Checklist

- request shape known?
- response shape known?
- error shape known?
- retry semantics safe?
- idempotency understood?

## Mapping Discipline

- keep API-edge mapping explicit
- do not leak transport DTOs deep into domain logic without intent
- preserve useful upstream error context

## Example

```ts
async function fetchUser(userId: string): Promise<UserDto> {
  const response = await apiClient.get(`/users/${userId}`);
  return userSchema.parse(response.data);
}
```

## Integration Review Questions

- what happens on partial failure?
- where is auth/header behavior handled?
- is retrying safe for this operation?
