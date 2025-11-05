// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClipboardManager",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12)
    ],
    targets: [
        .executableTarget(
            name: "ClipboardManager",
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "ClipboardManagerTests",
            dependencies: ["ClipboardManager"]
        )
    ]
)
