# Backend Security Standards

## 1. Secrets

- never hardcode secrets, tokens, passwords, API keys
- avoid unsafe local test values in production code
- configuration should come from safe environment or secrets systems

## 2. Injection Risks

- no SQL string concatenation
- no unsafe shell interpolation from untrusted input
- sanitize/validate file-path-related input

## 3. Web Risks

- avoid wildcard CORS in production-grade code
- avoid unsafe HTML rendering/output construction patterns
- make auth/session assumptions explicit
- check output encoding and unsafe reflection surfaces

## 4. Security Review Checklist

- where can untrusted input enter?
- what protects the boundary?
- can output create injection/XSS risk?
- is auth or rate-limiting missing?
- is file upload or path handling safe?

## 5. Logging and Audit

- do not log secrets
- security-relevant failures should remain diagnosable
- auth-sensitive actions should leave an understandable audit trail where appropriate

## 6. Escalation Cases

Escalate if:
- auth model is unclear
- secret storage assumptions are unsafe
- input validation strategy is inconsistent across endpoints
