import Foundation
import ReactiveOauth
import WebKit

internal class ImgurAuthTestCase: AuthTestCase
{
    internal func testOauth() {
        self.testOauth(type: .imgur, delegate: OauthWebViewDelegate.self)
    }

    internal func testReoauth() {
        self.testReoauth(type: .imgur)
    }
}

private class OauthWebViewDelegate: AbstractOauthWebViewDelegate
{
    override internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        super.webView(webView, didFinish: navigation)
        guard let path: String = webView.url?.path else { return }
        
        let file: String

        if path == "/oauth2/authorize" {
            file = "imgur-authorise.js"
        } else {
            return
        }

        let url: URL = PathUtility.oauth(file: file)
        let script: String = self.authorise(script: try! NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue) as String)

        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}