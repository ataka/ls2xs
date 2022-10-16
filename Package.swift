// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ls2xs",
    products: [
        .executable(name: "ls2xs", targets: ["ls2xs"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "ls2xs",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "ls2xsTests",
            dependencies: ["ls2xs"]),
    ]
)

// Local Variables:
// swift-mode:parenthesized-expression-offset: 4
// End:
