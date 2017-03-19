import AppKit
import OAuthSwift
import WebKit

public func authorise<Detail>(hostViewController: NSViewController, oauthViewController: OauthViewController, oauth: DetailedOauth<Detail>) {

    // Little hack to ensure the view and outlets are loaded.

    _ = oauthViewController.view
    oauthViewController.representedObject = oauth

    // Todo: add during controller's lifetime? 

    oauth.oauth.reactive.authorised.observe({ [weak oauthViewController] (_) in
        oauthViewController?.progressIndicator.startAnimation(nil)
    })

    oauth.detalisator.reactive.detailed.observe({ [weak oauthViewController] (_) in
        oauthViewController?.progressIndicator.stopAnimation(nil)
    })

    oauth.reactive.authorised.observe({ [weak oauthViewController] (_) in
        oauthViewController?.dismissViewController(oauthViewController!)
    })

    hostViewController.presentViewControllerAsSheet(oauthViewController)
}

open class OauthViewController: NSViewController
{
    @IBOutlet open weak var progressIndicator: NSProgressIndicator!
    @IBOutlet open weak var webViewBox: NSBox!

    // MARK: -

    open weak var webView: WKWebView! {
        didSet {
            self.webView?.navigationDelegate = self.webViewDelegate
            self.webViewBox.contentView = self.webView ?? nil
        }
    }

    open var webViewDelegate: OauthWebViewDelegate! {
        didSet {
            self.webView?.navigationDelegate = self.webViewDelegate
        }
    }

    // MARK: -

    override open var representedObject: Any? {
        didSet {
            if let oauth: OauthProtocol = self.representedObject as! OauthProtocol? {
                self.webViewDelegate.callbackUrl = URL(string: oauth.configuration.url.callback)
            }
        }
    }

    // MARK: -

    open func authorise() {
        if let oauth: OauthProtocol = self.representedObject as! OauthProtocol? {
            oauth.authorise(webView: self.webView)
        }
    }

    // MARK: –

    override open func loadView() {
        super.loadView()
        self.webView = OauthWebView(frame: self.webViewBox.frame)
        self.webViewDelegate = OauthWebViewDelegate(progressIndicator: self.progressIndicator)
    }

    override open func viewDidAppear() {
        self.authorise()
    }
}