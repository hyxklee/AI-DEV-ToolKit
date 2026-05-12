---
name: live-coding
description: Stepwise live coding interview routine. Use when the user asks to analyze, plan, implement one step, generate test cases, review, or explain an interview task.
---

# Live Coding

Use this skill to keep the interview flow controlled and explainable.

## Commands To Emulate

### analyze

- Read `.interview-context.md` and `.interview-rules.md` first if they exist.
- Summarize requirements.
- Identify inputs, outputs, domain concepts, assumptions, and edge cases.
- Ask only blocking questions.
- Do not edit files.

### plan

- Read `.interview-context.md` and `.interview-rules.md` first if they exist.
- Propose 3 or fewer implementation steps.
- Include candidate files and verification for each step.
- Do not write code yet.

### implement-step

- Read `.interview-context.md` and `.interview-rules.md` first if they exist.
- Implement only the next smallest step.
- Preserve existing style and architecture.
- Avoid unrelated refactors and new dependencies.
- Summarize changed files and verification.

### test-cases

- Read `.interview-context.md` and `.interview-rules.md` first if they exist.
- Generate happy path, boundary, failure, and validation cases.
- Suggest the narrowest useful command.

### review

- Read `.interview-context.md` and `.interview-rules.md` first if they exist.
- Check requirement coverage, validation, UI states, tests, and risks.
- Findings first; keep concise.

### explain

- Produce a 60-90 second interviewer-facing explanation.
- Match the user's prompt language. Code identifiers stay English.

## Rule

Run `.codex/skills/interview-context-sync/SKILL.md` first when the task mentions interview/live coding or changes mode.

Run `/setup` first when `.interview-context.md` or `.interview-rules.md` is missing, or when requirements change.

Decide a time tier (Sprint ≤30min / Core ≤60min / Full ≤90min / Polish >90min) and announce it before implementing. See `checklist/live-coding-flow.md`.
