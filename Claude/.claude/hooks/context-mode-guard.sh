#!/usr/bin/env bash
set -euo pipefail

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  COMMAND=$(jq -r '.tool_input.command // empty' <<<"$INPUT")
else
  COMMAND=$(echo "$INPUT" | grep -o '"command"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
fi

if [ -z "$COMMAND" ]; then
  exit 0
fi

EXFILTRATION_TOOLS="nc ncat socat wget curl ftp sftp scp rsync ssh"

for tool in $EXFILTRATION_TOOLS; do
  if echo "$COMMAND" | grep -qE "(^|[|&;]\s*)$tool\s"; then
    echo "{\"type\":\"text\",\"text\":\"[context-mode-guard] BLOCKED: '$tool' is an exfiltration-capable tool. Use 'ctx_execute' with explicit allow if network access is required for analysis.\"}" >&2
    exit 2
  fi
done

SENSITIVE_PATTERNS=(
  "\.ssh/"
  "\.aws/"
  "\.kube/"
  "\.gnupg/"
  "/etc/passwd"
  "/etc/shadow"
  "\.env\b"
  "secrets/"
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "{\"type\":\"text\",\"text\":\"[context-mode-guard] BLOCKED: Command accesses sensitive path matching '$pattern'. This path is on the deny list. If access is required, use Read tool with explicit file path.\"}" >&2
    exit 2
  fi
done

LARGE_OUTPUT_PATTERNS=(
  "find\s.*-name\s.*\|"
  "find\s.*-type\sf\b"
  "grep\s-r\s"
  "grep\s--recursive\s"
  "cat\s.*\.json\b"
  "cat\s.*\.ts\b"
  "cat\s.*\.md\b"
  "ls\s-la\b"
  "ls\s-R\b"
  "du\s-sh\b"
  "wc\s-l\b"
)

for pattern in "${LARGE_OUTPUT_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "{\"type\":\"text\",\"text\":\"[context-mode-guard] ADVISORY: Command '$COMMAND' may produce large output. Consider: ctx_execute(\\\"shell\\\", \\\"${COMMAND}\\\") to keep output out of context.\"}" >&2
    exit 0
  fi
done

exit 0
