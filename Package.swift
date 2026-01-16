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
            url: "https://github.com/DuckDuckGo/GRDB.swift/releases/download/1.0.0/GRDB.xcframework.zip",
            checksum: "44057ced07c98d5b82b198f7d05e7f31825c0ea511cc1a1c4802ca1d77a752ce"
        ),
        .target(name: "_GRDBDummy")
    ]
)
