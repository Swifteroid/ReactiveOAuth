// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ReactiveOAuth",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "ReactiveOAuth", targets: ["ReactiveOAuth"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
        .package(url: "https://github.com/OAuthSwift/OAuthSwift.git", from: "2.0.0"),
        .package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa.git", from: "12.0.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
        .package(url: "https://github.com/vadymmarkov/Fakery.git", from: "5.0.0"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", from: "9.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "11.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "ReactiveOAuth",
            dependencies: [
                "Alamofire",
                "OAuthSwift",
                "ReactiveCocoa",
                "SwiftyJSON",
            ],
            path: "source/ReactiveOAuth",
            exclude: ["Test", "Testing"]),
        .testTarget(
            name: "ReactiveOAuth-Test",
            dependencies: [
                "Fakery",
                "Nimble",
                "OHHTTPStubs",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
                "Quick",
                "ReactiveOAuth",
            ],
            path: "source/ReactiveOAuth",
            exclude: ["Auth", "Detalisator", "Extension", "Service", "UI"]),
    ],
    swiftLanguageVersions: [.v5]
)
