import UIKit
import XCTest
import OHHTTPStubsExtensions

class HTTPStubberTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testApplyAllStubs() {
        HTTPStubber.applyStubsInBundleWithName("http_success_stubs")
    }

    func testSpecificStub() {
        HTTPStubber.applySingleStubInBundleWithName(bundle: "http_success_stubs", resource: "GET_Medications_200")
    }

    func testIsRunningAutomationTestsFalse() {
        XCTAssertFalse(HTTPStubber.isRunningAutomationTests())
    }

    func testLoadData() {
        let data = HTTPStubber.retrieveDataFromBundleWithName(bundle: "http_success_stubs", resource: "POST_SignUp_200.json")
        XCTAssertNotNil(data)
    }
}
