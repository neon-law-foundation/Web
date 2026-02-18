import Foundation
import Hummingbird
import HummingbirdLambda

@main
struct App: APIGatewayV2LambdaFunction {
    init(context: LambdaInitializationContext) async throws {}

    func buildRouter() -> Router<LambdaRequestContext<APIGatewayV2Request>> {
        let router = Router(context: LambdaRequestContext<APIGatewayV2Request>.self)

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

        return router
    }
}
