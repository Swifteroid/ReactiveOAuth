import Foundation
import ReactiveCocoa
import ReactiveSwift
import WebKit

open class DetailedOauth<Detail>: DetailedAuth<Detail>, OauthProtocol
{
    open var configuration: Oauth.Configuration {
        return self.oauth.configuration
    }

    // MARK: -

    open let oauth: Oauth

    public init(oauth: Oauth, detalisator: Detalisator<Detail>) {
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

extension DetailedAuthReactive where Base: DetailedOauth<Detail>
{
    public var authorised: Signal<(Credential, Detail), Error> {
        return self.base.pipe.output
    }
}