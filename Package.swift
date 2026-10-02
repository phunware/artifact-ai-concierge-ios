// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PhunwareAIConcierge",
    platforms: [
        .iOS("15.5")
    ],
    products: [
        // Only expose these to clients
        .library(
            name: "PhunwareAIConcierge",
            targets: ["PhunwareAIConciergeTargets"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/phunware/artifact-foundation-ios.git",
            branch: "release/1.1.0"
        ),
        .package(
            url: "https://github.com/phunware/artifact-theming-ios.git",
            branch: "release/1.1.2"
        ),
        .package(
            url: "https://github.com/phunware/artifact-permissions-ios.git",
            branch: "release/1.5.3"
        ),
        .package(
            url: "https://github.com/phunware/artifact-core-plugin-ios.git",
            branch: "release/1.2.0"
        )
    ],
    targets: [
        // Internal frameworks
        .binaryTarget(
            name: "PhunwareAIConcierge",
            path: "FrameworksStaticLinks/PhunwareAIConcierge.xcframework"
        ),
        .target(name: "PhunwareAIConciergeTargets",
            dependencies:[
                .target(name: "PhunwareAIConcierge"),
                .product(name: "PhunwareFoundation", package: "artifact-foundation-ios"),
                .product(name: "PhunwareTheming", package: "artifact-theming-ios"),
                .product(name: "PhunwareCorePlugin", package: "artifact-core-plugin-ios"),
                .product(name: "PhunwareMicrophonePermission", package: "artifact-permissions-ios"),
                .product(name: "PhunwareSpeechRecognizerPermission", package: "artifact-permissions-ios")
            ],
            path: "PhunwareAIConciergeTargets"
        )
    ]
)
