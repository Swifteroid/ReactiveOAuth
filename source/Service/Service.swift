import Foundation

open class Service
{
    open class var url: Url {
        abort()
    }

    open class func configure(access: Access, url: String, type: String? = nil, scope: String? = nil, state: String? = nil, parameters: [String: Any]? = nil) -> Oauth.Configuration {
        return Oauth.Configuration(access: access, url: Oauth.Url(url: self.url, callback: url), type: type, scope: scope, state: state, parameters: parameters)
    }

    open class func configure(access: Access, token: String) -> Reoauth.Configuration {
        return Reoauth.Configuration(access: access, url: Reoauth.Url(url: self.url), token: token)
    }
}

// MARK: -

extension Service
{
    public struct Url
    {
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

extension Oauth.Url
{
    public init(url: Service.Url, callback: String) {
        self.init(authorise: url.authorise, token: url.token, callback: callback)
    }
}

extension Reoauth.Url
{
    public init(url: Service.Url) {
        self.init(token: url.token)
    }
}