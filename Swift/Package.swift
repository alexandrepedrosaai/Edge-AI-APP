// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EdgeAiSwiftApp",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .executable(name: "EdgeAiSwiftApp", targets: ["EdgeAiSwiftApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "EdgeAiSwiftApp",
            dependencies: [],
            path: ".",
            sources: ["EdgeAiSwiftApp.swift"]
        )
    ]
)
