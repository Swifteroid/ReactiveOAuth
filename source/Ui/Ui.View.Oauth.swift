import AppKit
import OAuthSwift
import WebKit

public func authorise<Detail>(hostViewController: NSViewController, oauthViewController: OauthViewController, oauth: DetailedOauth<Detail>) {
    oauthViewController.oauth = oauth

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
    @IBOutlet open private(set) weak var progressIndicator: NSProgressIndicator!
    @IBOutlet open private(set) weak var webviewWrapper: OauthWebviewWrapper!

    // MARK: -

    open var delegate: OauthWebviewDelegate!

    open var oauth: OauthProtocol! {
        didSet {
            self.delegate.callbackUrl = URL(string: self.oauth.configuration.url.callback)
        }
    }

    open func authorise() {
        self.oauth.authorise(webview: self.webviewWrapper.webview)
    }

    // MARK: –

    override open func viewDidLoad() {
        self.delegate = OauthWebviewDelegate(progressIndicator: self.progressIndicator)
        self.webviewWrapper.webview.navigationDelegate = self.delegate
    }

    override open func viewDidAppear() {
        self.authorise()
    }
}