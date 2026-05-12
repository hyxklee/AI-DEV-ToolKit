# Kotlin Spring Vertical Slice Template

Use this as a structure guide, not as code to paste blindly. Match the target project first.

## API Contract

```text
GET    {prefix}/{resources}
POST   {prefix}/{resources}
GET    {prefix}/{resources}/{id}
PATCH  {prefix}/{resources}/{id}
DELETE {prefix}/{resources}/{id}
```

Use only the endpoints required by the task.

## Sprint/Core File Shape

Use this when the project has no richer architecture or time is limited:

```text
{resource}/
  {Resource}Controller.kt
  {Resource}Service.kt
  {Resource}Repository.kt
  {Resource}.kt
  dto/Create{Resource}Request.kt
  dto/{Resource}Response.kt
```

## Full/Polish File Shape

Use this only when the project already uses this style, or the task needs the separation:

```text
domain/{resource}/presentation/{Resource}Controller.kt
domain/{resource}/application/dto/request/Create{Resource}Request.kt
domain/{resource}/application/dto/request/Update{Resource}Request.kt
domain/{resource}/application/dto/response/{Resource}Response.kt
domain/{resource}/application/usecase/command/{Verb}{Resource}UseCase.kt
domain/{resource}/application/usecase/query/Get{Resource}QueryService.kt
domain/{resource}/application/mapper/{Resource}Mapper.kt
domain/{resource}/application/exception/{Resource}NotFoundException.kt
domain/{resource}/domain/entity/{Resource}.kt
domain/{resource}/domain/repository/{Resource}Repository.kt
```

## Cut Rules

- Sprint: create only the files needed for the happy path.
- Core: add validation and 1-2 expected failures.
- Full: add focused tests for the riskiest behavior.
- Polish: add broader tests, docs, and error UX.
