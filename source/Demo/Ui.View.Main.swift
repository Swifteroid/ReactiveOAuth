import AppKit
import Foundation
import ReactiveOauth
import ReactiveSwift
import SwiftyJSON

internal class MainViewController: NSViewController, Oauthorisable
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

    @IBAction private func handleOauthButtonAction(_ button: NSButton) {
        let access: Access = Access(key: self.accessKey.stringValue, secret: self.accessSecret.stringValue)
        let oauth: DetailedOauth<Email> = OauthFactory(type: self.type, access: access, url: self.url.stringValue).construct()!

        let storyboard: NSStoryboard = NSStoryboard(name: "main", bundle: Bundle.main)
        let controller: OauthViewController = storyboard.instantiateController(withIdentifier: "OauthViewController") as! OauthViewController

        oauth.reactive.authorised.observe(Signal.Observer(
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