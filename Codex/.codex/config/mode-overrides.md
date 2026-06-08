# Mode Overrides — User Persistent Opt-Out

> **v7.4.3-consolidated** | Codex defaults are **TBD**. This file is provided for parity with the Copilot source of truth, but Codex may treat it as documentation-only until the runtime/orchestrate layer reads it.

<!-- TODO: Wire `.codex/config/mode-overrides.md` into Codex runtime/orchestrate startup so these overrides are enforced automatically. -->

## How it works

- When Codex runtime integration exists, agents should read this file at session start (before applying mode triggers).
- Each `disabled:` entry below turns the corresponding mode **off** for the entire session.
- Without an entry, runtime default behavior remains whatever Codex runtime/orchestrate currently applies.
- Slash commands (`/caveman off`, `/context-mode off`, `/graphify off`) inside a prompt affect ONLY that single prompt. They do not modify this file. Re-enabling slash commands (`/caveman on`, `/context-mode on`, `/graphify on`) likewise apply only to the current prompt.
- To make an off-state persistent across sessions, add a `disabled:` entry below manually (or ask the Orchestrator to do it for you).

## Activation precedence

1. Slash command in the current prompt
2. `.codex/config/mode-overrides.md`
3. Codex default/runtime behavior

## Disabled modes

> Lines that start with `disabled:` are honored. Anything else is treated as documentation. Allowed values after `disabled:` — `caveman`, `context-mode`, `graphify`.

<!--
Examples (uncomment to disable):

disabled: caveman
disabled: context-mode
disabled: graphify
-->

## Caveman level override

By default, when `/caveman` is on, level is `full`. To pin a different default level across sessions, add ONE of the following:

<!--
caveman-level: lite
caveman-level: full
caveman-level: ultra
-->

## Re-enabling

Either:
1. Delete the matching `disabled:` line from this file (persistent re-enable), OR
2. Send `/caveman on` / `/context-mode on` / `/graphify on` in your next prompt (single-prompt re-enable; doesn't touch this file).
