---
name: commit
description: Generate and create commits following project conventions.
disable-model-invocation: true
---

# Commit Command

Analyze changes and create commits following project conventions.

## Commit Convention

**Format**: `type: message`

| Type | Description | Example |
|------|-------------|---------|
| feat | New feature | feat: Add user authentication API |
| fix | Bug fix | fix: Resolve null pointer in feed service |
| refactor | Code refactoring | refactor: Split FeedService into Get/Save |
| test | Test code | test: Add FeedService unit tests |
| docs | Documentation | docs: Update API documentation |
| style | Code formatting | style: Apply code formatter |
| chore | Build, config | chore: Update gradle dependencies |
| perf | Performance | perf: Optimize database queries |

## Execution Steps

### 1. Check Changes
```bash
git status
git diff --staged
git diff
```

### 2. Reference Recent Commits
```bash
git log --oneline -10
```

### 3. Commit Message Rules
- Focus on "why" not "what"
- Keep under 50 characters
- No period at end
- Use imperative mood ("Add" not "Added")

### 4. Create Commit

```bash
git add [files]
git commit -m "$(cat <<'EOF'
type: commit message

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

## Examples

```bash
# New feature
git commit -m "$(cat <<'EOF'
feat: Add feed like functionality

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# Bug fix
git commit -m "$(cat <<'EOF'
fix: Apply soft delete on feed deletion

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# Refactoring
git commit -m "$(cat <<'EOF'
refactor: Split FeedService into GetService/SaveService

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

## Attention

- Run linter before commit (e.g., `./gradlew ktlintCheck`, `npm run lint`)
- Check for sensitive info (.env, credentials)
- Split large changes into logical units
- Use specific file names instead of `git add .`
