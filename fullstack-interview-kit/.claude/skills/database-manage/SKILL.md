---
name: database-manage
description: Inspect database schema and persistence model. Use when asked to show schema, tables, DB context, entity structure, migrations, ERD, 스키마, 테이블, 엔티티 구조, or DB 확인.
allowed-tools: Read, Glob, Grep, Bash
---

# Database Manage

Inspect schema from the target project. Match the user's prompt language.

## Required Context

Read `.interview-context.md` and `.interview-rules.md` when they exist.

## Source Priority

1. Existing project docs or generated schema files.
2. Migration files: Flyway, Liquibase, SQL migrations, Prisma migrations, Rails migrations, etc.
3. Entity/model files: JPA entities, Prisma schema, TypeORM models, Drizzle schema, SQLAlchemy models, etc.
4. Live database introspection only when connection info is already available or the user provides it.

## Workflow

1. Identify database technology from project files.
2. Inspect configuration without exposing secrets.
3. Inspect schema sources in priority order.
4. Summarize tables/models, key fields, indexes, relationships, and risky constraints.
5. Note uncertainty when schema is inferred from code instead of a live DB.

## Live DB Rules

- Never guess passwords.
- Prefer environment variables or existing local config.
- Mask credentials in output.
- Do not modify data.
- If a bundled script is database-specific, treat it as optional and only use it when it matches the project.

## Output Shape

```markdown
## Database Context
- DB/tool:
- Source used:
- Confidence:

## Tables / Models
| Name | Key fields | Relationships | Notes |
|------|------------|---------------|-------|

## Constraints / Indexes
- ...

## Interview Relevance
- ...
```
