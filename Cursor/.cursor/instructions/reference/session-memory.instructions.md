# Session Memory Instructions

## Purpose

Make sessions resumable and prevent loss of important decisions.

## Required Artifacts

- `.cursor/memory/sessions/`
- `.cursor/memory/resume/last-session.md`
- `.cursor/todo/active-plan.md`
- metrics files

## Session Start Behavior

Read:
- active plan
- last-session resume
- recent sessions
- relevant learned patterns

## Session End Behavior

Write or update:
- session summary
- resume summary
- active plan
- token/performance/fallback metrics

## Pattern Extraction Criteria

Capture learned patterns when:
- same type of failure repeats
- fallback visibility was missed
- rework indicates missing rule or poor task split
