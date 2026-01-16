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
            url: "https://github.com/DuckDuckGo/GRDB.swift/releases/download/0.3.3-sqlcipher/GRDB.xcframework.zip",
            checksum: "5a7156c3eda1226d56cdd011dfedb99e751d475c55def1dd383875c22453de3f"
        ),
        .target(name: "_GRDBDummy")
    ]
)
