// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "IdleHandsKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "IdleHandsProtocol", targets: ["IdleHandsProtocol"]),
        .library(name: "IdleHandsKit", targets: ["IdleHandsKit"]),
        .library(name: "IdleHandsChatUI", targets: ["IdleHandsChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "IdleHandsProtocol",
            path: "Sources/IdleHandsProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "IdleHandsKit",
            dependencies: [
                "IdleHandsProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/IdleHandsKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "IdleHandsChatUI",
            dependencies: [
                "IdleHandsKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/IdleHandsChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "IdleHandsKitTests",
            dependencies: ["IdleHandsKit", "IdleHandsChatUI"],
            path: "Tests/IdleHandsKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
