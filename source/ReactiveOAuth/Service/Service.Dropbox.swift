open class Dropbox: Service {
    override open class var url: Url {
        return Url(
            authorise: "https://www.dropbox.com/oauth2/authorize",
            token: "https://api.dropbox.com/oauth2/token",
            detail: "https://api.dropbox.com/2/users/get_current_account"
        )
    }

    override open class func configure(access: Access, url: String, type: String? = nil, scope: String? = nil, state: String? = nil, parameters: [String: Any]? = nil) -> OAuth.Configuration {
        return super.configure(access: access, url: url, type: type ?? "token", scope: scope, state: state, parameters: parameters)
    }
}
