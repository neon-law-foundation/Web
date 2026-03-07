import AWSLambdaEvents
import Configuration
import FluentKit
import FluentPostgresDriver
import FluentSQLiteDriver
import Foundation
import HarnessDAL
import Hummingbird
import HummingbirdLambda
import Logging
import OpenAPIHummingbird
import OpenAPIRuntime

let config = ConfigReader(provider: EnvironmentVariablesProvider())
let env = config.string(forKey: "env", default: "local").lowercased()

let publicPath =
    ProcessInfo.processInfo.environment["PUBLIC_DIR"]
    ?? URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("Public")
    .path

// MARK: - Database setup

let databases = Databases(
    threadPool: .singleton,
    on: MultiThreadedEventLoopGroup.singleton
)
let dbLogger = Logger(label: "fluent")

switch env {
case "production", "staging":
    let host = ProcessInfo.processInfo.environment["DATABASE_HOST"] ?? ""
    let port = Int(ProcessInfo.processInfo.environment["DATABASE_PORT"] ?? "5432") ?? 5432
    let name = ProcessInfo.processInfo.environment["DATABASE_NAME"] ?? ""
    let username = ProcessInfo.processInfo.environment["DATABASE_USERNAME"] ?? ""
    let password = ProcessInfo.processInfo.environment["DATABASE_PASSWORD"] ?? ""
    try databases.use(
        .postgres(url: "postgres://\(username):\(password)@\(host):\(port)/\(name)"),
        as: .psql
    )
default:
    databases.use(.sqlite(.file("harness.sqlite")), as: .sqlite)
}

// Register migrations so the migrator knows the schema, but do NOT run
// autoMigrate. Migrations are executed by the dedicated MigrationLambda
// after each deployment.
let migrations = Migrations()
for migration in HarnessDALConfiguration.migrations {
    migrations.add(migration)
}

let dbID: DatabaseID = (env == "production" || env == "staging") ? .psql : .sqlite
let db = databases.database(dbID, logger: dbLogger, on: MultiThreadedEventLoopGroup.singleton.next())!

// MARK: - Router helpers

let pageTitle = "Neon Law Foundation | Increasing Access to Justice with Open Source Software"

// MARK: - Run

switch env {
case "production", "staging":
    let router = Router(context: BasicLambdaRequestContext<APIGatewayV2Request>.self)
    router.middlewares.add(FileMiddleware(publicPath, searchForIndexHtml: false))
    router.get("") { _, _ in
        MainLayout(title: pageTitle) { HomePage() }
    }
    try APIImpl(database: db).registerHandlers(on: router.group("api"))
    let lambda = APIGatewayV2LambdaFunction(router: router)
    try await lambda.runService()
default:
    let router = Router()
    router.middlewares.add(FileMiddleware(publicPath, searchForIndexHtml: false))
    router.get("") { _, _ in
        MainLayout(title: pageTitle) { HomePage() }
    }
    try APIImpl(database: db).registerHandlers(on: router.group("api"))
    let app = Application(
        router: router,
        configuration: .init(address: .hostname("localhost", port: 8000))
    )
    try await app.runService()
}
