// swift-tools-version: 6.2
// Package manifest for the IdleHands macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "IdleHands",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "IdleHandsIPC", targets: ["IdleHandsIPC"]),
        .library(name: "IdleHandsDiscovery", targets: ["IdleHandsDiscovery"]),
        .executable(name: "IdleHands", targets: ["IdleHands"]),
        .executable(name: "idlehands-mac", targets: ["IdleHandsMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/IdleHandsKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "IdleHandsIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "IdleHandsDiscovery",
            dependencies: [
                .product(name: "IdleHandsKit", package: "IdleHandsKit"),
            ],
            path: "Sources/IdleHandsDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "IdleHands",
            dependencies: [
                "IdleHandsIPC",
                "IdleHandsDiscovery",
                .product(name: "IdleHandsKit", package: "IdleHandsKit"),
                .product(name: "IdleHandsChatUI", package: "IdleHandsKit"),
                .product(name: "IdleHandsProtocol", package: "IdleHandsKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/IdleHands.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "IdleHandsMacCLI",
            dependencies: [
                "IdleHandsDiscovery",
                .product(name: "IdleHandsKit", package: "IdleHandsKit"),
                .product(name: "IdleHandsProtocol", package: "IdleHandsKit"),
            ],
            path: "Sources/IdleHandsMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "IdleHandsIPCTests",
            dependencies: [
                "IdleHandsIPC",
                "IdleHands",
                "IdleHandsDiscovery",
                .product(name: "IdleHandsProtocol", package: "IdleHandsKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
