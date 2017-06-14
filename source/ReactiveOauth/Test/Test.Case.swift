import OHHTTPStubs
import XCTest

internal class TestCase: XCTestCase
{
    override internal func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }
}