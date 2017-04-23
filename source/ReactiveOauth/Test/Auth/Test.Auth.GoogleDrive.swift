import Foundation
import ReactiveOauth
import WebKit

internal class AuthGoogleDriveTestCase: AuthTestCase
{
    internal func testOauth() {
        self.testOauth(type: .googleDrive, delegate: OauthWebViewDelegate.self)
    }

    internal func testReoauth() {
        self.testReoauth(type: .googleDrive)
    }
}

private class OauthWebViewDelegate: AbstractOauthWebViewDelegate
{
    override internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        super.webView(webView, didFinish: navigation)
        guard let path: String = webView.url?.path else { return }

        let file: String

        if path == "/ServiceLogin" || path == "/AccountLoginInfo" || path == "/signin/v1/lookup" {
            file = "google-drive-signin.js"
        } else if path == "/o/oauth2/auth" {
            file = "google-drive-authorise.js"
        } else {
            return
        }

        let url: URL = PathUtility.oauth(file: file)
        let script: String = self.authorise(script: try! NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String)

        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}