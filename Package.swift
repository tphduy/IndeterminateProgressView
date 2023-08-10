// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IndeterminateProgressView",
    platforms: [
        .iOS(.v15),
        .macCatalyst(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .visionOS(.v1),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "IndeterminateProgressView",
            targets: ["IndeterminateProgressView"]
        ),
    ],
    targets: [
        .target(name: "IndeterminateProgressView"),
        .testTarget(
            name: "IndeterminateProgressViewTests",
            dependencies: ["IndeterminateProgressView"]
        ),
    ]
)
