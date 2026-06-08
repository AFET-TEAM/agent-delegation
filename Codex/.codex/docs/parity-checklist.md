# Root Docs Validation Checklist

## Purpose

Keep the canonical English root docs internally consistent, complete, and operationally trustworthy.

## Canonical Rule

- English root docs are the only canonical root operator docs.
- Localized root mirrors are not required.
- Commands, paths, and tier names must remain stable across canonical documentation.

## Root Doc Set

- `README.md`
- `START_HERE.md`
- `USAGE.md`
- `AGENTS.md`
- `ONE_PAGE_QUICKSTART.md`
- `OPERATIONS_RUNBOOK.md`
- `INDEX.md`

## Checklist

### Completeness
- each required root doc exists
- each root doc has the canonical metadata block
- each root doc references only valid current files

### Semantics
- `/delegate` vs `xN` meaning is consistent
- serious-session behavior is consistent
- runtime and hook caveats are preserved
- fallback visibility language is preserved
- Graphify / Context Mode caveats are preserved

### Reference Integrity
- command examples use valid syntax
- referenced root docs exist
- major `.codex/` paths referenced by root docs exist

## Update Workflow

1. update root doc
2. review impacted root docs for semantic drift
3. verify references and metadata
4. update changelog/progress/audit if the operational model changed
