#!/usr/bin/env bash

STALE_MARKER=$(find . -name ".graphify-stale" -maxdepth 6 2>/dev/null | head -1)
GRAPH_JSON=$(find . -name "graph.json" -path "*/graphify-out/*" -maxdepth 6 2>/dev/null | head -1)

if [ -n "$STALE_MARKER" ]; then
  echo "[graphify-audit] WARNING: graph is stale. Run /graphify . --local-only to rebuild." >&2
fi

if [ -n "$GRAPH_JSON" ]; then
  AGE_DAYS=$(( ( $(date +%s) - $(date -r "$GRAPH_JSON" +%s 2>/dev/null || echo $(date +%s)) ) / 86400 ))
  if [ "$AGE_DAYS" -gt 7 ]; then
    echo "[graphify-audit] WARNING: graph.json is ${AGE_DAYS} days old. Consider rebuilding." >&2
  fi
fi

exit 0
