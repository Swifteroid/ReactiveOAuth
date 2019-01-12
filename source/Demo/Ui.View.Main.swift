import AppKit
import Foundation
import ReactiveOAuth
import ReactiveSwift
import SwiftyJSON

internal class MainViewController: NSViewController, OAuthorisable
{
    @IBOutlet private weak var service: NSPopUpButton!
    @IBOutlet private weak var accessKey: NSTextField!
    @IBOutlet private weak var accessSecret: NSTextField!
    @IBOutlet private weak var url: NSTextField!

    /// Returns auth type enum for currently selected service.

    private var type: AuthType {
        return AuthType(rawValue: self.service.selectedItem!.title)!
    }

    /// Returns configuration from `oauth.json` for currently selected service.

    private var configuration: ConfigurationUtility.Configuration? {
        return ConfigurationUtility.configuration(for: self.type)
    }

    /// Update values from configuration.

    private func update() {
        let configuration = self.configuration
        self.accessKey.stringValue = configuration?.access.key ?? ""
        self.accessSecret.stringValue = configuration?.access.secret ?? ""
        self.url.stringValue = configuration?.url ?? ""
    }

    override func viewDidLoad() {
        self.service.addItems(withTitles: AuthType.all.map({ $0.rawValue }))
        self.update()
    }

    @IBAction private func handleServicePopUpButtonAction(_ button: NSPopUpButton) {
        self.update()
    }

    @IBAction private func handleOAuthButtonAction(_ button: NSButton) {
        let access: Access = Access(key: self.accessKey.stringValue, secret: self.accessSecret.stringValue)
        let oauth: DetailedOAuth<Email> = OAuthFactory(type: self.type, access: access, url: self.url.stringValue).construct()!

        let storyboard: NSStoryboard = NSStoryboard(name: "main", bundle: Bundle.main)
        let controller: OAuthViewController = storyboard.instantiateController(withIdentifier: "OAuthViewController") as! OAuthViewController

        oauth.reactive.authorised.observe(Signal.Observer(
            value: { (credential: Credential, string: String) in
                Swift.print(credential, string)
            },
            failed: { (error: ReactiveOAuth.Error) in
                Swift.print(error.description)
            }
        ))

        self.authorise(oauthViewController: controller, oauth: oauth)
    }
}
