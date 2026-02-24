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
            url: "https://github.com/neon-law-foundation/SagebrushStandards.git",
            branch: "main"
        ),
        .package(url: "https://github.com/apple/swift-configuration.git", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdLambda", package: "hummingbird-lambda"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "Elementary", package: "elementary"),
                .product(name: "SagebrushDAL", package: "SagebrushStandards"),
                .product(name: "Configuration", package: "swift-configuration"),
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .byName(name: "App"),
                .product(name: "HummingbirdTesting", package: "hummingbird"),
            ]
        ),
    ]
)
