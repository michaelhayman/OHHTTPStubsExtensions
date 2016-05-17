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

        guard let requestURL = NSURL(string: "https://example.com/sign_up") else {
            XCTFail("Invalid URL.")
            return
        }

        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "POST"

        let e = expectationWithDescription("...")

        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let weakSelf = self else { return }

            e.fulfill()
            if let data = data {
                XCTAssertNotNil(data)
                weakSelf.verifySignUpData(data)
            } else {
                XCTFail("No data returned.")
            }
            XCTAssertNil(error)
        }).resume()

        waitForExpectationsWithTimeout(3, handler: nil)

        runMedicationTest()
    }

    func testSpecificStub() {
        HTTPStubber.applySingleStubInBundleWithName(bundle: "http_success_stubs", resource: "GET_Medications_200")

        runMedicationTest()
    }

    func runMedicationTest() {
        guard let requestURL = NSURL(string: "https://example.com/medications") else {
            XCTFail("Invalid URL.")
            return
        }

        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"

        let e = expectationWithDescription("...")

        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let weakSelf = self else { return }

            e.fulfill()
            if let data = data {
                XCTAssertNotNil(data)
                weakSelf.verifyMedicationData(data)
            } else {
                XCTFail("No data returned.")
            }
            XCTAssertNil(error)
        }).resume()

        waitForExpectationsWithTimeout(3, handler: nil)
    }

    func testIsRunningAutomationTestsFalse() {
        XCTAssertFalse(HTTPStubber.isRunningAutomationTests())
    }

    func testLoadData() {
        if let data = HTTPStubber.retrieveDataFromBundleWithName(bundle: "http_success_stubs", resource: "POST_SignUp_200") {
            XCTAssertNotNil(data)
            verifySignUpData(data)
        } else {
            XCTFail("Failed to find data in bundle.")
        }
    }

    func verifySignUpData(data: NSData) {
        if let json = NSString(data: data, encoding:NSUTF8StringEncoding) {
            XCTAssertNotNil(json)
            let expectedString = "{\n    \"access_token\": \"asdf\"\n}"
            XCTAssertEqual(expectedString, json)
        } else {
            XCTFail("Failed to convert data to string.")
        }
    }

    func verifyMedicationData(data: NSData) {
        if let json = NSString(data: data, encoding:NSUTF8StringEncoding) {
            XCTAssertNotNil(json)
            let expectedString = "{\n    \"medications\": [{\n        \"id\": 99,\n        \"profile_id\": 260,\n        \"name\": \"Prozac\",\n        \"details\": null,\n        \"frequency\": \"daily\",\n        \"dosage\": \"200 mg\",\n        \"notify\": false,\n        \"medication_times\": [ {\n            \"time\": \"1980-06-20T09:30:00.000Z\"\n        }]\n    }]\n}"
            XCTAssertEqual(expectedString, json)
        } else {
            XCTFail("Failed to convert data to string.")
        }
    }
}
