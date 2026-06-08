# Task Packet Contract

Each worker packet should include:
- agent_id
- display_name
- tier
- role
- wave
- prompt
- task_summary
- owned_scope
- required_skills
- skipped_skills
- context_files
- review_target
- expected_output_format
- expected_model
- reasoning_effort
- edit_permission

Canonical storage during runtime:
- `.codex/runtime/runs/<run_id>/packets/*.json`
