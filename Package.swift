// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClipboardManager",
    platforms: [
        .macOS(.v12)
    ],
    targets: [
        .executableTarget(
            name: "ClipboardManager"),
        .testTarget(
            name: "ClipboardManagerTests",
            dependencies: ["ClipboardManager"]
        )
    ]
)
