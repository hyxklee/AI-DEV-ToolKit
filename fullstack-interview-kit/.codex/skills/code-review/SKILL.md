---
name: code-review
description: Review code changes for interview readiness. Detect bugs, requirement gaps, risky changes, missing validation, missing UI states, and verification gaps.
allowed-tools: Glob, Grep, Read, Bash
---

# Code Review

Review as an interview final check. Match the user's prompt language.

## Required Context

Read `.interview-context.md` and `.interview-rules.md` when they exist.

## Workflow

1. Identify changed files.
2. Compare the implementation against captured requirements and assumptions.
3. Review by severity:
   - Critical: incorrect behavior, data loss, security issue, submission blocker
   - Major: missing requirement, missing validation, broken API/UI contract, risky transaction/state issue
   - Minor: naming, duplication, style drift, dead code
   - Suggestion: polish or follow-up
4. Check verification:
   - tests run
   - build/lint run
   - manual path covered
5. End with a short interviewer-facing explanation.

## Checklist

- Requirement coverage
- API contract consistency
- Backend validation and expected failures
- Frontend loading, error, empty, and success states
- Project convention fit from `.interview-rules.md`
- Unnecessary files or unrelated refactors
- Dependency additions
- Test or manual verification gap

## Output Shape

```markdown
## Findings
- [Severity] file:line - issue and concrete fix

## Verification
- Ran:
- Not run:
- Manual path:

## Explanation
- ...
```

If no issues are found, say that clearly and mention remaining verification risk.
