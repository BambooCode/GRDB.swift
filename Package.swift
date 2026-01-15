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
        .library(name: "SQLCipher", targets: ["SQLCipher"])
    ],
    targets: [
        .binaryTarget(
            name: "GRDB",
            url: "https://github.com/DuckDuckGo/GRDB.swift/releases/download/3.0.0/GRDB.xcframework.zip",
            checksum: "41f01022f6a35986393e063e1ef386fd896646ed032f7d0419c4b02fa3afe61d"
        ),
        .target(name: "_GRDBDummy"),
        .target(name: "SQLCipher")
    ]
)
