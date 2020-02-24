/*
Access key and secret pair.
*/
public struct Access {
    public var key: String
    public var secret: String

    public init(key: String, secret: String) {
        self.key = key
        self.secret = secret
    }
}
