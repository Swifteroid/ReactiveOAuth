import ReactiveOAuth
import SwiftyJSON
import Foundation

internal class ConfigurationUtility {
    private static let json: JSON = JSON(rawValue: try! Data(contentsOf: PathUtility.oauth))!

    internal typealias Configuration = (access: Access, url: String, email: String, password: String)

    internal static func configuration(for type: AuthType) -> Configuration? {
        let json: JSON = self.json[type.rawValue]

        // Make sure we have everything we need in oauth.json for constructed service.

        guard let key: String = json["access"]["key"].string else { return nil }
        guard let secret: String = json["access"]["secret"].string else { return nil }
        guard let url: String = json["access"]["url"].string else { return nil }
        guard let email: String = json["credential"]["email"].string else { return nil }
        guard let password: String = json["credential"]["password"].string else { return nil }

        return (access: Access(key: key, secret: secret), url: url, email: email, password: password)
    }
}
