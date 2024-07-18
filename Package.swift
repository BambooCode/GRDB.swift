// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

var swiftSettings: [SwiftSetting] = [
    .define("SQLITE_ENABLE_FTS5"),
]
var cSettings: [CSetting] = []
var dependencies: [PackageDescription.Package.Dependency] = []

// For Swift 5.8+
//swiftSettings.append(.enableUpcomingFeature("ExistentialAny"))

// Don't rely on those environment variables. They are ONLY testing conveniences:
// $ SQLITE_ENABLE_PREUPDATE_HOOK=1 make test_SPM
if ProcessInfo.processInfo.environment["SQLITE_ENABLE_PREUPDATE_HOOK"] == "1" {
    swiftSettings.append(.define("SQLITE_ENABLE_PREUPDATE_HOOK"))
    cSettings.append(.define("GRDB_SQLITE_ENABLE_PREUPDATE_HOOK"))
}

swiftSettings.append(contentsOf: [
    .define("SQLITE_HAS_CODEC"),
    .define("GRDBCIPHER"),
    .define("SQLITE_ENABLE_FTS5")
])

cSettings.append(contentsOf: [
    .define("SQLITE_HAS_CODEC"),
    .define("SQLITE_TEMP_STORE", to: "2"),
    .define("SQLITE_SOUNDEX"),
    .define("SQLITE_THREADSAFE"),
    .define("SQLITE_ENABLE_RTREE"),
    .define("SQLITE_ENABLE_STAT3"),
    .define("SQLITE_ENABLE_STAT4"),
    .define("SQLITE_ENABLE_COLUMN_METADATA"),
    .define("SQLITE_ENABLE_MEMORY_MANAGEMENT"),
    .define("SQLITE_ENABLE_LOAD_EXTENSION"),
    .define("SQLITE_ENABLE_FTS4"),
    .define("SQLITE_ENABLE_FTS4_UNICODE61"),
    .define("SQLITE_ENABLE_FTS3_PARENTHESIS"),
    .define("SQLITE_ENABLE_UNLOCK_NOTIFY"),
    .define("SQLITE_ENABLE_JSON1"),
    .define("SQLITE_ENABLE_FTS5"),
    .define("SQLCIPHER_CRYPTO_CC"),
    .define("HAVE_USLEEP", to: "1"),
    .define("SQLITE_MAX_VARIABLE_NUMBER", to: "99999")
])

let sqlCipherCSettings = cSettings + [
    .define("NDEBUG"),
    .define("HAVE_GETHOSTUUID", to: "0")
]

// The SPI_BUILDER environment variable enables documentation building
// on <https://swiftpackageindex.com/groue/GRDB.swift>. See
// <https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/issues/2122>
// for more information.
//
// SPI_BUILDER also enables the `make docs-localhost` command.
if ProcessInfo.processInfo.environment["SPI_BUILDER"] == "1" {
    dependencies.append(.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"))
}

let package = Package(
    name: "GRDB",
    defaultLocalization: "en", // for tests
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(name: "GRDB", targets: ["GRDB"]),
        .library(name: "SQLCipher", targets: ["SQLCipher"]),
        .library(name: "GRDB-dynamic", type: .dynamic, targets: ["GRDB"]),
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "GRDB",
            dependencies: ["SQLCipher"],
            path: "GRDB",
            resources: [.copy("PrivacyInfo.xcprivacy")],
            cSettings: cSettings,
            swiftSettings: swiftSettings),
        .target(
            name: "SQLCipher",
            cSettings: sqlCipherCSettings),
        .testTarget(
            name: "GRDBTests",
            dependencies: ["GRDB"],
            path: "Tests",
            exclude: [
                "CocoaPods",
                "Crash",
                "CustomSQLite",
                "GRDBTests/getThreadsCount.c",
                "Info.plist",
                "Performance",
                "SPM",
                "generatePerformanceReport.rb",
                "parsePerformanceTests.rb",
            ],
            resources: [
                .copy("GRDBTests/Betty.jpeg"),
                .copy("GRDBTests/InflectionsTests.json"),
                .copy("GRDBTests/Issue1383.sqlite"),
            ],
            cSettings: cSettings,
            swiftSettings: swiftSettings)
    ],
    swiftLanguageVersions: [.v5]
)
