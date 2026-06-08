#!/usr/bin/env bash
set -euo pipefail

# Require CLAUDE_PROJECT_DIR
: "${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set}"

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(jq -r '.tool_input.file_path // .tool_input.path // empty' <<<"$INPUT")
  CONTENT=$(jq -r '.tool_input.content // .tool_input.new_string // empty' <<<"$INPUT")
else
  FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$FILE_PATH" ]; then
    FILE_PATH=$(echo "$INPUT" | grep -o '"path"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
  CONTENT=$(echo "$INPUT" | grep -o '"new_string"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  if [ -z "$CONTENT" ]; then
    CONTENT=$(echo "$INPUT" | grep -o '"content"\s*:\s*"[^"]*"' | head -1 | sed 's/.*: *"//;s/"$//')
  fi
fi

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

BASENAME=$(basename "$FILE_PATH")

case "$BASENAME" in
  .env|.env.*|.env.local|.env.development|.env.production|.env.test)
    echo "BLOCKED: Editing .env files is strictly prohibited. Environment variables must be managed outside of AI agent scope." >&2
    exit 2
    ;;
esac

case "$BASENAME" in
  *credential*|*secret*|*password*|*.pem|*.key|*.p12|*.jks|*.keystore|*.pfx|*.crt|*.cer)
    echo "BLOCKED: Editing sensitive/secret files is strictly prohibited. These files must be managed manually." >&2
    exit 2
    ;;
esac

case "$FILE_PATH" in
  */secrets/*|*/.secrets/*|*/private/*)
    echo "BLOCKED: Files in secrets/private directories cannot be edited by AI agents." >&2
    exit 2
    ;;
esac

if [ -n "$CONTENT" ]; then

  if echo "$CONTENT" | grep -qE '(sk_live_|sk_test_|pk_live_|pk_test_)[A-Za-z0-9]{10,}'; then
    echo "BLOCKED [secret-guard]: Hardcoded API key detected in $FILE_PATH. Use environment variables." >&2
    exit 2
  fi

  if echo "$CONTENT" | grep -qiE '(password|secret|api_key|apikey|token|auth_token)\s*[=:]\s*["'"'"'][^"'"'"'$\{]{8,}["'"'"']'; then
    echo "BLOCKED [secret-guard]: Hardcoded credential assignment detected in $FILE_PATH. Use environment variables." >&2
    exit 2
  fi

  if echo "$CONTENT" | grep -qE 'JWT_SECRET\s*[=:]\s*["'"'"'][^"'"'"'$\{]{8,}'; then
    echo "BLOCKED [secret-guard]: Hardcoded JWT secret detected in $FILE_PATH. Minimum 256-bit key from environment." >&2
    exit 2
  fi

  if echo "$CONTENT" | grep -qE '(AKIA|ASIA|AROA)[A-Z0-9]{16}|aws_secret_access_key\s*=\s*[A-Za-z0-9/+]{40}'; then
    echo "BLOCKED [secret-guard]: AWS credential detected in $FILE_PATH. Use IAM roles or environment variables." >&2
    exit 2
  fi

fi

exit 0
