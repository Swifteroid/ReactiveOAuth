// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ReactiveOAuth",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "ReactiveOAuth", targets: ["ReactiveOAuth"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.2.1"),
        .package(url: "https://github.com/OAuthSwift/OAuthSwift", from: "2.1.2"),
        .package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", from: "11.0.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON", from: "5.0.0"),
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.1.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "8.1.1"),
        .package(url: "https://github.com/soranoba/OHHTTPStubs", .branch("BUILD_LIBRARY_FOR_DISTRIBUTION")),
    ],
    targets: [
        .target(name: "ReactiveOAuth", dependencies: ["Alamofire", "OAuthSwift", "ReactiveCocoa", "SwiftyJSON"], path: "source/ReactiveOAuth", exclude: ["Test", "Testing"]),
        .testTarget(name: "ReactiveOAuth-Test", dependencies: ["ReactiveOAuth", "Alamofire", "OAuthSwift", "ReactiveCocoa", "SwiftyJSON", "Fakery", "Nimble", "OHHTTPStubs"], path: "source/ReactiveOAuth", sources: ["Test", "Testing"]),
    ],
    swiftLanguageVersions: [.v5]
)
