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

open class OauthWebview: WKWebView
{
    public override init(frame: CGRect, configuration: WKWebViewConfiguration? = nil) {
        super.init(frame: frame, configuration: configuration ?? WKWebViewConfiguration.default)

        self.allowsMagnification = false

        // Dropbox send a weird email saying the app has been authenticated from AppleMail, setting custom 
        // user agent helps to avoid this. Not gonna care about pre-10.11.

        if #available(OSX 10.11, *) {
            self.allowsLinkPreview = false
            self.customUserAgent = "(Macintosh) Safari/0.0 Safari/0.0"
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

@IBDesignable open class OauthWebviewWrapper: NSView
{
    open private(set) weak var webview: WKWebView! {
        didSet {
            if let webview: WKWebView = oldValue, oldValue.superview == self {
                webview.removeFromSuperview()
            }
            if let webview: WKWebView = self.webview {
                self.addSubview(webview)
                webview.translatesAutoresizingMaskIntoConstraints = false

                // Todo: this is shitty 10.10 syntax, use newer once moved away from it…

                if #available(OSX 10.11, *) {
                    webview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
                    webview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
                    webview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                    webview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
                } else {
                    self.addConstraints([
                        NSLayoutConstraint.init(item: webview, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0),
                        NSLayoutConstraint.init(item: webview, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0),
                        NSLayoutConstraint.init(item: webview, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0),
                        NSLayoutConstraint.init(item: webview, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
                    ])
                }
            }
        }
    }

    override public init(frame: NSRect) {
        super.init(frame: frame)
        self.initialise()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialise()
    }

    private func initialise() {
        self.webview = OauthWebview(frame: self.frame)
    }
}

open class OauthWebviewDelegate: NSObject, WKNavigationDelegate
{
    public weak var progressIndicator: NSProgressIndicator?

    public var callbackUrl: URL?

    public init(progressIndicator: NSProgressIndicator? = nil, callbackUrl: URL? = nil) {
        super.init()
        self.progressIndicator = progressIndicator
        self.callbackUrl = callbackUrl
    }

    // MARK: -

    open func webView(_ webview: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url: URL = navigationAction.request.url, self.callbackUrl?.calledback(url: url) ?? false {
            decisionHandler(WKNavigationActionPolicy.cancel)
            OAuthSwift.handle(url: url)
        } else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }

    open func webView(_ webview: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        self.progressIndicator?.startAnimation(self)
    }

    open func webView(_ webview: WKWebView, didFinish navigation: WKNavigation) {
        self.progressIndicator?.stopAnimation(self)

        // Todo: combine them into rac signal…

        // self.webView.evaluateJavaScript("document.body.clientWidth") {
        //     (result: AnyObject?, error: NSError?) in
        //     if error == nil {
        //         print(result)
        //     }
        // }

        // self.webView.evaluateJavaScript("document.body.clientHeight") {
        //     (result: AnyObject?, error: NSError?) in
        //     if error == nil {
        //         print(result)
        //     }
        // }
    }
}

extension URL
{
    fileprivate func calledback(url: URL) -> Bool {
        return url.scheme == self.scheme && url.host == self.host && url.path == self.path
    }
}