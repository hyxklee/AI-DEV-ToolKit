#!/bin/bash
# Validate bash commands before execution
# Exit code 2 blocks the command and shows stderr to Claude

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Block dangerous commands
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \$HOME"
  ":(){:|:&};:"
  "mkfs"
  "dd if=/dev"
  "> /dev/sda"
  "chmod -R 777 /"
  "curl.*|.*sh"
  "wget.*|.*sh"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "Blocked: Potentially dangerous command detected" >&2
    exit 2
  fi
done

# Block production database commands without confirmation
if echo "$COMMAND" | grep -iE "(DROP|TRUNCATE|DELETE FROM).*(prod|production)" > /dev/null; then
  echo "Blocked: Production database modification detected. Use with caution." >&2
  exit 2
fi

exit 0
