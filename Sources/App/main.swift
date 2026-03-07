import AWSLambdaEvents
import Configuration
import Foundation
import HarnessDAL
import HarnessDatabaseService
import Hummingbird
import HummingbirdLambda
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

// MARK: - Router helpers

let pageTitle = "Neon Law Foundation | Increasing Access to Justice with Open Source Software"

// MARK: - Run

switch env {
case "production", "staging":
    let host = config.string(forKey: "database.host", default: "")
    let port = config.string(forKey: "database.port", default: "5432")
    let name = config.string(forKey: "database.name", default: "")
    let username = config.string(forKey: "database.username", default: "")
    let password = config.string(forKey: "database.password", default: "")
    let databaseURL = "postgres://\(username):\(password)@\(host):\(port)/\(name)"
    let databaseService = try DatabaseService(databaseURL: databaseURL)
    let db = try await databaseService.db
    let router = Router(context: BasicLambdaRequestContext<APIGatewayV2Request>.self)
    router.middlewares.add(FileMiddleware(publicPath, searchForIndexHtml: false))
    router.get("") { _, _ in
        MainLayout(title: pageTitle) { HomePage() }
    }
    try APIImpl(database: db).registerHandlers(on: router.group("api"))
    let lambda = APIGatewayV2LambdaFunction(router: router)
    try await lambda.runService()
default:
    let databaseService = DatabaseService(configuration: .file("harness.sqlite"))
    try await databaseService.migrate()
    let db = try await databaseService.db
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
