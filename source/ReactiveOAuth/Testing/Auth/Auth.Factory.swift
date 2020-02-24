import ReactiveOAuth

internal class AuthFactory {
    internal var type: AuthType
    internal var access: Access
    internal var url: String

    internal init(type: AuthType, access: Access, url: String) {
        self.type = type
        self.access = access
        self.url = url
    }

    internal convenience init(type: AuthType, configuration: ConfigurationUtility.Configuration) {
        self.init(type: type, access: configuration.access, url: configuration.url)
    }
}

internal class OAuthFactory: AuthFactory {
    internal func construct() -> DetailedOAuth<Email>? {
        let configuration: OAuth.Configuration
        let parameters: [String: Any]
        let scope: String
        let detalisator: Detalisator<Email>

        if self.type == .dropbox {
            configuration = Dropbox.configure(access: self.access, url: self.url)
            detalisator = DropboxDetalisator()
        } else if self.type == .google {
            parameters = ["access_type": "offline", "approval_prompt": "force"]
            scope = "https://www.googleapis.com/auth/drive.file https://www.googleapis.com/auth/drive.metadata.readonly https://www.googleapis.com/auth/userinfo.email"
            configuration = Google.configure(access: self.access, url: self.url, scope: scope, parameters: parameters)
            detalisator = GoogleDetalisator()
        } else if self.type == .imgur {
            configuration = Imgur.configure(access: self.access, url: self.url)
            detalisator = ImgurDetalisator()
        } else {
            return nil
        }

        return DetailedOAuth(oauth: OAuth(configuration: configuration), detalisator: detalisator)
    }
}

internal class ReoauthFactory: AuthFactory {
    internal var token: String

    internal init(type: AuthType, access: Access, url: String, token: String) {
        self.token = token
        super.init(type: type, access: access, url: url)
    }

    internal convenience init(type: AuthType, configuration: ConfigurationUtility.Configuration, token: String) {
        self.init(type: type, access: configuration.access, url: configuration.url, token: token)
    }

    internal func construct() -> DetailedReoauth<Email>? {
        let configuration: Reoauth.Configuration
        let detalisator: Detalisator<Email>

        if self.type == .dropbox {
            configuration = Dropbox.configure(access: self.access, token: self.token)
            detalisator = DropboxDetalisator()
        } else if self.type == .google {
            configuration = Google.configure(access: self.access, token: self.token)
            detalisator = GoogleDetalisator()
        } else if self.type == .imgur {
            configuration = Imgur.configure(access: self.access, token: self.token)
            detalisator = ImgurDetalisator()
        } else {
            return nil
        }

        return DetailedReoauth(reoauth: Reoauth(configuration: configuration), detalisator: detalisator)
    }
}
