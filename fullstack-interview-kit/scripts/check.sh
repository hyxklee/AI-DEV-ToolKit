#!/bin/bash

set -euo pipefail

RAN=0

run_gradle_check() {
  local dir="$1"
  [ -x "$dir/gradlew" ] || return 0

  RAN=1
  (
    cd "$dir"
    local tasks
    tasks="$(./gradlew tasks --all 2>/dev/null || true)"
    if printf "%s" "$tasks" | grep -q "ktlintCheck"; then
      ./gradlew ktlintCheck
    elif printf "%s" "$tasks" | grep -q "compileKotlin"; then
      ./gradlew compileKotlin
    elif printf "%s" "$tasks" | grep -q "compileJava"; then
      ./gradlew compileJava
    else
      ./gradlew testClasses
    fi
  )
}

run_node_check() {
  local dir="$1"
  [ -f "$dir/package.json" ] || return 0

  RAN=1
  (
    cd "$dir"
    local scripts
    scripts="$(npm run 2>/dev/null || true)"
    if printf "%s" "$scripts" | grep -qE "^  lint$|^  lint:"; then
      npm run lint
    elif printf "%s" "$scripts" | grep -qE "^  typecheck$|^  typecheck:"; then
      npm run typecheck
    elif printf "%s" "$scripts" | grep -qE "^  type-check$|^  type-check:"; then
      npm run type-check
    elif printf "%s" "$scripts" | grep -qE "^  build$|^  build:"; then
      npm run build
    elif printf "%s" "$scripts" | grep -qE "^  test$|^  test:"; then
      npm test -- --runInBand
    else
      echo "package.json found in $dir, but no lint/typecheck/build/test script was detected."
    fi
  )
}

for dir in . backend server api; do
  run_gradle_check "$dir"
done

for dir in . frontend client web app; do
  run_node_check "$dir"
done

if [ "$RAN" -eq 0 ]; then
  echo "No known check command found. Run the project's narrowest available verification manually."
fi
