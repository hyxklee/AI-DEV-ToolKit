---
name: architecture-guide
description: Show project-specific architecture guidance. Use when asked how to structure a feature or when implementation needs architecture clarification.
allowed-tools: Read, Glob, Grep
---

# Architecture Guide

Guide architecture from the target project, not from the kit. Match the user's prompt language.

## Required Context

Read `.interview-context.md` and `.interview-rules.md` when they exist. If `.interview-rules.md` is missing, inspect similar features before recommending structure.

## Workflow

1. Find similar feature files.
2. Identify the current project shape:
   - route/controller layer
   - application/service layer
   - data access layer
   - DTO/model mapping
   - transaction/error style
3. Recommend the lightest structure that fits the task and time tier.
4. State which abstractions are intentionally skipped.

## Output Shape

```markdown
## Recommended Shape
- ...

## Files
- ...

## Why
- ...

## Skipped
- ...
```

## Rules

- Do not introduce architecture layers that are absent from the project unless the task clearly needs them.
- Do not create wrappers around existing code just to match a preferred pattern.
- In Sprint/Core, prefer fewer files and clear behavior.
- In Full/Polish, add structure only where it improves clarity or matches existing code.
