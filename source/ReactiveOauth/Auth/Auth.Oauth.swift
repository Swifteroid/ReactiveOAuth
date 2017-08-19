import Foundation
import OAuthSwift
import ReactiveSwift
import WebKit

public protocol OauthProtocol
{
    var configuration: Oauth.Configuration { get }
    func authorise(webView: WKWebView)
}

open class Oauth: OauthProtocol, ReactiveExtensionsProvider
{
    open let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    // MARK: -

    fileprivate typealias Pipe = (output: Signal<Credential, Error>, input: Observer<Credential, Error>)
    fileprivate let pipe: Pipe = Signal<Credential, Error>.pipe()

    private var oauth: OAuth2Swift?

    // MARK: -

    public func authorise(webView: WKWebView) {
        let oauth: OAuth2Swift = OAuth2Swift(
            consumerKey: configuration.access.key,
            consumerSecret: configuration.access.secret,
            authorizeUrl: configuration.url.authorise,
            accessTokenUrl: configuration.url.token,
            responseType: configuration.type ?? "token",
            urlHandler: UrlHandler(webView: webView)
        )

        oauth.encodeCallbackURL = true
        oauth.encodeCallbackURLQuery = false

        oauth.authorize(
            withCallbackURL: URL(string: configuration.url.callback)!,
            scope: configuration.scope ?? "",
            state: configuration.state ?? "default",
            parameters: configuration.parameters ?? [:],
            success: { [weak self] (credential: OAuthSwiftCredential, _, _) in self?.pipe.input.send(value: Credential(credential: credential)) },
            failure: { [weak self] (error: OAuthSwiftError) in self?.pipe.input.send(error: Error.unknown(description: error.description)) }
        )

        // Todo: shouldn't we unreference it once finished or use some smarter capturing withing the closure?

        self.oauth = oauth
    }
}

extension Reactive where Base: Oauth
{
    public var authorised: Signal<Credential, Error> {
        return self.base.pipe.output
    }
}

// MARK: -

extension Oauth
{
    open class Configuration
    {
        public let access: Access
        public let url: Url
        public let type: String?
        public let scope: String?
        public let state: String?
        public let parameters: [String: Any]?

        public init(access: Access, url: Url, type: String? = nil, scope: String? = nil, state: String? = nil, parameters: [String: Any]? = nil) {
            self.access = access
            self.url = url
            self.type = type
            self.scope = scope
            self.state = state
            self.parameters = parameters
        }
    }

    public struct Url
    {
        public let authorise: String
        public let token: String
        public let callback: String

        public init(authorise: String, token: String, callback: String) {
            self.authorise = authorise
            self.token = token
            self.callback = callback
        }
    }
}

// MARK: -

extension Oauth
{
    open class UrlHandler: OAuthSwiftURLHandlerType
    {
        open weak var webView: WKWebView?

        public init(webView: WKWebView) {
            self.webView = webView
        }

        open func handle(_ url: URL) {
            _ = self.webView?.load(URLRequest(url: url))
        }
    }
}