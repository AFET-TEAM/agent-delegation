# Model Fallback Log

Referenced by: `.claude/config/model-registry.md:45`

## Format

Each fallback event is logged as a table row below. The Orchestrator or hook writes entries when a model fallback occurs.

| Date | Session | Agent | Tier | Primary Model | Fallback Model | Reason |
|------|---------|-------|------|---------------|----------------|--------|

## Notes

- **Scoring**: Each fallback event deducts **-1** from the agent's score (per `.claude/config/name-pool.md` Scoring Rules).
- **Escalation rule**: If an agent triggers **3 or more fallbacks** in a session, the Orchestrator should escalate the task to the next tier up rather than continuing to retry with the lower model.
