import Foundation
import OAuthSwift
import ReactiveCocoa
import ReactiveSwift
import WebKit

public protocol OAuthProtocol
{
    var configuration: OAuth.Configuration { get }

    /// Starts authorisation with the specified webview.

    func authorise(webView: WKWebView)

    /// Cancels started authorisation.

    func cancel()
}

open class OAuth: NSObject, OAuthProtocol
{
    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public let configuration: Configuration

    // Signals authorisation success and error events.

    fileprivate let pipe = Signal<Credential, Error>.pipe()

    private var oauth: OAuth2Swift?

    // MARK: -

    public func authorise(webView: WKWebView) {
        guard self.oauth == nil else { return }

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
            state: configuration.state ?? NSUUID().uuidString,
            parameters: configuration.parameters ?? [:],
            completionHandler: { [weak self] result in
                switch result {
                    case .success(let credential, _, _):
                        self?.pipe.input.send(value: Credential(credential: credential))
                        self?.oauth = nil
                    case .failure(let error):
                        self?.pipe.input.send(error: Error.unknown(description: error.description))
                        self?.oauth = nil
                }
            }
        )

        self.oauth = oauth
    }

    public func cancel() {
        self.oauth?.cancel()
        self.oauth = nil
    }
}

extension Reactive where Base: OAuth
{
    public var authorised: Signal<Credential, Error> {
        return self.base.pipe.output
    }
}

// MARK: -

extension OAuth
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

extension OAuth
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