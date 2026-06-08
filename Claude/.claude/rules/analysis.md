---
paths:
  - ".claude/analysis/**"
---

# Analysis Standards

## Write Permission Boundaries

| Tier | Writable Directory | All Other Directories |
|------|-------------------|-----------------------|
| T5 Analyst | `.claude/analysis/raw/` | Read-only |
| T4 Lead Analyst | `.claude/analysis/consolidated/` | Read-only |

Violations of these boundaries will be flagged by `analysis-scope-guard.sh`.

## Report Template

Every analysis report must follow this structure:

```markdown
# {Analysis Title}

**Author**: {Agent Display Name} ({Tier})
**Date**: {ISO-8601}
**Type**: {codebase|dependency|technology|risk|test-scenario}
**Confidence**: {High|Medium|Low}

## Executive Summary
{2-3 sentences summarizing key findings}

## Findings

### Finding 1: {Title}
- **Severity**: {P0-Critical|P1-High|P2-Medium|P3-Low}
- **Source**: {file:line or URL}
- **Confidence**: {High|Medium|Low}
- **Description**: {What was found}
- **Impact**: {Why it matters}
- **Recommendation**: {What to do}

## Risk Assessment
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|

## Recommendations
{Prioritized list of actions}

## Sources
{Every source cited: file paths with line numbers, URLs, documentation references}
```

## Analysis Types

### Codebase Analysis
Examine code structure, patterns, dependencies. Focus on architecture adherence, code quality metrics, and technical debt.

### Dependency Analysis
Audit project dependencies for version currency, security vulnerabilities, license compliance, and bundle size impact.

### Technology Comparison
Compare technology options with criteria: performance, developer experience, community support, maintenance cost, team expertise.

### Risk Assessment
Identify technical risks: scalability bottlenecks, security vulnerabilities, single points of failure, migration risks.

### Test Scenario Generation
Generate test cases from requirements. Cover: happy path, edge cases, error scenarios, boundary conditions, concurrency.

## Quality Criteria

- Every finding MUST cite its source (file:line, URL, or documentation reference)
- Confidence level MUST be justified — High requires verifiable evidence, Medium requires reasonable inference, Low requires explicit disclaimer
- No speculation — if uncertain, state "requires further investigation"
- Cross-reference findings where possible
- Prioritize by impact (P0 first, P3 last)

## Prohibited Practices

- Writing to directories outside designated scope
- Making assertions without evidence
- Copying findings from other analysts without verification
- Including sensitive data (credentials, tokens) in reports

## Research Protocol

1. Read existing documentation and code before writing
2. Verify each finding against the actual codebase
3. Cross-reference with multiple sources when possible
4. Flag contradictions between sources
5. Escalate ambiguity to Lead Analyst (T4) or Orchestrator
