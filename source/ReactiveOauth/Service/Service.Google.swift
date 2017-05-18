open class Google: Service
{
    
    /*
    Todo: this is wrong, this should not have anything to do with drive api. If this gets changed to standard about
    */
    override open class var url: Url {
        return Url(
            authorise: "https://accounts.google.com/o/oauth2/auth",
            token: "https://accounts.google.com/o/oauth2/token",
            detail: "https://www.googleapis.com/oauth2/v1/tokeninfo"
        )
    }

    override open class func configure(access: Access, url: String, type: String? = nil, scope: String? = nil, state: String? = nil, parameters: [String: Any]? = nil) -> Oauth.Configuration {
        return super.configure(access: access, url: url, type: type ?? "code", scope: scope, state: state, parameters: parameters)
    }
}