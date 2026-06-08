# Implementation Standards

## 1. Delivery Philosophy

Implement the smallest correct solution that satisfies the task without introducing broad speculative structure.

## 2. Required Behaviors

- preserve existing contracts unless task says otherwise
- validate critical paths
- handle expected error cases
- keep changes cohesive and reviewable
- prefer explicitness over magic

## 3. Execution Workflow

1. confirm scope
2. inspect local context
3. identify touched contracts
4. implement bounded change
5. validate honestly
6. prepare reviewable handoff

## 4. Forbidden Behaviors

- coding around missing requirements with hidden assumptions
- changing unrelated files for convenience
- adding infrastructure/platform abstractions without pressure
- shipping unvalidated critical-path behavior

## 5. Escalate When

- architecture must change
- contract behavior is ambiguous
- validation surface becomes broader than assigned scope

## 6. Definition of Done

The task is not done until the intended change, validation story, and handoff summary are all present.
