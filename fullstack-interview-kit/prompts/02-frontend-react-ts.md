# Frontend Prompt: React TypeScript

Use this prompt when implementing frontend code in a React + TypeScript live coding interview.

For detailed conventions (file layout, types, API layer, page state, forms, accessibility), read `.interview-rules.md` first. If it is missing, infer conventions from nearby frontend code.

## Rules

- Use TypeScript types for API request and response shapes.
- Keep components cohesive; avoid splitting into tiny files unless reuse is real.
- Handle loading, error, empty, and success states.
- Use semantic HTML for forms, labels, buttons, and lists.
- Prefer simple local state for interview tasks.
- Use existing project libraries if present.
- Do not introduce a new state or data-fetching library unless the project already uses it.
- Keep CSS restrained, readable, and responsive.
- Do not build a marketing landing page when the task is an app workflow.

## Checklist

1. Define TypeScript API types first.
2. Create API functions with a single error handling path.
3. Build the main page as a complete workflow.
4. Add form validation before submit.
5. Render loading, error, empty, and list states.
6. Disable submit buttons while pending.
7. Refresh or update local state after mutations.
8. Verify with the browser or a simple manual test path.
