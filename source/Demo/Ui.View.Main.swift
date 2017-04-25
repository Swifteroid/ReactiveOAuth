import AppKit
import Foundation
import ReactiveOauth
import ReactiveSwift

internal class MainViewController: NSViewController
{
    @IBAction private func handleOauthButtonAction(_ button: NSButton) {
        let storyboard: NSStoryboard = NSStoryboard(name: "main", bundle: Bundle.main)
        let controller: OauthViewController = storyboard.instantiateController(withIdentifier: "OauthViewController") as! OauthViewController
        let configuration: Oauth.Configuration = Dropbox.configure(access: Access(key: "foo", secret: "bar"), url: "https://baz.com/quz")
        let detalisator: Detalisator<String> = DropboxDetalisator()
        let oauth: DetailedOauth<String> = DetailedOauth(oauth: Oauth(configuration: configuration), detalisator: detalisator)

        oauth.reactive.authorised.observe(Observer(
            value: { (credential: Credential, string: String) in
                Swift.print(credential, string)
            },
            failed: { (error: ReactiveOauth.Error) in
                Swift.print(error.description)
            }
        ))

        self.authorise(oauthViewController: controller, oauth: oauth)
    }
}