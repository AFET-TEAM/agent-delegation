# Local Multi-Agent Run Summary

- run_id: 2026-05-22T11-18-25Z
- prompt: smoke test x5
- mode: x5
- packet_count: 5
- completed_workers: 0
- failed_workers: 5
- artifacts: /Users/tcvmaksutoglu/Dev/w/crm/mayacore-mfe-context/Cursor/.cursor/runtime/runs/2026-05-22T11-18-25Z
- fallback_count: 0

## Wave Coverage
- wave1-discovery: 1 worker(s)
- wave2-consolidation: 1 worker(s)
- wave3-implementation: 1 worker(s)
- wave4-staff-review: 1 worker(s)
- wave5-principal-review: 1 worker(s)
- wave6-consolidation: orchestrator final summary emitted

## Review Decisions
- none

## Fallback Rows
- none

## Artifacts
- manifest: /Users/tcvmaksutoglu/Dev/w/crm/mayacore-mfe-context/Cursor/.cursor/runtime/runs/2026-05-22T11-18-25Z/manifest.json
- packets: /Users/tcvmaksutoglu/Dev/w/crm/mayacore-mfe-context/Cursor/.cursor/runtime/runs/2026-05-22T11-18-25Z/packets
- agents: /Users/tcvmaksutoglu/Dev/w/crm/mayacore-mfe-context/Cursor/.cursor/runtime/runs/2026-05-22T11-18-25Z/agents
- reviews: /Users/tcvmaksutoglu/Dev/w/crm/mayacore-mfe-context/Cursor/.cursor/runtime/runs/2026-05-22T11-18-25Z/reviews
- execution-log: /Users/tcvmaksutoglu/Dev/w/crm/mayacore-mfe-context/Cursor/.cursor/runtime/runs/2026-05-22T11-18-25Z/logs/execution-log.json

## Notes
- Safe file-writing is enforced by tier-scoped write policy.
- Revision Required results can retry up to 2 rounds before escalation/fallback logging.
- Metrics, session summary, resume, and active plan are auto-updated after the run.
- This remains a local orchestration runtime, not a hosted remote LLM mesh.

## Cursor Delegation
- Orchestrator must spawn Cursor `Task` subagents using files in spawn-packets/
- Follow spawn_order in manifest.json sequentially per wave
- Collect agent outputs into agents/ and run review chain before closing session
