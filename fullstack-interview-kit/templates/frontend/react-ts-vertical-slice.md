# React TypeScript Vertical Slice Template

Use this as a structure guide, not as code to paste blindly.

## Files

```text
src/types/{resource}.ts
src/api/{resource}.ts
src/pages/{Resource}Page.tsx
```

Start with fewer files for small interview projects. Extract these only when reuse or readability justifies it:

```text
src/components/{Resource}Form.tsx
src/components/{Resource}List.tsx
```

## Sequence

1. Define TypeScript types from backend DTOs.
2. Implement API functions.
3. Build page state: `items`, `loading`, `error`, `submitting`.
4. Fetch initial data.
5. Add form submission.
6. Render empty/list states.
7. Refresh state after mutation.
8. Verify in browser.
