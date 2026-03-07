# NLF Web Roadmap

## Step 1: Add package dependencies

Add to `Package.swift`:

- `swift-openapi-generator` — build tool plugin that generates Swift types and
  handler protocols from `openapi.yaml` at compile time
- `swift-openapi-runtime` — runtime types used by the generated code
- `swift-openapi-hummingbird` — transport adapter wiring the generated API into
  Hummingbird's router
- `hummingbird-fluent` — integrates FluentKit into Hummingbird's service
  lifecycle (connection pool, graceful shutdown)
- `fluent-sqlite-driver` — SQLite driver for local development
- `fluent-postgres-driver` — Postgres driver for staging and production

Add `HummingbirdFluent`, `OpenAPIRuntime`, `OpenAPIHummingbird`,
`FluentSQLiteDriver`, and `FluentPostgresDriver` to the `App` target
dependencies. Add the `OpenAPIGenerator` build tool plugin to the target.

## Step 2: Define openapi.yaml

Create `Sources/App/openapi.yaml` declaring:

- `openapi: "3.1.0"`
- Server mounted at `/api`
- `GET /api/questions` — returns an array of `Question` objects, sorted by
  `code`

The `Question` schema mirrors the `HarnessDAL` `Question` model:

```yaml
Question:
  type: object
  required: [id, code, prompt, questionType]
  properties:
    id:          { type: integer }
    code:        { type: string }
    prompt:      { type: string }
    questionType:
      type: string
      enum: [string, text, date, datetime, number, yes_no, radio, select,
             multi_select, secret, phone, email, ssn, ein, file, person,
             address, org]
    helpText:    { type: string, nullable: true }
    choices:
      type: object
      additionalProperties: { type: string }
      nullable: true
    insertedAt:  { type: string, format: date-time, nullable: true }
    updatedAt:   { type: string, format: date-time, nullable: true }
```

## Step 3: Wire Fluent into main.swift

Set up the database connection before starting the router, gated on `env`:

- `local` — `FluentSQLiteDriver` with a local file `harness.sqlite`
- `staging` / `production` — `FluentPostgresDriver` using the env vars that
  `APILambdaStack` injects: `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_NAME`,
  `DATABASE_SECRET_ARN`

Register `HarnessDALConfiguration.migrations` with the Fluent migrator but
**do not call `autoMigrate()`**. The web Lambda assumes the schema is already
correct. Migrations are the responsibility of the migration Lambda (see below).

## Step 4: Implement the generated API protocol

Swift OpenAPI Generator will emit a protocol (e.g. `APIProtocol`) from
`openapi.yaml`. Create `Sources/App/APIImpl.swift` conforming to it:

- `listQuestions(_:)` — calls `QuestionRepository(database: db).findAll()`,
  sorts by `code`, maps each `Question` Fluent model to the generated
  `Components.Schemas.Question` response type, and returns `.ok(.init(body:
  .json(questions)))`

Register the implementation with the Hummingbird router via the
`OpenAPIHummingbird` transport.

## Step 5: Update buildspec.yml for migrations

After `aws lambda update-function-code` deploys the web Lambda, add a step
that invokes the migration Lambda synchronously:

```yaml
- aws lambda invoke
    --function-name $MIGRATION_LAMBDA_FUNCTION_NAME
    --invocation-type RequestResponse
    --log-type Tail
    /tmp/migration-result.json
```

Add `MIGRATION_LAMBDA_FUNCTION_NAME` to the CodeBuild project's environment
variables (set in `Sagebrush/AWS` via `CodeBuildStack`).

The migration Lambda runs `HarnessDALConfiguration.migrations` against Aurora
and exits. The web Lambda then starts with a guaranteed up-to-date schema.

## Sagebrush/AWS prerequisites

Before any of the above can run in staging or production, the following stacks
must be deployed in the neonlaw account. See `Sagebrush/AWS/README.md` for the
full deployment sequence:

1. ACM certificate (`nlf-web-cert`) in `us-east-1`
2. VPC + Aurora stacks (confirm which stacks to reference)
3. `APILambdaStack` (`nlf-web`) — Lambda + API Gateway + VPC + RDS wiring
4. `MigrationLambdaStack` (`nlf-web-migrations`) — separate migration runner
5. `CodeBuildStack` (`nlf-web-build`) — with both `LAMBDA_FUNCTION_NAME` and
   `MIGRATION_LAMBDA_FUNCTION_NAME` env vars
6. Route53 alias record `www.neonlaw.org` → API Gateway regional domain
