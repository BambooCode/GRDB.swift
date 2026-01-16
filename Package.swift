// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GRDB",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "GRDB", targets: ["GRDB", "_GRDBDummy"]),
    ],
    targets: [
        .binaryTarget(
            name: "GRDB",
            url: "https://github.com/DuckDuckGo/GRDB.swift/releases/download/0.3.2-sqlcipher/GRDB.xcframework.zip",
            checksum: "b87629ae63002ba9574e8a4bd0e9f04da6ab90eb86cf3184b0e90e2d79857653"
        ),
        .target(name: "_GRDBDummy")
    ]
)
