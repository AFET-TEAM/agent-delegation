# Graphify Install

## Goal

Provide a local-only topology view of large repositories so analysts do not brute-force read too many files.

## Suggested Setup

- generate `graphify-out/graph.json`
- keep a `.graphify-stale` marker protocol
- use local-only analysis in private codebases

## Operational Use

- if graph exists and is fresh, query it before broad searching
- if stale, rebuild or warn before relying on it
- use hotspot information to prioritize file reads and review focus

## Example Use Cases

- identify god nodes before refactor
- detect suspicious coupling before feature work
- narrow test impact surface before changing shared modules
