import Foundation
import ReactiveOAuth
import WebKit

internal class GoogleAuthTestCase: AuthTestCase {
    internal func testOAuth() {
        self.testOAuth(type: .google, delegate: OAuthWebViewDelegate.self)
    }

    internal func testReoauth() {
        self.testReoauth(type: .google)
    }
}

private class OAuthWebViewDelegate: AbstractOAuthWebViewDelegate {
    override internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        super.webView(webView, didFinish: navigation)
        guard let path: String = webView.url?.path else { return }

        let file: String

        if path == "/ServiceLogin" || path == "/AccountLoginInfo" || path == "/signin/v1/lookup" {
            file = "google-signin.js"
        } else if path == "/o/oauth2/auth" {
            file = "google-authorise.js"
        } else {
            return
        }

        let url: URL = PathUtility.oauthURL(file: file)
        let script: String = self.authorise(script: try! NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String)

        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}
