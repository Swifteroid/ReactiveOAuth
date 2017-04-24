import ReactiveOauth

internal class AuthFactory
{
    internal var type: AuthType
    internal var configuration: ConfigurationUtility.Configuration

    internal init(type: AuthType, configuration: ConfigurationUtility.Configuration) {
        self.type = type
        self.configuration = configuration
    }
}

internal class OauthFactory: AuthFactory
{
    internal func construct() -> DetailedOauth<Email>? {
        let configuration: Oauth.Configuration
        let parameters: [String: Any]
        let scope: String
        let detalisator: Detalisator<Email>

        if self.type == .dropbox {
            configuration = Dropbox.configure(access: self.configuration.access, url: self.configuration.url)
            detalisator = DropboxDetalisator()
        } else if self.type == .googleDrive {
            parameters = ["access_type": "offline", "approval_prompt": "force"]
            scope = "https://www.googleapis.com/auth/drive.file https://www.googleapis.com/auth/drive.metadata.readonly"
            configuration = GoogleDrive.configure(access: self.configuration.access, url: self.configuration.url, scope: scope, parameters: parameters)
            detalisator = GoogleDriveDetalisator()
        } else if self.type == .imgur {
            configuration = Imgur.configure(access: self.configuration.access, url: self.configuration.url)
            detalisator = ImgurDetalisator()
        } else {
            return nil
        }

        return DetailedOauth(oauth: Oauth(configuration: configuration), detalisator: detalisator)
    }
}

internal class ReoauthFactory: AuthFactory
{
    internal var token: String

    internal init(type: AuthType, configuration: ConfigurationUtility.Configuration, token: String) {
        self.token = token
        super.init(type: type, configuration: configuration)
    }

    internal func construct() -> DetailedReoauth<Email>? {
        let configuration: Reoauth.Configuration
        let detalisator: Detalisator<Email>

        if self.type == .dropbox {
            configuration = Dropbox.configure(access: self.configuration.access, token: self.token)
            detalisator = DropboxDetalisator()
        } else if self.type == .googleDrive {
            configuration = GoogleDrive.configure(access: self.configuration.access, token: self.token)
            detalisator = GoogleDriveDetalisator()
        } else if self.type == .imgur {
            configuration = Imgur.configure(access: self.configuration.access, token: self.token)
            detalisator = ImgurDetalisator()
        } else {
            return nil
        }

        return DetailedReoauth(reoauth: Reoauth(configuration: configuration), detalisator: detalisator)
    }
}