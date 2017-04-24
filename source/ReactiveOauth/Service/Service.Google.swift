open class Google: Service
{
    override open class var url: Url {
        return Url(
            authorise: "https://accounts.google.com/o/oauth2/auth",
            token: "https://accounts.google.com/o/oauth2/token",
            detail: "https://www.googleapis.com/drive/v3/about"
        )
    }

    override open class func configure(access: Access, url: String, type: String? = nil, scope: String? = nil, state: String? = nil, parameters: [String: Any]? = nil) -> Oauth.Configuration {
        return super.configure(access: access, url: url, type: type ?? "code", scope: scope, state: state, parameters: parameters)
    }
}