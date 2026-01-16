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
            url: "https://github.com/DuckDuckGo/GRDB.swift/releases/download/0.3.0-sqlcipher/GRDB.xcframework.zip",
            checksum: "7bd56f4bb22a39583a1e306016124ed435e46ee7857554d5b512614e1c4a2cfb"
        ),
        .target(name: "_GRDBDummy")
    ]
)
