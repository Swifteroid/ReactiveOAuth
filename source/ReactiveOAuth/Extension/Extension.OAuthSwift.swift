import OAuthSwift

extension OAuth2Swift {
    internal convenience init(consumerKey: String, consumerSecret: String, authorizeURL: String, accessTokenURL: String, responseType: String, urlHandler: OAuthSwiftURLHandlerType) {
        self.init(consumerKey: consumerKey, consumerSecret: consumerSecret, authorizeUrl: authorizeURL, accessTokenUrl: accessTokenURL, responseType: responseType)
        self.authorizeURLHandler = urlHandler
    }
}
