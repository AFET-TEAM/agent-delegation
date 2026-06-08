# Project Context Discovery Instructions

## Purpose

Extract just enough project context to guide implementation without overloading context.

## Scan Order

1. root README
2. other relevant top-level markdown files
3. `docs/`
4. package/manifests/build config
5. entrypoints and feature roots

## Artifact Prioritization

Prioritize:
- architecture and boundary docs
- manifests showing versions/frameworks
- task-relevant feature directories
- API contracts and configuration points

## Output Format

- project goal
- module map
- constraints and conventions
- likely affected files
- recommended next reads

## Dependency Tracing Guidance

When module coupling is unclear:
- identify imports/calls/config boundaries
- use graph/topology if repo is large
- distinguish verified dependency from inferred coupling
