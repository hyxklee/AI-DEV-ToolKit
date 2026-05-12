---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes.
---

# Systematic Debugging

Debug with evidence, not guesses. Match the user's prompt language.

## Required Context

Read `.interview-context.md` and `.interview-rules.md` when they exist.

## Workflow

1. Collect the exact symptom:
   - error message or failing assertion
   - expected behavior
   - reproduction steps
   - environment or command used
2. Identify the failing layer:
   - UI/browser
   - API client
   - controller/route
   - application logic
   - domain logic
   - persistence
   - build/tooling
3. Form 2-4 hypotheses in priority order.
4. Verify the cheapest hypothesis first.
5. Make the smallest fix.
6. Re-run the narrowest verification.
7. Search for the same pattern if the bug may repeat.

## Output Shape

```markdown
## Symptom
- ...

## Hypotheses
| Hypothesis | Likelihood | Verification |
|------------|------------|--------------|
| ... | High | ... |

## Root Cause
- File:
- Cause:

## Fix
- ...

## Verification
- Command:
- Result:
```

## Rules

- Do not propose a fix before checking the relevant code or failure output.
- Do not invent project-specific patterns.
- Prefer narrow verification over broad test runs.
- If verification cannot be run, provide a manual check path.
