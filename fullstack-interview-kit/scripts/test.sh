#!/bin/bash

set -euo pipefail

TARGET="${1:-}"
RAN=0

run_gradle_test() {
  local dir="$1"
  [ -x "$dir/gradlew" ] || return 0

  RAN=1
  (
    cd "$dir"
    if [ -n "$TARGET" ]; then
      ./gradlew test --tests "$TARGET"
    else
      ./gradlew test
    fi
  )
}

run_node_test() {
  local dir="$1"
  [ -f "$dir/package.json" ] || return 0

  local scripts
  scripts="$(cd "$dir" && npm run 2>/dev/null || true)"
  if ! printf "%s" "$scripts" | grep -qE "^  test$|^  test:"; then
    return 0
  fi

  RAN=1
  (
    cd "$dir"
    if [ -n "$TARGET" ]; then
      npm test -- "$TARGET"
    else
      npm test
    fi
  )
}

for dir in . backend server api; do
  run_gradle_test "$dir"
done

for dir in . frontend client web app; do
  run_node_test "$dir"
done

if [ "$RAN" -eq 0 ]; then
  echo "No known test command found. Run the project's test command manually."
fi
