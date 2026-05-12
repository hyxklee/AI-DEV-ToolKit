#!/bin/bash

set -euo pipefail

COMMAND=$(jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

if echo "$COMMAND" | grep -Eq '(^|[;&|[:space:]])rm[[:space:]]+-rf([[:space:]]|$)|git[[:space:]]+reset[[:space:]]+--hard|git[[:space:]]+push[[:space:]].*--force'; then
  cat <<'JSON'
{
  "decision": "block",
  "reason": "Blocked destructive command during live coding interview."
}
JSON
  exit 0
fi

if echo "$COMMAND" | grep -Eq '(^|[;&|[:space:]])(npm|pnpm|yarn)[[:space:]]+(install|add|i)([[:space:]]|$)|(^|[;&|[:space:]])(\./)?gradlew?[[:space:]]+(.*[[:space:]])?:?dependencies([[:space:]]|$)'; then
  cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "Live coding guard: dependency-related command detected. Do not add dependencies unless the user explicitly approved it."
  }
}
JSON
fi
