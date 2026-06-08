# Prompt Enrichment Protocol

## Purpose

Convert ambiguous or underspecified tasks into implementation-ready work without forcing unnecessary back-and-forth.

## When To Run

Run PEP for:
- non-trivial feature requests
- tasks with multiple possible implementations
- tasks with unclear scope boundaries
- work affecting contracts or UX behavior

## Enrichment Workflow

1. identify explicit requirements
2. extract hidden assumptions
3. identify decision points
4. resolve what can be discovered locally
5. ask or document bounded assumptions only when needed
6. emit implementation-ready task split

## What To Inject

A useful enriched task contains:
- clarified scope
- confirmed or assumed constraints
- target files/modules
- review and validation expectations
- open questions if any remain

## Example

Raw prompt:
- “build notification settings”

Enriched summary:
- backend preference persistence
- frontend preference screen
- explicit loading/error states
- review path T3 -> T2 -> T1
