import Foundation

open class Service {
    open class var url: URL {
        abort()
    }

    open class func configure(access: Access, url: String, type: String? = nil, scope: String? = nil, state: String? = nil, parameters: [String: Any]? = nil) -> OAuth.Configuration {
        OAuth.Configuration(access: access, url: OAuth.URL(url: self.url, callback: url), type: type, scope: scope, state: state, parameters: parameters)
    }

    open class func configure(access: Access, token: String) -> Reoauth.Configuration {
        Reoauth.Configuration(access: access, url: Reoauth.URL(url: self.url), token: token)
    }
}

// MARK: -

extension Service {
    public struct URL {
        public let authorise: String
        public let token: String
        public let detail: String

        public init(authorise: String, token: String, detail: String) {
            self.authorise = authorise
            self.token = token
            self.detail = detail
        }
    }
}

// MARK: -

extension OAuth.URL {
    public init(url: Service.URL, callback: String) {
        self.init(authorise: url.authorise, token: url.token, callback: callback)
    }
}

extension Reoauth.URL {
    public init(url: Service.URL) {
        self.init(token: url.token)
    }
}
