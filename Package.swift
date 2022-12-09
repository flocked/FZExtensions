// swift-tools-version: 5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FZExtensions",
    platforms: [
        .macOS("10.15.1"), .iOS(.v13)
    ],
    products: [
        .library(
            name: "FZExtensions",
            targets: ["FZExtensions"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FZExtensions",
            dependencies: []),
        .testTarget(
            name: "FZExtensionsTests",
            dependencies: ["FZExtensions"]),
    ]
)
