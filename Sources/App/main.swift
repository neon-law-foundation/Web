import AWSLambdaEvents
import Configuration
import Foundation
import Hummingbird
import HummingbirdLambda

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

switch env {
case "production", "staging":
    let router = Router(context: BasicLambdaRequestContext<APIGatewayV2Request>.self)
    router.middlewares.add(FileMiddleware(publicPath, searchForIndexHtml: false))
    router.get("") { _, _ in
        MainLayout(
            title: "Neon Law Foundation | Increasing Access to Justice with Open Source Software"
        ) {
            HomePage()
        }
    }
    let lambda = APIGatewayV2LambdaFunction(router: router)
    try await lambda.runService()
default:
    let router = Router()
    router.middlewares.add(FileMiddleware(publicPath, searchForIndexHtml: false))
    router.get("") { _, _ in
        MainLayout(
            title: "Neon Law Foundation | Increasing Access to Justice with Open Source Software"
        ) {
            HomePage()
        }
    }
    let app = Application(
        router: router,
        configuration: .init(address: .hostname("localhost", port: 8080))
    )
    try await app.runService()
}
