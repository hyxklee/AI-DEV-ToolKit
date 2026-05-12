---
name: interview-context-sync
description: Synchronize active context for a full-stack live coding interview. Use when the user says interview, live coding, 면접, 라이브 코딩, 과제, 구현 시작, 문제 풀자, context sync, or switches between backend/frontend/debug/review modes.
---

# Interview Context Sync

Load the right context before answering or editing code for a live coding interview.

## Required Baseline

Read:

1. `AGENTS.md`
2. `.interview-context.md` if it exists
3. `.interview-rules.md` if it exists
4. `prompts/00-fullstack-live-coding.md`
5. `checklist/live-coding-flow.md`

If `.interview-context.md` or `.interview-rules.md` is missing and the prompt contains a full task, recommend `/setup` before implementation.

## Mode Routing

Choose all modes that apply:

| Mode | Required context |
|------|------------------|
| Backend | `prompts/01-backend-kotlin-spring.md`, `.interview-rules.md` |
| Frontend | `prompts/02-frontend-react-ts.md`, `.interview-rules.md` |
| Test | `.interview-rules.md`, `.codex/skills/test-create/SKILL.md` |
| Debug | `prompts/03-debugging.md`, `.codex/skills/systematic-debugging/SKILL.md` |
| Review | `prompts/04-final-review.md`, `.codex/skills/code-review/SKILL.md` |
| DB | `.interview-rules.md`, `.codex/skills/database-manage/SKILL.md` |

## Time Tier

Use `.interview-context.md` when present. Otherwise infer from the prompt. If unknown, assume Core and state the assumption:

- Sprint: <= 30 min
- Core: <= 60 min
- Full: <= 90 min
- Polish: > 90 min

## Output

Before implementation, briefly state:

```text
Context synced:
- Mode: ...
- Tier: Sprint | Core | Full | Polish
- Context: loaded | setup needed
- Rules: loaded | setup needed
- Execution: smallest vertical slice first
```

Match the user's prompt language. Code identifiers stay English.

Then continue with the task.
