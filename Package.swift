// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NLFWeb",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "App", targets: ["App"])
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0"),
        .package(
            url: "https://github.com/hummingbird-project/hummingbird-lambda.git",
            from: "2.0.0"
        ),
        .package(url: "https://github.com/awslabs/swift-aws-lambda-events.git", from: "1.0.0"),
        .package(url: "https://github.com/sliemeobn/elementary.git", from: "0.3.0"),
        .package(
            url: "https://github.com/neon-law-foundation/Harness.git",
            branch: "feature/dry-and-rename-flow-alignment"
        ),
        .package(url: "https://github.com/apple/swift-configuration.git", from: "1.0.0"),
        .package(
            url: "https://github.com/apple/swift-openapi-generator.git",
            from: "1.10.3"
        ),
        .package(
            url: "https://github.com/apple/swift-openapi-runtime.git",
            from: "1.9.0"
        ),
        .package(
            url: "https://github.com/swift-server/swift-openapi-hummingbird.git",
            from: "2.0.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdLambda", package: "hummingbird-lambda"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "Elementary", package: "elementary"),
                .product(name: "HarnessDAL", package: "Harness"),
                .product(name: "HarnessElementary", package: "Harness"),
                .product(name: "HarnessDatabaseService", package: "Harness"),
                .product(name: "Configuration", package: "swift-configuration"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIHummingbird", package: "swift-openapi-hummingbird"),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .byName(name: "App"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
                .product(name: "HarnessDAL", package: "Harness"),
            ]
        ),
    ]
)
