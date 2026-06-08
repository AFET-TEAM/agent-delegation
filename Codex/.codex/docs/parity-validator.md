# Parity Validator

## Historical Purpose

This validator was introduced to detect drift between canonical English root docs and Turkish mirror root docs.

## Current Status

Root-level Turkish mirror docs have been intentionally removed.

As a result:
- root-level EN/TR parity validation is no longer part of the active operator workflow
- the old parity validator should be treated as historical/optional tooling unless localized root docs are reintroduced later

## Current Recommended Validation Priority

Prefer validating:
- canonical English root-doc completeness
- metadata consistency
- reference correctness
- runtime/hook behavior
- review/delegation/PCD/context-mode/graphify documentation consistency
