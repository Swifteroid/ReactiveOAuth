import AppKit
import Foundation
import ReactiveOauth
import ReactiveSwift
import SwiftyJSON

internal class MainViewController: NSViewController
{
    @IBOutlet private weak var accessKey: NSTextField!
    @IBOutlet private weak var accessSecret: NSTextField!
    @IBOutlet private weak var redirectUrl: NSTextField!

    @IBAction private func handleOauthButtonAction(_ button: NSButton) {
        let storyboard: NSStoryboard = NSStoryboard(name: "main", bundle: Bundle.main)
        let controller: OauthViewController = storyboard.instantiateController(withIdentifier: "OauthViewController") as! OauthViewController
        let access: Access = Access(key: self.accessKey.stringValue, secret: self.accessSecret.stringValue)
        let configuration: Oauth.Configuration = Imgur.configure(access: access, url: self.redirectUrl.stringValue)
        let detalisator: Detalisator<String> = ImgurDetalisator()
        let oauth: DetailedOauth<String> = DetailedOauth(oauth: Oauth(configuration: configuration), detalisator: detalisator)

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

private class ImgurDetalisator: ReactiveOauth.ImgurDetalisator<String>
{
    override internal func detail(json: JSON) {
        self.succeed(json["data"]["email"].stringValue)
    }
}