# Code Review Standards

## Review Process

### Phase 1: Initial Scan (2 min)

- File count and change scope assessment
- Architecture alignment check against established patterns
- Naming convention compliance verification
- Import ordering and dependency direction validation

### Phase 2: Detailed Review

- Logic correctness and edge case coverage
- Error handling completeness (no empty catch blocks)
- Performance implications (unnecessary re-renders, N+1 queries, unbounded loops)
- Security vulnerabilities (injection, XSS, hardcoded secrets)
- Test coverage adequacy (happy path, error paths, edge cases)
- Adherence to function and file size limits

### Phase 3: Feedback

- Structured findings with severity classification
- Actionable suggestions with code examples
- Positive callouts for well-written code

## Severity Levels

| Level | Icon | Action | Examples |
|-------|------|--------|----------|
| Critical | 🔴 | Reviewer fixes immediately | Security vulnerability, data loss risk, broken functionality |
| Major | 🟠 | Author must fix before merge | Logic error, missing error handling, performance issue |
| Minor | 🟡 | Author should fix, not blocking | Naming improvement, better pattern available |
| Suggestion | 🔵 | Optional improvement | Readability enhancement, alternative approach |

## Review Checklist

### Code Quality

- [ ] Functions are 20 lines or fewer
- [ ] Files are 250 lines or fewer (300 for React components)
- [ ] Maximum 3 parameters per function (options object for more)
- [ ] Maximum 2 nesting levels
- [ ] Cyclomatic complexity of 8 or less
- [ ] No `console.log`, `console.warn`, `console.error` statements
- [ ] No TypeScript `any` type usage
- [ ] No inline comments (`//`) or block comments (`/* */`)
- [ ] Intention-revealing names only
- [ ] No abbreviations (`button` not `btn`, `response` not `res`)
- [ ] No generic names (`data`, `info`, `item`, `temp`, `val`)

### Architecture

- [ ] Single Responsibility Principle followed
- [ ] Proper dependency injection (no direct instantiation of dependencies)
- [ ] No circular dependencies between modules
- [ ] Feature-based file organization maintained
- [ ] Barrel exports (`index.ts`) for public API of each module

### Security

- [ ] No hardcoded secrets, credentials, or API keys
- [ ] Input validation at every boundary (API, form, URL params)
- [ ] Parameterized queries only (no string concatenation for SQL)
- [ ] XSS prevention through output encoding
- [ ] Proper authentication and authorization checks on protected routes

### Testing

- [ ] AAA pattern followed (Arrange-Act-Assert)
- [ ] Edge cases covered (null, empty, boundary values)
- [ ] Error paths tested explicitly
- [ ] No implementation detail testing (test behavior, not internals)
- [ ] Meaningful test names: `should [expected] when [condition]`

### Frontend Specific

- [ ] Semantic HTML elements used (`<nav>`, `<main>`, `<article>`)
- [ ] Keyboard accessibility verified (tab order, focus management)
- [ ] Ant Design components used instead of native HTML for UI elements
- [ ] Design tokens for colors (no hardcoded hex values)
- [ ] `rem` units used (no `px` for spacing/typography)

## Tier-Specific Review Rules

### Principal to Staff Engineer Review

- Architecture soundness and design consistency
- Production-quality standards enforcement
- Edge case coverage completeness
- Commit and PR standards compliance
- Cross-cutting concerns (logging, monitoring, error tracking)

### Staff Engineer to MidCoder Review

- SOLID principles adherence
- Error handling completeness in every code path
- Naming consistency across the feature
- Complexity levels within defined limits
- Security vulnerability scan results

### Lead Analyst to Analyst Review

- Format compliance with report template
- Source references verified and accessible
- Confidence levels justified with evidence
- Completeness of analysis scope
- Actionability of findings and recommendations

## Review Outcomes

| Outcome | Action |
|---------|--------|
| Approved | Merge and proceed to next task |
| Revision Required | Author fixes findings, re-review within 24 hours (max 2 rounds) |
| Rejected | After 2 failed revision rounds, upper tier takes over the task |

## Feedback Format

Each finding must include:

1. Severity icon (🔴 🟠 🟡 🔵)
2. File path and line number
3. Description of the issue
4. Suggested fix or alternative approach

### Example

🟠 `src/features/user/user-service.ts:45`
Function `processUserData` exceeds 20-line limit and handles both validation and transformation.
Split into `validateUserInput` and `transformUserData` to respect SRP.
