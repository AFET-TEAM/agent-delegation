# Java Quality Tooling Standards

## 1. Static Analysis Compatibility

Changes should remain compatible with checkstyle/spotbugs-like quality gates.

## 2. Injection Rules

Avoid field injection. Prefer constructor injection.

## 3. Coverage and Test Gates

Do not weaken quality thresholds silently.

## 4. Common Remediation

- fix constructor wiring instead of suppressing rule failures
- resolve nullability and dead-code warnings honestly
- preserve or improve test coverage when behavior changes

## 5. CI Expectation

If a Java quality gate fails, treat it as a real signal unless a senior reviewer explicitly justifies otherwise.
