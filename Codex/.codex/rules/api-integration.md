# API Integration Standards

## 1. Contract-First Thinking

Before integrating, clarify:
- request shape
- response shape
- error shape
- idempotency/retry expectations
- authentication/header needs

## 2. Consistency Rules

- use predictable naming and status semantics
- normalize error handling where possible
- keep mapping logic explicit
- do not leak transport quirks into deep business logic
- keep serialization/deserialization assumptions visible

## 3. Reliability

- retries only when safe
- surface partial-failure behavior clearly
- avoid swallowing upstream errors into useless generic messages
- define timeout and failure assumptions where integration risk matters

## 4. Integration Testing Expectations

- critical API edge behavior should be verifiable
- mapping and error behavior should be testable
- request/response contract changes should be obvious in review

## 5. Anti-Patterns

- ad-hoc parsing in UI or domain code
- hiding API errors behind vague “something went wrong” wrappers
- retrying non-idempotent operations without analysis
