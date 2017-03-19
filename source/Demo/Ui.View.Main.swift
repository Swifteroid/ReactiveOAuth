import AppKit
import Foundation
import ReactiveOauth

internal class MainViewController: NSViewController
{
    private lazy var oauth: DetailedOauth<String> = {
        let access: Access = Access(key: "foo", secret: "bar")
        let configuration: Oauth.Configuration = Dropbox.configure(access: access, url: "https://baz.com/quz")
        let detalisator: Detalisator<String> = DropboxDetalisator()
        return DetailedOauth(oauth: Oauth(configuration: configuration), detalisator: detalisator)
    }()

    override func viewDidAppear() {
        NSApplication.shared().activate(ignoringOtherApps: true)
    }

    @IBAction private func handleOauthButtonAction(_ button: NSButton) {
        let controller: OauthViewController = NSStoryboard(name: "main", bundle: Bundle.main).instantiateController(withIdentifier: "OauthViewController") as! OauthViewController
        authorise(hostViewController: self, oauthViewController: controller, oauth: self.oauth)
    }
}