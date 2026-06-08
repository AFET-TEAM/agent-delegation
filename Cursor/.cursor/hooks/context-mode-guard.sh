#!/usr/bin/env bash
set -euo pipefail
COMMAND="${1:-}"
if [ -z "$COMMAND" ]; then exit 0; fi
if echo "$COMMAND" | grep -Eq '\b(curl|wget|scp|sftp|nc|ssh|rsync|ftp)\b'; then
  echo "[context-mode-guard] BLOCKED: exfiltration-capable tool detected." >&2
  exit 2
fi
if echo "$COMMAND" | grep -Eq '(\.ssh/|\.aws/|\.kube/|\.gnupg/|/etc/passwd|/etc/shadow|\.env\b|secrets/)'; then
  echo "[context-mode-guard] BLOCKED: sensitive path access detected." >&2
  exit 2
fi
if echo "$COMMAND" | grep -Eq '\b(find .*-type f|grep -r|grep --recursive|ls -R|cat .*\.(json|md|ts|tsx|js|jsx)|du -sh|wc -l)\b'; then
  echo "[context-mode-guard] ADVISORY: large output risk detected; prefer narrow search or context-safe routing." >&2
fi
exit 0
