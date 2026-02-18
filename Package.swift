// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "NLFWeb",
    platforms: [
        .macOS(.v14)
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
        .package(url: "https://github.com/sliemeobn/elementary.git", from: "0.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdLambda", package: "hummingbird-lambda"),
                .product(name: "Elementary", package: "elementary"),
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
