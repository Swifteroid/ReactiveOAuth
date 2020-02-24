import Foundation

internal class PathUtility {
    private static let path: [String: String] = Bundle(for: PathUtility.self).object(forInfoDictionaryKey: "Path") as! [String: String]

    // MARK: -

    internal static var testUrl: URL {
        return URL(fileURLWithPath: self.path["Root"]!, isDirectory: true).appendingPathComponent("test", isDirectory: true)
    }

    internal static func testUrl(directory: String? = nil, file: String? = nil) -> URL {
        var url: URL = self.testUrl
        if let component: String = directory { url.appendPathComponent(component, isDirectory: true) }
        if let component: String = file { url.appendPathComponent(component, isDirectory: false) }
        return url
    }

    // MARK: -

    internal static var oauth: URL {
        return self.testUrl(file: "oauth.json")
    }

    internal static func oauth(file: String) -> URL {
        return self.testUrl(directory: "oauth", file: file)
    }
}
