import Foundation

internal class PathUtility {
    private static let path: [String: String] = Bundle(for: PathUtility.self).object(forInfoDictionaryKey: "Path") as! [String: String]

    // MARK: -

    internal static var testURL: URL {
        URL(fileURLWithPath: self.path["Root"]!, isDirectory: true).appendingPathComponent("test", isDirectory: true)
    }

    internal static func testURL(directory: String? = nil, file: String? = nil) -> URL {
        var url: URL = self.testURL
        if let component: String = directory { url.appendPathComponent(component, isDirectory: true) }
        if let component: String = file { url.appendPathComponent(component, isDirectory: false) }
        return url
    }

    // MARK: -

    internal static var oauthURL: URL {
        self.testURL(file: "oauth.json")
    }

    internal static func oauthURL(file: String) -> URL {
        self.testURL(directory: "oauth", file: file)
    }
}
