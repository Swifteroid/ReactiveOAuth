import AppKit
import Foundation
import OAuthSwift
import WebKit

extension WKWebViewConfiguration
{
    public static var `default`: WKWebViewConfiguration {
        let configuration: WKWebViewConfiguration = WKWebViewConfiguration()

        if #available(OSX 10.11, *) {
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        }

        return configuration
    }
}

open class OauthWebView: WKWebView
{
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)

        self.allowsMagnification = false

        // Dropbox send a weird email saying the app has been authenticated from AppleMail, setting custom 
        // user agent helps to avoid this. Not gonna care about pre-10.11.

        if #available(OSX 10.11, *) {
            self.allowsLinkPreview = false
            self.customUserAgent = "(Macintosh) Safari/0.0 Safari/0.0"
        }

        // Use transparent background to make webview look more decent in the oauth view box.

        if NSAppKitVersion.current.rawValue >= NSAppKitVersion.macOS10_12.rawValue {
            self.setValue(false, forKey: "drawsBackground")
        } else {
            self.setValue(true, forKey: "drawsTransparentBackground")
        }
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, configuration: WKWebViewConfiguration.default)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

open class OauthWebViewDelegate: NSObject, WKNavigationDelegate
{
    public weak var progressIndicator: NSProgressIndicator?

    public var callbackUrl: URL?

    public init(progressIndicator: NSProgressIndicator? = nil, callbackUrl: URL? = nil) {
        super.init()
        self.progressIndicator = progressIndicator
        self.callbackUrl = callbackUrl
    }

    // MARK: -

    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url: URL = navigationAction.request.url, self.callbackUrl?.calledback(url: url) ?? false {
            decisionHandler(WKNavigationActionPolicy.cancel)
            OAuthSwift.handle(url: url)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }

    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        self.progressIndicator?.startAnimation(self)
    }

    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        webView.isHidden = false
        self.progressIndicator?.stopAnimation(self)
    }
}

extension URL
{
    fileprivate func calledback(url: URL) -> Bool {
        return url.scheme == self.scheme && url.host == self.host && url.path == self.path
    }
}