# Runtime Preflight

## Before First Team Use

- confirm model access for `gpt-5.4`, `gpt-5.3-codex`, and `gpt-5.2`
- confirm principal/orchestrator paths run with high reasoning effort
- confirm git consent policy is understood
- confirm analysis directories are preserved
- confirm hooks are executable in team environment
- confirm README/AGENTS/USAGE are the adopted entrypoints
- confirm whether runtime is read-only, wrapper-assisted, or CI-reinforced

## Before Large Tasks

- run PCD
- decide whether graph/topology analysis is needed
- choose xN level intentionally
- verify context budget and review path
- if `/context-mode` is active, prefer narrow search over broad recursive reads

## Before Team Rollout

- test one x3 flow
- test one x5 flow
- verify fallback logging and session memory creation
- verify advisory hooks fail safely if the environment blocks persistence
- verify root docs remain reference-consistent after documentation updates
