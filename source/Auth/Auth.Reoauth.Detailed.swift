import Foundation
import ReactiveSwift
import WebKit

open class DetailedReoauth<Detail>: DetailedAuth<Detail>, ReoauthProtocol
{
    open let reoauth: Reoauth

    public init(reoauth: Reoauth, detalisator: Detalisator<Detail>) {
        self.reoauth = reoauth
        super.init(detalisator: detalisator)
    }

    // MARK: -

    public func reauthorise() {
        self.reoauth.reactive.reauthorised.zip(with: self.detalisator.reactive.detailed).observe(self.pipe.input)
        self.reoauth.reactive.reauthorised.observe(Observer(value: { self.detalisator.detail(credential: $0) }))
        self.reoauth.reauthorise()
    }
}

extension DetailedAuthReactive where Base: DetailedReoauth<Detail>
{
    public var reauthorised: Signal<(Credential, Detail), Error> {
        return self.base.pipe.output
    }
}