# Context Mode Usage

## 1. Goal

Reduce context waste while preserving decision quality.

## 2. Mandatory Baseline

- query first, read second
- prefer section reads over full-file reads
- avoid recursive dumps
- summarize large findings before passing upward

## 3. Output Size Heuristics

- small output: inline summary acceptable
- medium output: summarize and link to path references
- large output: do not dump raw text; store/report condensed findings only

## 4. When to Activate Aggressively

- repo is large
- task touches many modules
- documentation surface is wide
- user explicitly requests `/context-mode`

## 5. Worked Example

Bad:
- read 12 files in full before identifying the target module

Good:
- search for auth/token references
- inspect 2 likely entrypoints
- summarize boundary and next reads

## 6. Prohibited Behaviors

- dumping large file trees into context without narrowing
- reading many irrelevant files “just in case”
- copying long raw outputs when summary would suffice

## 7. Relationship to Graphify

Context mode and graphify complement each other: graph/topology narrows the search surface, context mode controls how the narrowed results are carried upward.
