// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sylex",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Sylex",
            targets: ["Sylex"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Pyroh/SmoothOperators.git", .upToNextMajor(from: "0.4.0")),
        .package(url: "https://github.com/Pyroh/ZeroableProtocol.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Pyroh/OptionalType.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Pyroh/SwizzleIMD.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Pyroh/CoreGeometry.git", .upToNextMajor(from: "6.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Sylex",
            dependencies: ["SmoothOperators", "ZeroableProtocol", "CoreGeometry", "OptionalType", "SwizzleIMD"]),
        .testTarget(
            name: "SylexTests",
            dependencies: ["Sylex"]),
    ]
)
