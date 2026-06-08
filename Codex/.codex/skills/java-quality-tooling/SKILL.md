---
name: Java Quality Tooling
description: >
  JVM-focused quality gate skill covering static analysis, injection discipline, test/coverage compatibility,
  and common code-quality tooling expectations.
estimated-tokens: 2500
used-by: [T1, T2, T3]
tiers:
  T1: optional
  T2: optional
  T3: optional
---

# Java Quality Tooling Skill

## Purpose

Protect JVM codebases from accidentally violating static analysis and quality tooling conventions.

## Focus Areas

- constructor injection over field injection
- checkstyle/spotbugs compatibility
- preserving test and coverage gates
- avoiding silent weakening of quality thresholds

## Example

```java
public UserController(UserService userService) {
    this.userService = userService;
}
```

## Common Failure Pattern

Suppressing quality findings instead of fixing wiring or clarity problems.
