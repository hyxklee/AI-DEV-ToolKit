#!/bin/bash

set -euo pipefail

FILE_PATH=$(jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

if [[ "$FILE_PATH" != *.kt ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR" || exit 0

if [ ! -x "./gradlew" ]; then
  exit 0
fi

if ! ./gradlew tasks --all 2>/dev/null | grep -q "ktlintFormat"; then
  exit 0
fi

./gradlew ktlintFormat 2>&1 >&2
