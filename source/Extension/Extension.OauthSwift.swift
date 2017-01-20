import OAuthSwift

extension OAuth2Swift
{
    internal convenience init(consumerKey: String, consumerSecret: String, authorizeUrl: String, accessTokenUrl: String, responseType: String, urlHandler: OAuthSwiftURLHandlerType) {
        self.init(consumerKey: consumerKey, consumerSecret: consumerSecret, authorizeUrl: authorizeUrl, accessTokenUrl: accessTokenUrl, responseType: responseType)
        self.authorizeURLHandler = urlHandler
    }
}