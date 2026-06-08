# Context Mode Install

## Goal

Operationalize query-first exploration and large-output suppression in team usage.

## Suggested Integration Paths

### 1. Wrapper-Based
Create a small wrapper that reminds users to:
- narrow search before reading
- avoid recursive dumps
- prefer summaries for long outputs

### 2. Team Convention
Adopt a preflight habit:
- run PCD first
- use topology/graph methods on large repos
- avoid broad `find/grep/cat` sequences without narrowing

### 3. CI/Review Reinforcement
Use review checklists or scripts to spot anti-patterns like large recursive scans and sensitive path access.

## Example Wrapper Behavior

- if user tries broad recursive read, print advisory
- if task marked `/context-mode`, enforce summary-first reporting
