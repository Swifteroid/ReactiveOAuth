import ReactiveSwift
import SwiftyJSON

public protocol DetalisatorProtocol {
    associatedtype DetailType = Any

    func detail(credential: Credential)
}

open class Detalisator<Detail>: DetalisatorProtocol {
    public typealias DetailType = Detail

    public init() {
    }

    // MARK: -

    fileprivate let pipe = Signal<Detail, Error>.pipe()

    open func detail(credential: Credential) {
        abort()
    }

    open func fail(_ error: Error) {
        self.pipe.input.send(error: error)
    }

    open func succeed(_ value: Detail) {
        self.pipe.input.send(value: value)
    }
}

open class JsonDetalisator<Detail>: Detalisator<Detail> {
    open func detail(json: JSON) {
        abort()
    }
}

// MARK: -

extension DetalisatorProtocol {
    public var reactive: DetalisatorReactive<Self, DetailType> {
        return DetalisatorReactive(self)
    }
}

public struct DetalisatorReactive<Base, Detail> {
    public let base: Base

    fileprivate init(_ base: Base) {
        self.base = base
    }
}

extension DetalisatorReactive where Base: Detalisator<Detail> {
    public var detailed: Signal<Detail, Error> {
        return self.base.pipe.output
    }
}
