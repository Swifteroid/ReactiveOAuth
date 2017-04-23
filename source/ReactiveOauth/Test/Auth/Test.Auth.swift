import AppKit
import CoreGraphics
import Nimble
import ReactiveOauth
import ReactiveSwift
import WebKit
import XCTest

internal class AuthTestCase: TestCase
{
    internal static var token: String?

    // MARK: -

    internal func testOauth(type: AuthType, delegate: AbstractOauthWebViewDelegate.Type) {
        guard let configuration: ConfigurationUtility.Configuration = ConfigurationUtility.configuration(for: type) else { return self.skip(with: "Missing configuration for \(type) auth type.") }

        let oauth: DetailedOauth = OauthFactory(type: type, configuration: configuration).construct()!
        let view: OauthWebView = OauthWebView(delegate: delegate.init(email: configuration.email, password: configuration.password, callbackUrl: URL(string: oauth.configuration.url.callback)))
        let window: AuthWindow = AuthWindow(view: view)
        let expectation: XCTestExpectation = self.expectation

        oauth.reactive.authorised.observe(Observer(
            value: { (credential: Credential, email: Email) in
                Swift.print("Successfully authorised \(type):", credential)
                type(of: self).token = credential.refreshToken
                expectation.fulfill()
            },
            failed: { (error: ReactiveOauth.Error) in
                XCTFail(error.description)
            }
        ))

        window.orderFrontRegardless()
        oauth.authorise(webView: view)
        self.waitForExpectations()
    }

    internal func testReoauth(type: AuthType) {
        guard let configuration: ConfigurationUtility.Configuration = ConfigurationUtility.configuration(for: type) else { return self.skip(with: "Missing configuration for \(type) auth type.") }
        guard let token: String = type(of: self).token else { return self.skip(with: "Missing token for \(type) auth type, make sure oauth test is run first.") }

        let reoauth: DetailedReoauth = ReoauthFactory(type: type, configuration: configuration, token: token).construct()!
        let expectation: XCTestExpectation = self.expectation

        reoauth.reactive.reauthorised.observe(Observer(
            value: { (credential: Credential, email: Email) in
                expect(credential.refreshToken).notTo(beNil())
                expect(credential.expireDate).notTo(beNil())
                expectation.fulfill()
            },
            failed: { (error: ReactiveOauth.Error) in
                XCTFail(error.description)
            }
        ))

        reoauth.reauthorise()
        self.waitForExpectations()
    }

    // MARK: -

    internal var expectation: XCTestExpectation {
        return self.expectation(description: "auth")
    }

    internal func waitForExpectations() {
        self.waitForExpectations(timeout: 30)
    }

    // MARK: -

    internal func skip(with message: String? = nil) {
        Swift.print("Skipping \(self) test: \(message ?? "…")")
    }
}

internal class OauthWebView: ReactiveOauth.OauthWebView
{
    private var delegate: WKNavigationDelegate?

    internal convenience init(delegate: WKNavigationDelegate) {
        self.init(frame: CGRect(x: 0, y: 0, width: 250, height: 250))

        self.delegate = delegate
        self.navigationDelegate = delegate
    }
}

internal class AuthWindow: NSWindow
{
    internal convenience init(view: NSView) {
        self.init(contentRect: NSRect(x: 0, y: 0, width: 400, height: 600), styleMask: .titled, backing: .buffered, defer: true)
        self.level = Int(CGWindowLevelForKey(.modalPanelWindow))
        self.contentView = view
    }

    override internal func orderFrontRegardless() {
        super.orderFrontRegardless()
        super.center()
    }
}

// MARK: -

internal class AbstractOauthWebViewDelegate: ReactiveOauth.OauthWebViewDelegate
{
    private let email: String
    private let password: String

    internal required init(email: String, password: String, progressIndicator: NSProgressIndicator? = nil, callbackUrl: URL? = nil) {
        self.email = email
        self.password = password
        super.init(progressIndicator: progressIndicator, callbackUrl: callbackUrl)
    }

    internal func authorise(script: String) -> String {
        return script
            .replacingOccurrences(of: "$(EMAIL)", with: self.email)
            .replacingOccurrences(of: "$(PASSWORD)", with: self.password)
    }
}