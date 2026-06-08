# Analysis Standards

## 1. Evidence Rules

Every important finding should include:
- source path
- line number when possible
- confidence level
- short evidence or rationale

## 2. Confidence Levels

- High: directly verified
- Medium: inferred from multiple signals
- Low: partial evidence only

## 3. Analysis Report Template

```markdown
## Analysis Report — [Topic]

**Analyst**: [Name]
**Date**: [YYYY-MM-DD]
**Scope**: [Area]
**Confidence**: High | Medium | Low

### Summary
[2-3 sentence summary]

### Findings
1. [Finding]
2. [Finding]

### Recommendations
- [Action]
- [Action]

### Risks
| Risk | Probability | Impact | Mitigation |
|---|---|---|---|

### Sources
- [path:line]
```

## 4. Analysis Types

- codebase mapping
- dependency analysis
- technology comparison
- risk assessment
- test scenario generation

## 5. Prohibited Analysis Behavior

- unsupported claims
- vague recommendations
- mixing assumptions with verified facts without labeling
- speculative architecture prescriptions without evidence
