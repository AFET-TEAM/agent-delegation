# Run Summary Contract

Each real delegate runtime execution should emit:
- run_id
- prompt
- mode
- packet_count
- completed_workers
- failed_workers
- artifact locations
- fallback visibility
- wave coverage summary
- open notes / residual risks

Canonical storage during runtime:
- `.cursor/runtime/runs/<run_id>/final-summary.md`
