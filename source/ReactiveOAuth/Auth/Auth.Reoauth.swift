import Alamofire
import ReactiveSwift
import SwiftyJSON

public protocol ReoauthProtocol {
    func reauthorise()
}

open class Reoauth: ReoauthProtocol, ReactiveExtensionsProvider {
    public let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    // MARK: -

    fileprivate let pipe = Signal<Credential, Error>.pipe()

    // MARK: -

    open func reauthorise() {
        let token: String = self.configuration.token

        let parameters: Alamofire.Parameters = [
            "client_id": self.configuration.access.key,
            "client_secret": self.configuration.access.secret,
            "refresh_token": token,
            "grant_type": "refresh_token",]

        AF.request(self.configuration.url.token, method: HTTPMethod.post, parameters: parameters).reactive.responded
            .attemptMap({ try JSON(data: $0) })
            .mapError({ Error.request(description: $0.localizedDescription) })
            .attemptMap({
                if let accessToken: String = $0["access_token"].string, let expiresIn: Double = $0["expires_in"].double {
                    return .success(Credential(accessToken: accessToken, refreshToken: token, expireDate: Date(timeInterval: expiresIn, since: Date())))
                } else {
                    return .failure(Error.response(description: "Could not retrieve access token and / or expire details from response."))
                }
            })
            .observe(self.pipe.input)
    }
}

extension Reactive where Base: Reoauth {
    public var reauthorised: Signal<Credential, Error> {
        self.base.pipe.output
    }
}

// MARK: -

extension Reoauth {
    public struct Configuration {
        public let access: Access
        public let url: Url
        public let token: String

        public init(access: Access, url: Url, token: String) {
            self.access = access
            self.url = url
            self.token = token
        }
    }

    public struct Url {
        public let token: String
        public init(token: String) {
            self.token = token
        }
    }
}
