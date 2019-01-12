import AppKit
import OAuthSwift
import ReactiveCocoa
import ReactiveSwift
import Result
import WebKit

open class OAuthViewController: NSViewController
{
    @IBOutlet open weak var progressIndicator: NSProgressIndicator!
    @IBOutlet open weak var webViewBox: NSBox!

    // MARK: -

    open var webView: WKWebView! {
        get {
           return self.webViewBox.contentView as? WKWebView 
        }
        set {
            newValue?.navigationDelegate = self.webViewDelegate
            self.webViewBox.contentView = newValue
        }
    }

    open var webViewDelegate: OAuthWebViewDelegate! {
        didSet {
            self.webView?.navigationDelegate = self.webViewDelegate
        }
    }

    // MARK: -

    override open var representedObject: Any? {
        didSet {
            if let oauth: OAuthProtocol = self.representedObject as! OAuthProtocol? {
                self.webViewDelegate.callbackUrl = URL(string: oauth.configuration.url.callback)
            }
        }
    }

    // MARK: -

    open func authorise() {
        if let oauth: OAuthProtocol = self.representedObject as! OAuthProtocol? {
            oauth.authorise(webView: self.webView)
        }
    }

    open func cancel() {
        if let oauth: OAuthProtocol = self.representedObject as! OAuthProtocol? {
            oauth.cancel()
        }
    }

    // MARK: –

    override open func loadView() {
        super.loadView()
        self.webView = OAuthWebView(frame: self.webViewBox.frame)
        self.webViewDelegate = OAuthWebViewDelegate(progressIndicator: self.progressIndicator)
    }

    override open func viewDidAppear() {
        self.authorise()
    }

    open override func viewDidDisappear() {
        self.cancel()
    }
}

// MARK: -

public protocol OAuthorisable: class
{
    func authorise<Detail>(oauthViewController: OAuthViewController, oauth: DetailedOAuth<Detail>)
}

extension OAuthorisable where Self: NSViewController
{
    public func authorise<Detail>(oauthViewController: OAuthViewController, oauth: DetailedOAuth<Detail>) {

        // Little hack to ensure the view and outlets are loaded. Todo: this whole approach is shitty, we must
        // todo: do this inside `OAuthViewController`, not here…

        _ = oauthViewController.view
        oauthViewController.representedObject = oauth

        oauthViewController.reactive.makeBindingTarget({ (base, _) in base.progressIndicator.startAnimation(nil) }) <~ oauth.oauth.reactive.authorised.map({ _ in }).flatMapError({ _ in .never })
        oauthViewController.reactive.makeBindingTarget({ (base, _) in base.progressIndicator.stopAnimation(nil) }) <~ oauth.detalisator.reactive.detailed.map({ _ in }).flatMapError({ _ in .never })
        oauthViewController.reactive.makeBindingTarget({ (base, _) in base.dismiss(base) }) <~ oauth.reactive.authorised.map({ _ in }).flatMapError({ _ in .never })

        self.presentAsSheet(oauthViewController)
    }
}
