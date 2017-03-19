import AppKit
import Foundation
import ReactiveOauth

internal class MainViewController: NSViewController
{
    override func viewDidAppear() {
        NSApplication.shared().activate(ignoringOtherApps: true)
    }

    @IBAction private func handleOauthButtonAction(_ button: NSButton) {
        let controller: OauthViewController = NSStoryboard(name: "main", bundle: Bundle.main).instantiateController(withIdentifier: "OauthViewController") as! OauthViewController
        let access: Access = Access(key: "foo", secret: "bar")
        let configuration: Oauth.Configuration = Dropbox.configure(access: access, url: "https://baz.com/quz")
        let detalisator: Detalisator<String> = DropboxDetalisator()
        let oauth: DetailedOauth<String> = DetailedOauth(oauth: Oauth(configuration: configuration), detalisator: detalisator)

        self.authorise(oauthViewController: controller, oauth: oauth)
    }
}