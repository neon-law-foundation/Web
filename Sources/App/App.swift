import Foundation
import Hummingbird

@main
struct App {
    static func main() async throws {
        let router = Router()

        // Serve static files from Public directory
        let publicPath = URL(fileURLWithPath: #filePath)
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

        // Home page
        router.get("") { _, _ in
            MainLayout(title: "Neon Law Foundation | Increasing Access to Justice with Open Source Software") {
                HomePage()
            }
        }

        // Use 127.0.0.1 for development, 0.0.0.0 for production
        let env = ProcessInfo.processInfo.environment["ENV"] ?? "development"
        let hostname = env.lowercased() == "production" ? "0.0.0.0" : "127.0.0.1"

        let app = Application(
            router: router,
            configuration: .init(address: .hostname(hostname, port: 8080)),
            onServerRunning: { _ in
                print("Server running on http://\(hostname):8080/ (ENV: \(env))")
                print("Public files served from: \(publicPath)")
            }
        )

        try await app.runService()
    }
}
