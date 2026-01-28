---
name: pr
description: Create GitHub Pull Request. Analyze changes and format according to PR template.
disable-model-invocation: true
---

# Pull Request Command

Analyze current branch changes and create PR.

## Execution Steps

### 1. Check Current State (parallel)
```bash
# Branch status
git status
git branch --show-current

# Changes from base branch
git diff main...HEAD --stat    # or dev...HEAD
git log main..HEAD --oneline   # or dev..HEAD

# Remote sync status
git fetch origin
git status -sb
```

### 2. Analyze Changes
- List of changed files
- Commit history (all commits since branching)
- Affected domains/features

### 3. Create PR
- Check project's PR template (.github/pull_request_template.md)
- Generate complete PR script

## PR Title Format
- Check project's PR template if exists
- Default: `type: Brief description`

## PR Body Template (Default)
```markdown
## 작업 내용 💻
-

## 스크린샷 📷
- 

## 같이 얘기해보고 싶은 내용이 있다면 작성 📢
-
```

## Attention

- Run tests before PR: `./gradlew test` or `npm test`
- Run linter: `./gradlew ktlintCheck` or `npm run lint`
- Confirm base branch (main, dev, etc.)
- Split large PRs into smaller units
- Consider Draft PR for early feedback: `gh pr create --draft`

## Useful Commands

```bash
# Create Draft PR
gh pr create --draft --base main

# PR status
gh pr status

# List PRs
gh pr list

# View PR
gh pr view

# Edit PR
gh pr edit --title "New title" --body "New body"

# Create PR with title and body
gh pr create --title "feat: Add feature" --body "$(cat <<'EOF'
## Summary
- Description here
EOF
)"
```
