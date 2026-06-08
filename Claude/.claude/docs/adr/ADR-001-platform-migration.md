# ADR-001: Copilot Multi-Agent System to Claude Code Migration

**Status**: Accepted
**Date**: 2026-04-17
**Decision Makers**: Varol Maksutoglu

## Context

The team has been using a VS Code + GitHub Copilot multi-agent orchestration system (solmaya-mfe-cad-boilerplate v7.0.1) with 11 agents across 5 tiers using 5 different AI models (Claude Opus, Claude Sonnet, GPT-5.3-Codex, Gemini 3.1 Pro, Gemini 3 Flash). This system needs to be adapted to work within the Claude Code ecosystem.

## Decision

Migrate the multi-agent system to Claude Code with the following key adaptations:

### Model Mapping (5 models to 3)
- Orchestrator + T1 Principal: Claude Opus 4.6 (opus)
- T2 Staff Engineer + T3 MidCoder: Claude Sonnet 4.6 (sonnet)
- T4 Lead Analyst + T5 Analyst: Claude Haiku 4.5 (haiku)

### Architectural Choices
1. **CLAUDE.md as Orchestrator**: Instead of declarative `.agent.md` files, CLAUDE.md serves as the orchestrator brain with references to agent prompt templates
2. **Agent tool for spawning**: Agents are spawned programmatically via Claude Code's Agent tool, not declared as files
3. **Shell hooks instead of JSON hooks**: Claude Code uses bash scripts triggered from settings.json, not JSON lifecycle hooks
4. **x10 upper limit**: Retained from Copilot (was also x10)
5. **Self-learning mechanism**: New feature not in Copilot — error patterns are collected and fed back into agent prompts

### What Was Dropped
- **GPT/Gemini model diversity**: Claude Code only supports Claude models
- **Per-agent identity in hooks**: Claude Code hooks cannot identify which subagent is running
- **Copilot lifecycle events**: SubagentStart/Stop/Error not available in Claude Code

### What Was Added
- **Self-learning system**: Pattern collection and injection across sessions
- **Figma MCP guard hook**: Enforces design system standards on Figma-derived code
- **4-layer enforcement**: Hook → Rule → Review → Self-Learning

## Consequences

### Positive
- Unified model family (all Claude) simplifies token estimation and behavior prediction
- Self-learning mechanism prevents error repetition across sessions
- Figma MCP integration enforces design standards automatically
- Stronger enforcement via 4 layers instead of 2

### Negative
- Loss of model diversity means some cost optimization opportunities are lost (GPT-5.3 was cheaper than Sonnet for T2 tasks)
- Hook-level enforcement is advisory for scope guards (cannot identify subagent tier)
- Agent spawning is sequential from the orchestrator's perspective

### Risks
- CLAUDE.md size may grow beyond optimal context budget
- Token cost for x10 delegation could be significant
- Self-learning pattern database may accumulate stale entries
