# Rules Directory

This kit intentionally does not ship project-specific rules.

Run `/setup` in the target interview project. The setup command inspects the repository and writes:

- `.interview-context.md`: task, constraints, time tier, implementation target, verification
- `.interview-rules.md`: project-specific architecture, API, frontend, testing, and style rules

All commands and skills should prefer those generated files over static assumptions.
