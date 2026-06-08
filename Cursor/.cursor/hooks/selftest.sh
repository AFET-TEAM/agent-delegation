#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGE_ROOT="$(cd "$DIR/.." && pwd)"
SANDBOX_PARENT="$(cd "$PACKAGE_ROOT/.." && pwd)"
SANDBOX="$(mktemp -d "$SANDBOX_PARENT/.selftest-sandbox.XXXXXX")"
trap 'rm -rf "$SANDBOX"' EXIT

PKG_ROOT="$SANDBOX/.cursor"
HOOK_DIR="$PKG_ROOT/hooks"
WORKSPACE="$SANDBOX/workspace"
export CURSOR_PKG_ROOT="$PKG_ROOT"
export CURSOR_HOST_ROOT="$SANDBOX"

mkdir -p "$PKG_ROOT"
cp -R "$DIR" "$PKG_ROOT/"
chmod +x "$HOOK_DIR"/*.sh

TESTS_RUN=0
TESTS_PASS=0
TESTS_FAIL=0
TEST_DETAIL=""

note_failure() {
  TEST_DETAIL="$1"
  return 1
}

assert_rc() {
  local expected="$1"
  local actual="$2"
  [ "$actual" -eq "$expected" ] || note_failure "expected rc=$expected, got rc=$actual"
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  printf '%s' "$haystack" | grep -qF "$needle" || note_failure "expected output to contain: $needle"
}

assert_file_exists() {
  local path="$1"
  [ -f "$path" ] || note_failure "expected file to exist: $path"
}

assert_file_contains() {
  local path="$1"
  local needle="$2"
  grep -qF "$needle" "$path" || note_failure "expected $path to contain: $needle"
}

capture() {
  local __out_var="$1"
  local __rc_var="$2"
  shift 2
  local captured_output captured_rc
  set +e
  captured_output="$($@ 2>&1)"
  captured_rc=$?
  set -e
  printf -v "$__out_var" '%s' "$captured_output"
  printf -v "$__rc_var" '%s' "$captured_rc"
}

run_test() {
  local name="$1"
  shift
  TESTS_RUN=$((TESTS_RUN + 1))
  TEST_DETAIL=""
  if "$@"; then
    TESTS_PASS=$((TESTS_PASS + 1))
    printf 'PASS %02d - %s\n' "$TESTS_RUN" "$name"
  else
    TESTS_FAIL=$((TESTS_FAIL + 1))
    printf 'FAIL %02d - %s\n' "$TESTS_RUN" "$name"
    printf '          %s\n' "${TEST_DETAIL:-assertion failed}"
  fi
}

cursor_command_payload() {
  python3 - "$1" <<'PY'
import json, sys
print(json.dumps({"command": sys.argv[1]}))
PY
}

cursor_write_payload() {
  python3 - "$1" <<'PY'
import json, sys
print(json.dumps({"tool_name": "Write", "tool_input": {"path": sys.argv[1]}}))
PY
}

cursor_post_write_payload() {
  python3 - "$1" <<'PY'
import json, sys
print(json.dumps({"tool_input": {"path": sys.argv[1]}}))
PY
}

cursor_prompt_payload() {
  python3 - "$1" <<'PY'
import json, sys
print(json.dumps({"prompt": sys.argv[1]}))
PY
}

cursor_subagent_start_payload() {
  python3 - "$1" <<'PY'
import json, sys
print(json.dumps({"subagent_type": sys.argv[1]}))
PY
}

cursor_subagent_stop_payload() {
  python3 - "$1" <<'PY'
import json, sys
print(json.dumps({"agent_id": sys.argv[1]}))
PY
}

reset_cursor_state() {
  rm -rf "$PKG_ROOT/metrics" "$PKG_ROOT/memory" "$PKG_ROOT/runtime" "$PKG_ROOT/scripts" "$PKG_ROOT/analysis" "$WORKSPACE"
  mkdir -p "$PKG_ROOT/metrics" "$PKG_ROOT/memory/learned-patterns" "$PKG_ROOT/runtime/runs" "$PKG_ROOT/scripts" "$WORKSPACE/src"
}

test_before_shell_allows_safe_command() {
  reset_cursor_state
  local payload output rc
  payload="$(cursor_command_payload 'echo hello')"
  capture output rc bash "$HOOK_DIR/before-shell-execution.sh" <<<"$payload"
  assert_rc 0 "$rc" || return 1
  assert_contains "$output" '"permission":"allow"' || return 1
}

test_before_shell_blocks_git_push() {
  reset_cursor_state
  local payload output rc
  payload="$(cursor_command_payload 'git push origin main')"
  capture output rc bash "$HOOK_DIR/before-shell-execution.sh" <<<"$payload"
  assert_rc 2 "$rc" || return 1
  assert_contains "$output" '"permission":"deny"' || return 1
  assert_contains "$output" 'git-safety-check' || return 1
}

test_before_shell_blocks_curl() {
  reset_cursor_state
  local payload output rc
  payload="$(cursor_command_payload 'curl https://example.com')"
  capture output rc bash "$HOOK_DIR/before-shell-execution.sh" <<<"$payload"
  assert_rc 2 "$rc" || return 1
  assert_contains "$output" '"permission":"deny"' || return 1
  assert_contains "$output" 'context-mode-guard' || return 1
}

test_pre_tool_use_allows_safe_write_path() {
  reset_cursor_state
  local payload output rc
  payload="$(cursor_write_payload "$WORKSPACE/src/app.ts")"
  capture output rc bash "$HOOK_DIR/pre-tool-use-write.sh" <<<"$payload"
  assert_rc 0 "$rc" || return 1
  assert_contains "$output" '"permission":"allow"' || return 1
}

test_pre_tool_use_blocks_analysis_root_write() {
  reset_cursor_state
  local payload output rc
  mkdir -p "$PKG_ROOT/analysis"
  payload="$(cursor_write_payload "$PKG_ROOT/analysis/report.md")"
  capture output rc bash "$HOOK_DIR/pre-tool-use-write.sh" <<<"$payload"
  assert_rc 2 "$rc" || return 1
  assert_contains "$output" '"permission":"deny"' || return 1
  assert_contains "$output" 'analysis-scope-guard' || return 1
}

test_post_tool_use_records_edit_activity() {
  reset_cursor_state
  local payload output rc
  : > "$WORKSPACE/src/app.ts"
  payload="$(cursor_post_write_payload "$WORKSPACE/src/app.ts")"
  capture output rc bash "$HOOK_DIR/post-tool-use-write.sh" <<<"$payload"
  assert_rc 0 "$rc" || return 1
  assert_contains "$output" '{}' || return 1
  assert_file_exists "$PKG_ROOT/metrics/edit-counts.log" || return 1
  assert_file_contains "$PKG_ROOT/metrics/edit-counts.log" "|$WORKSPACE/src/app.ts" || return 1
}

test_before_submit_prompt_returns_additional_context() {
  reset_cursor_state
  cat > "$PKG_ROOT/scripts/prompt-router.py" <<'PY'
#!/usr/bin/env python3
import json, sys
print(json.dumps({"additional_context": f"ctx:{sys.argv[1]}"}))
PY
  chmod +x "$PKG_ROOT/scripts/prompt-router.py"
  local payload output rc
  payload="$(cursor_prompt_payload 'hook selftest')"
  capture output rc bash "$HOOK_DIR/before-submit-prompt.sh" <<<"$payload"
  assert_rc 0 "$rc" || return 1
  assert_contains "$output" 'additional_context' || return 1
  assert_contains "$output" 'ctx:hook selftest' || return 1
  assert_file_contains "$PKG_ROOT/runtime/session-state.json" 'ctx:hook selftest' || return 1
}

test_session_end_updates_metrics_and_archive() {
  reset_cursor_state
  cat > "$PKG_ROOT/metrics/leaderboard.md" <<'TABLE'
# Leaderboard
TABLE
  cat > "$PKG_ROOT/memory/learned-patterns/LP-old.md" <<'PATTERN'
---
hit-count: 0
---
PATTERN
  local output rc
  capture output rc bash "$HOOK_DIR/session-end.sh"
  assert_rc 0 "$rc" || return 1
  assert_file_exists "$PKG_ROOT/metrics/.leaderboard-update.log" || return 1
  assert_file_exists "$PKG_ROOT/memory/learned-patterns/archive/LP-old.md" || return 1
}

test_subagent_start_reports_default_tier() {
  reset_cursor_state
  local payload output rc
  payload="$(cursor_subagent_start_payload 'explore')"
  capture output rc bash "$HOOK_DIR/subagent-start.sh" <<<"$payload"
  assert_rc 0 "$rc" || return 1
  assert_contains "$output" '"permission":"allow"' || return 1
  assert_contains "$output" 'tier=T5 type=explore' || return 1
}

test_subagent_stop_suggests_next_spawn_packet() {
  reset_cursor_state
  mkdir -p "$PKG_ROOT/runtime/runs/run-1"
  cat > "$PKG_ROOT/runtime/runs/run-1/manifest.json" <<'JSON'
{"spawn_order":["agent-a","agent-b"]}
JSON
  local payload output rc
  payload="$(cursor_subagent_stop_payload 'agent-a')"
  capture output rc bash "$HOOK_DIR/subagent-stop.sh" <<<"$payload"
  assert_rc 0 "$rc" || return 1
  assert_contains "$output" 'spawn-packets/agent-b.md' || return 1
}

echo "Sandbox: $SANDBOX"
run_test "before-shell-execution allows safe commands" test_before_shell_allows_safe_command
run_test "before-shell-execution blocks git push" test_before_shell_blocks_git_push
run_test "before-shell-execution blocks curl/exfiltration commands" test_before_shell_blocks_curl
run_test "pre-tool-use-write allows safe write paths" test_pre_tool_use_allows_safe_write_path
run_test "pre-tool-use-write blocks analysis-root writes" test_pre_tool_use_blocks_analysis_root_write
run_test "post-tool-use-write records edit activity" test_post_tool_use_records_edit_activity
run_test "before-submit-prompt returns routed additional context" test_before_submit_prompt_returns_additional_context
run_test "session-end updates metrics and archives stale patterns" test_session_end_updates_metrics_and_archive
run_test "subagent-start reports the inferred tier" test_subagent_start_reports_default_tier
run_test "subagent-stop suggests the next spawn packet" test_subagent_stop_suggests_next_spawn_packet

echo "----------------------------------------"
printf 'Summary: tests=%d pass=%d fail=%d\n' "$TESTS_RUN" "$TESTS_PASS" "$TESTS_FAIL"
if [ "$TESTS_FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
