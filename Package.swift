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
            url: "https://github.com/DuckDuckGo/GRDB.swift/releases/download/0.3.1-sqlcipher/GRDB.xcframework.zip",
            checksum: "8457f04ae9c58c804dc1f42771d80eb3dbb85ece253492e9f7d67968350624b3"
        ),
        .target(name: "_GRDBDummy")
    ]
)
