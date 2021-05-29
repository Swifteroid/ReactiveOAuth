open class Imgur: Service {
    override open class var url: Url {
        Url(
            authorise: "https://api.imgur.com/oauth2/authorize",
            token: "https://api.imgur.com/oauth2/token",
            detail: "https://api.imgur.com/3/account/me/settings"
        )
    }

    override open class func configure(access: Access, url: String, type: String? = nil, scope: String? = nil, state: String? = nil, parameters: [String: Any]? = nil) -> OAuth.Configuration {
        super.configure(access: access, url: url, type: type ?? "code", scope: scope, state: state, parameters: parameters)
    }
}
