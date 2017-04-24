import Foundation
import ReactiveOauth
import WebKit

internal class DropboxAuthTestCase: AuthTestCase
{
    internal func testOauth() {
        self.testOauth(type: .dropbox, delegate: OauthWebViewDelegate.self)
    }
}

private class OauthWebViewDelegate: AbstractOauthWebViewDelegate
{
    override internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        super.webView(webView, didFinish: navigation)
        guard let path: String = webView.url?.path, path == "/oauth2/authorize" else { return }

        let url: URL = PathUtility.oauth(file: "dropbox-authorise.js")
        let script: String = self.authorise(script: try! NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String)

        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}