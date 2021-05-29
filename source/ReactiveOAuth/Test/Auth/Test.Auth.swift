import AppKit
import CoreGraphics
import Nimble
import ReactiveOAuth
import ReactiveSwift
import WebKit
import XCTest

internal class AuthTestCase: TestCase {
    internal static var token: String?

    // MARK: -

    internal func testOAuth(type: AuthType, delegate: AbstractOAuthWebViewDelegate.Type) {
        guard let configuration: ConfigurationUtility.Configuration = ConfigurationUtility.configuration(for: type) else { return self.skip(with: "Missing configuration for \(type) auth type.") }

        let oauth: DetailedOAuth = OAuthFactory(type: type, configuration: configuration).construct()!
        let view: OAuthWebView = OAuthWebView(delegate: delegate.init(email: configuration.email, password: configuration.password, callbackUrl: URL(string: oauth.configuration.url.callback)))
        let window: AuthWindow = AuthWindow(view: view)
        let expectation: XCTestExpectation = self.expectation

        oauth.reactive.authorised.observe(Signal.Observer(
            value: { (credential: Credential, email: Email) in
                expect(email).toNot(beEmpty())

                // Swift.print("Successfully authorised \(type):", credential)

                Swift.type(of: self).token = credential.refreshToken

                if self.responds(to: Selector(("testReoauth"))) {
                    expect(credential.refreshToken).toNot(beNil())
                    expect(credential.expireDate).toNot(beNil())
                }

                expectation.fulfill()
            },
            failed: { (error: ReactiveOAuth.Error) in
                XCTFail(error.description)
            }
        ))

        window.orderFrontRegardless()
        oauth.authorise(webView: view)
        self.waitForExpectations()
    }

    internal func testReoauth(type: AuthType) {
        guard let configuration: ConfigurationUtility.Configuration = ConfigurationUtility.configuration(for: type) else { return self.skip(with: "Missing configuration for \(type) auth type.") }
        guard let token: String = Swift.type(of: self).token else { return self.skip(with: "Missing token for \(type) auth type, make sure oauth test is run first.") }

        let reoauth: DetailedReoauth = ReoauthFactory(type: type, configuration: configuration, token: token).construct()!
        let expectation: XCTestExpectation = self.expectation

        reoauth.reactive.reauthorised.observe(Signal.Observer(
            value: { (credential: Credential, email: Email) in
                expect(email).toNot(beEmpty())
                expect(credential.refreshToken).notTo(beNil())
                expect(credential.expireDate).notTo(beNil())
                expectation.fulfill()
            },
            failed: { (error: ReactiveOAuth.Error) in
                XCTFail(error.description)
            }
        ))

        reoauth.reauthorise()
        self.waitForExpectations()
    }

    // MARK: -

    internal var expectation: XCTestExpectation {
        self.expectation(description: "auth")
    }

    internal func waitForExpectations() {
        self.waitForExpectations(timeout: 60)
    }

    // MARK: -

    internal func skip(with message: String? = nil) {
        Swift.print("Skipping \(self) test: \(message ?? "…")")
    }
}

internal class OAuthWebView: ReactiveOAuth.OAuthWebView {
    private weak var delegate: WKNavigationDelegate?

    internal convenience init(delegate: WKNavigationDelegate) {
        self.init(frame: CGRect(x: 0, y: 0, width: 250, height: 250))

        self.delegate = delegate
        self.navigationDelegate = delegate
    }
}

internal class AuthWindow: NSWindow {
    internal convenience init(view: NSView) {
        self.init(contentRect: NSRect(x: 0, y: 0, width: 400, height: 600), styleMask: .titled, backing: .buffered, defer: true)
        self.level = .modalPanel
        self.contentView = view
    }

    override internal func orderFrontRegardless() {
        super.orderFrontRegardless()
        super.center()
    }
}

// MARK: -

internal class AbstractOAuthWebViewDelegate: ReactiveOAuth.OAuthWebViewDelegate {
    private let email: String
    private let password: String

    internal required init(email: String, password: String, progressIndicator: NSProgressIndicator? = nil, callbackUrl: URL? = nil) {
        self.email = email
        self.password = password
        super.init(progressIndicator: progressIndicator, callbackUrl: callbackUrl)
    }

    internal func authorise(script: String) -> String {
        script
            .replacingOccurrences(of: "$(EMAIL)", with: self.email)
            .replacingOccurrences(of: "$(PASSWORD)", with: self.password)
    }
}
