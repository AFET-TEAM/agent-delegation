# Pull Request Standards

## PR Size Limits

| Metric | Limit |
|--------|-------|
| Total lines changed | 500 maximum |
| Files changed | 15 maximum |
| Commits | 10 maximum |

PRs exceeding these limits must be split into smaller, focused PRs. Each PR should represent one logical change that can be reviewed in under 30 minutes.

## Branch Naming

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/TICKET-description` | `feature/ATM-1234-user-profile-page` |
| Bug fix | `bugfix/TICKET-description` | `bugfix/ATM-5678-login-redirect-loop` |
| Hotfix | `hotfix/TICKET-description` | `hotfix/ATM-9012-payment-timeout` |
| Refactor | `refactor/TICKET-description` | `refactor/ATM-3456-extract-auth-service` |
| Chore | `chore/TICKET-description` | `chore/ATM-7890-update-spring-boot` |

Branch names use lowercase with hyphens. Description is 3-5 words summarizing the change.

## PR Description Template

```markdown
## Summary

[1-3 sentences describing what this PR does and why]

## Before & After Screenshots

| Before | After |
|--------|-------|
| [screenshot] | [screenshot] |

(Include for any UI change. Skip this section for backend-only changes.)

## Changed Components

- `ComponentName` — [what changed and why]
- `ServiceName` — [what changed and why]

## Affected Pages / Endpoints

- `/path/to/page` — [how it is affected]
- `POST /api/v1/resource` — [what changed]

## Detailed Description

[Explain the approach taken. Why this solution over alternatives?
Include any context reviewers need to understand the change.]

## References

- Ticket: [ATM-NNNN](link)
- Design: [Figma link] (if applicable)
- Related PR: #NNN (if applicable)

## Test Information

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed
- [ ] Test scenarios documented
```

## PR Checklist

### Code Quality

- [ ] Follows project coding standards
- [ ] Functions are 20 lines or fewer
- [ ] Files are 250 lines or fewer
- [ ] No `console.log`, `any`, `@ts-ignore`, or inline comments
- [ ] Self-documenting names throughout
- [ ] Linter passes with zero warnings

### Testing

- [ ] All new code has corresponding tests
- [ ] All existing tests pass
- [ ] Edge cases covered
- [ ] Error paths tested

### Frontend Specific

- [ ] Responsive design verified (mobile, tablet, desktop)
- [ ] Keyboard navigation works
- [ ] Ant Design components used consistently
- [ ] Design tokens used for colors and spacing
- [ ] No hardcoded strings (i18n ready)

### Standards Compliance

- [ ] Commit messages follow conventional commit format
- [ ] One logical change per commit
- [ ] No WIP commits in final PR
- [ ] Branch is rebased on latest target branch

## Third-Party Library Policy

Adding a new third-party dependency requires:

1. Team lead approval before implementation begins
2. Justification in the PR description (why existing tools are insufficient)
3. License compatibility verification (MIT, Apache 2.0, BSD are approved)
4. Bundle size impact assessment for frontend dependencies
5. Maintenance status check (last release within 6 months, active issue resolution)
6. Security audit (no known vulnerabilities in current version)

## Review Guidelines

### Response Times

| Priority | First Review | Re-review After Changes |
|----------|-------------|------------------------|
| Hotfix | Within 2 hours | Within 1 hour |
| Normal | Within 24 hours | Within 12 hours |
| Low priority | Within 48 hours | Within 24 hours |

### Constructive Feedback

- Focus on the code, not the author
- Explain the "why" behind every requested change
- Suggest alternatives when rejecting an approach
- Distinguish between blocking issues and suggestions
- Acknowledge good work and improvements
