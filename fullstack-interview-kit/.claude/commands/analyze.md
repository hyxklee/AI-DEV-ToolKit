# Analyze Live Coding Task

You are assisting in a live coding interview.

Do not write code yet.

Read `.interview-context.md` and `.interview-rules.md` first if they exist. If they do not exist and `$ARGUMENTS` contains the interview task, recommend running `/setup` but still provide a lightweight analysis from the available prompt.

Given the current task or `$ARGUMENTS`, produce:

1. Requirement summary
2. Inputs and outputs
3. Core domain concepts
4. Hidden constraints and assumptions
5. Edge case candidates
6. Blocking questions only

Rules:

- Keep it concise enough to say out loud.
- Separate facts from assumptions.
- Do not propose a large design.
- Do not edit files.
- Keep the target project's conventions and captured setup constraints in scope.
- End with the smallest vertical slice candidate.
