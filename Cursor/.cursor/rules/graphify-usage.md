# Graphify Usage Standards

## 1. When to Use

Prefer graph/topology discovery when:
- repo scope exceeds direct-reading comfort
- dependencies are unclear
- hotspot/god-node analysis is needed

## 2. Relationship Vocabulary

Use clear terms when reporting topology:
- imports -> static dependency
- calls -> runtime usage
- configures -> wiring/config relationship
- extends/implements -> inheritance/interface relation

## 3. Confidence Tags

- EXTRACTED: directly observed from graph/query or code
- INFERRED: likely from topology signals
- AMBIGUOUS: insufficient evidence

## 4. Workflow

- check whether graph exists and is fresh
- if stale, rebuild or warn
- use graph query to narrow relevant areas
- then read only the files that matter

## 5. Good Outputs

- hotspot candidates
- likely boundary seams
- suspicious coupling paths
- recommended next files to inspect

## 6. Fallback

If graph data is unavailable, degrade to targeted search, not broad brute-force scanning.
