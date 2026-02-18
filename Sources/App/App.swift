import AWSLambdaEvents
import Foundation
import Hummingbird
import HummingbirdLambda

@main
struct App {
    static func main() async throws {
        let router = Router(context: BasicLambdaRequestContext<APIGatewayV2Request>.self)

        let publicPath =
            ProcessInfo.processInfo.environment["PUBLIC_DIR"]
            ?? URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Public")
            .path

        router.middlewares.add(
            FileMiddleware(
                publicPath,
                searchForIndexHtml: false
            )
        )

        router.get("") { _, _ in
            MainLayout(
                title: "Neon Law Foundation | Increasing Access to Justice with Open Source Software"
            ) {
                HomePage()
            }
        }

        let lambda = APIGatewayV2LambdaFunction(router: router)
        try await lambda.runService()
    }
}
