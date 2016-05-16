import UIKit
import XCTest
import OHHTTPStubsExtensions

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        HTTPStubber.applyStubsInBundleWithName("")
        XCTAssert(true, "Pass")
    }
}
