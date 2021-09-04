import Foundation
import ReactiveSwift
import WebKit

public protocol DetailedAuthReactiveExtensionsProvider {
    associatedtype DetailType
}

/// - todo: Review in Swift 4 to inherit from NSObject to enable ReactiveCocoa extensions…

open class DetailedAuth<Detail>: DetailedAuthReactiveExtensionsProvider {
    public typealias DetailType = Detail

    public let detalisator: Detalisator<Detail>

    public init(detalisator: Detalisator<Detail>) {
        self.detalisator = detalisator
    }

    // MARK: -

    internal let pipe = Signal<(Credential, Detail), Error>.pipe()
}

// MARK: -

public struct DetailedAuthURL {
    public let detail: String
    public init(detail: String) {
        self.detail = detail
    }
}

// MARK: -

extension DetailedAuthReactiveExtensionsProvider {
    public var reactive: DetailedAuthReactive<Self, DetailType> {
        DetailedAuthReactive(self)
    }
}

public struct DetailedAuthReactive<Base, Detail> {
    public let base: Base

    fileprivate init(_ base: Base) {
        self.base = base
    }
}
