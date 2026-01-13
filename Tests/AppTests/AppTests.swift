import Hummingbird
import HummingbirdTesting
import Testing

@testable import App

@Suite("NLF Web Tests")
struct AppTests {
    @Test("Home page returns 200")
    func testHomePage() async throws {
        let app = try await buildApplication()
        try await app.test(.router) { client in
            try await client.execute(uri: "/", method: .get) { response in
                #expect(response.status == .ok)
                #expect(response.headers[.contentType] == "text/html; charset=utf-8")
            }
        }
    }
}

func buildApplication() async throws -> some ApplicationProtocol {
    let router = Router()
    router.middlewares.add(FileMiddleware(searchForIndexHtml: false))
    router.get("") { _, _ in
        MainLayout(title: "Neon Law Foundation | Increasing Access to Justice with Open Source Software") {
            HomePage()
        }
    }
    return Application(router: router)
}
