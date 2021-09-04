import Fakery
import Foundation
import Nimble
import OHHTTPStubs
import OHHTTPStubsSwift
import ReactiveOAuth
import ReactiveSwift
import XCTest

internal class AuthErrorTestCase: TestCase {

    /// Verify that errors are parsed and received as expected.

    internal func testReoauth() {
        let faker: Faker = Faker()
        let access: Access = Access(key: faker.lorem.word(), secret: faker.lorem.word())
        let configuration: Reoauth.Configuration = Reoauth.Configuration(access: access, url: Reoauth.URL(token: faker.internet.url()), token: faker.lorem.word())
        let reoauth: DetailedReoauth = DetailedReoauth(reoauth: Reoauth(configuration: configuration), detalisator: JsonDetalisator<String>())

        let expectation: XCTestExpectation = self.expectation(description: "Reoauth error")
        let error: NSError = NSError(domain: NSURLErrorDomain, code: Int(CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue), userInfo: [NSLocalizedDescriptionKey: "No internet…"])

        stub(condition: { _ in true }, response: { _ in HTTPStubsResponse(error: error) })

        reoauth.reactive.reauthorised.observe(Signal.Observer(failed: {
            expect($0.description).to(endWith(error.localizedDescription))
            expectation.fulfill()
        }))

        reoauth.reauthorise()

        self.wait(for: [expectation], timeout: 5)
    }
}
