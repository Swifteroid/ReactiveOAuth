import CoreLocation // Fakery needs this, but it doesn't get autolinked…
import OHHTTPStubs
import XCTest

internal class TestCase: XCTestCase {
    override internal func tearDown() {
        HTTPStubs.removeAllStubs()
    }
}
