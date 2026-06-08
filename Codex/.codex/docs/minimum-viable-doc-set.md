# Minimum Viable Internal Doc Set

## Purpose

Define the smallest internal documentation surface required to keep the Codex package operational, governable, and maintainable.

## Required Internal Docs

- `.codex/docs/runtime-preflight.md`
- `.codex/docs/system-verification.md`
- `.codex/docs/usage-guide.md`
- `.codex/docs/project-context-discovery.md`
- `.codex/docs/context-mode-install.md`
- `.codex/docs/context-mode-wrapper.md`
- `.codex/docs/graphify.md`
- `.codex/docs/graphify-install.md`
- `.codex/docs/caveman.md`
- `.codex/docs/team-entrypoint-wrapper.md`
- `.codex/docs/wrapper-conventions.md`
- `.codex/docs/glossary.md`
- `.codex/docs/model-fallback.md`

## Optional / Secondary Docs

Everything else under `.codex/docs/` is secondary unless a team explicitly depends on it.

## Rule

If a document is not needed for:
- runtime correctness
- operator behavior
- safety/governance
- onboarding continuity

then it should not expand the active internal doc surface without a strong reason.
