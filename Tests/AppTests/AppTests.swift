import FluentKit
import FluentSQLiteDriver
import Foundation
import HarnessDAL
import Hummingbird
import HummingbirdTesting
import Logging
import OpenAPIHummingbird
import OpenAPIRuntime
import Testing

@testable import App

@Suite("NLF Web Tests", .serialized)
struct AppTests {
    @Test("Home page returns 200")
    func testHomePage() async throws {
        let (app, databases, dbPath) = try await buildApplication()
        try await app.test(.router) { client in
            try await client.execute(uri: "/", method: .get) { response in
                #expect(response.status == .ok)
                #expect(response.headers[.contentType] == "text/html; charset=utf-8")
            }
        }
        await databases.shutdownAsync()
        try? FileManager.default.removeItem(atPath: dbPath)
    }

    @Test("GET /api/questions returns 200 with JSON array")
    func testListQuestions() async throws {
        let (app, databases, dbPath) = try await buildApplication()
        try await app.test(.router) { client in
            try await client.execute(uri: "/api/questions", method: .get) { response in
                #expect(response.status == .ok)
                #expect(response.headers[.contentType]?.hasPrefix("application/json") == true)
            }
        }
        await databases.shutdownAsync()
        try? FileManager.default.removeItem(atPath: dbPath)
    }
}

func buildApplication() async throws -> (some ApplicationProtocol, Databases, String) {
    let dbPath = FileManager.default.temporaryDirectory
        .appendingPathComponent("test-nlf-\(UUID().uuidString).sqlite")
        .path
    let databases = Databases(
        threadPool: .singleton,
        on: MultiThreadedEventLoopGroup.singleton
    )
    databases.use(.sqlite(.file(dbPath)), as: .sqlite)

    let migrations = Migrations()
    for migration in HarnessDALConfiguration.migrations {
        migrations.add(migration)
    }
    let migrator = Migrator(
        databases: databases,
        migrations: migrations,
        logger: Logger(label: "test"),
        on: MultiThreadedEventLoopGroup.singleton.next()
    )
    do {
        try await migrator.setupIfNeeded().get()
        try await migrator.prepareBatch().get()
    } catch {
        await databases.shutdownAsync()
        try? FileManager.default.removeItem(atPath: dbPath)
        throw error
    }

    let db = databases.database(
        .sqlite,
        logger: Logger(label: "test"),
        on: MultiThreadedEventLoopGroup.singleton.next()
    )!

    let router = Router()
    router.middlewares.add(FileMiddleware(searchForIndexHtml: false))
    router.get("") { _, _ in
        MainLayout(
            title: "Neon Law Foundation | Increasing Access to Justice with Open Source Software"
        ) {
            HomePage()
        }
    }
    do {
        try APIImpl(database: db).registerHandlers(on: router.group("api"))
    } catch {
        await databases.shutdownAsync()
        try? FileManager.default.removeItem(atPath: dbPath)
        throw error
    }

    return (Application(router: router), databases, dbPath)
}
