//
//  HTTPStubber.swift
//
//  Created by Michael Hayman on 2016-02-25.
//

let MappingFilename = "stubRules"
let MatchingURL = "matching_url"
let JSONFile = "json_file"
let StatusCode = "status_code"
let HTTPMethod = "http_method"
let InlineResponse = "inline_response"

import OHHTTPStubs

public class HTTPStubber {

    class func removeAllStubs() {
        OHHTTPStubs.removeAllStubs()
    }

    public class func applyStubsInBundleWithName(bundleName: String) {
        let bundlePath = NSBundle.mainBundle().pathForResource(bundleName, ofType: "bundle")!
        let bundle = NSBundle(path: bundlePath)
        let mappingFilePath = bundle?.pathForResource(MappingFilename, ofType: "plist")
        let mapping = NSArray(contentsOfFile: mappingFilePath!)

        mapping?.enumerateObjectsUsingBlock({ stubInfo, index, stop in
            let matchingURL = stubInfo[MatchingURL] as! String
            let jsonFile = stubInfo[JSONFile] as! String
            let statusCodeString = stubInfo[StatusCode] as! String
            let statusCode = Int(statusCodeString)!
            let httpMethod = stubInfo[HTTPMethod] as! String

            let stub = OHHTTPStubs.stubURLThatMatchesPattern(matchingURL, jsonFileName: jsonFile, statusCode: statusCode, HTTPMethod: httpMethod, bundle: bundle!)
        })
    }

    class func applySingleStubInBundleWithName(bundleName bundleName: String, stubName: String) {

    }
//}

// extension HTTPStubber {
    class func stubAPICallsIfNeeded() {
        if isRunningAutomationTests() {
            stubAPICalls()
        }
    }

    class func isRunningAutomationTests() -> Bool {
        if NSProcessInfo.processInfo().arguments.contains("RUNNING_AUTOMATION_TESTS") {
            return true
        }
        return false
    }

    class func stubAPICalls() {
        // e.g. if 'STUB_API_CALLS_stubsTemplate_addresses' is received as argument
        // we globally stub the app using the 'stubsTemplate_addresses.bundle'
        let stubPrefix = "STUB_API_CALLS_"

        let stubPrefixForPredicate = stubPrefix.stringByAppendingString("*");

        let predicate = NSPredicate(format: "SELF like \(stubPrefixForPredicate)")

        let filteredArray = NSProcessInfo.processInfo().arguments.filter { predicate.evaluateWithObject($0) }

        let bundleName = filteredArray.first?.stringByReplacingOccurrencesOfString(stubPrefix, withString: "")

        if let bundleName = bundleName {
            HTTPStubber.applyStubsInBundleWithName(bundleName)
        }
    }
}

