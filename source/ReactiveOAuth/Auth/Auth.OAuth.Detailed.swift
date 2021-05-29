import Foundation
import ReactiveCocoa
import ReactiveSwift
import WebKit

open class DetailedOAuth<Detail>: DetailedAuth<Detail>, OAuthProtocol {
    open var configuration: OAuth.Configuration {
        self.oauth.configuration
    }

    // MARK: -

    public let oauth: OAuth

    public init(oauth: OAuth, detalisator: Detalisator<Detail>) {
        self.oauth = oauth
        super.init(detalisator: detalisator)
    }

    // MARK: -

    public func authorise(webView: WKWebView) {
        self.oauth.reactive.authorised.zip(with: self.detalisator.reactive.detailed).observe(self.pipe.input)
        self.oauth.reactive.authorised.observe(Signal.Observer(value: { [weak self] in self?.detalisator.detail(credential: $0) }))
        self.oauth.authorise(webView: webView)
    }

    public func cancel() {
        self.oauth.cancel()
    }
}

extension DetailedAuthReactive where Base: DetailedOAuth<Detail> {
    public var authorised: Signal<(Credential, Detail), Error> {
        self.base.pipe.output
    }
}
