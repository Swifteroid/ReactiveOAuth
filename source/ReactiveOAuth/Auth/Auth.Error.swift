public enum Error: Swift.Error, CustomStringConvertible {
    case request(description: String)
    case response(description: String)
    case unknown(description: String)

    // MARK: -

    public var description: String {
        switch self {
            case let .request(description): return description
            case let .response(description): return description
            case let .unknown(description): return description
        }
    }
}
