//
//  HTTPStubber.swift
//
//  Created by Michael Hayman on 2016-05-16.

let MappingFilename = "stubRules"
let MatchingURL = "matching_url"
let JSONFile = "json_file"
let StatusCode = "status_code"
let HTTPMethod = "http_method"
let InlineResponse = "inline_response"

import OHHTTPStubs

@objc public class HTTPStubber: NSObject {
    public class func removeAllStubs() {
        OHHTTPStubs.removeAllStubs()
    }

    public class func applyStubsInBundleWithName(bundleName: String) {
        guard let bundle = retrieveBundle(bundleName: bundleName) else { return }
        guard let mappings = retrieveMappingsForBundle(bundle: bundle) else { return }

        for (index, stubInfo) in mappings.enumerate() {
            if let stubInfo = stubInfo as? NSDictionary {
                stub(stubInfo, bundle: bundle)
            }
        }
    }

    public class func applySingleStubInBundleWithName(bundle bundleName: String, resource: String) {
        guard let bundle = retrieveBundle(bundleName: bundleName) else { return }
        guard let mappings = retrieveMappingsForBundle(bundle: bundle) else { return }

        if let stubInfo = mappings.filter({ (element) -> Bool in
            if let element = element as? NSDictionary {
                return element[JSONFile] as! String == resource
            } else {
                return false
            }
        }).first {
            stub(stubInfo, bundle: bundle)
        }
    }

    class func stub(stubInfo: NSDictionary, bundle: NSBundle) {
        let matchingURL = stubInfo[MatchingURL] as! String
        let jsonFile = stubInfo[JSONFile] as! String
        let statusCodeString = stubInfo[StatusCode] as! String
        let statusCode = Int(statusCodeString)!
        let httpMethod = stubInfo[HTTPMethod] as! String
        OHHTTPStubs.stubURLThatMatchesPattern(matchingURL, jsonFileName: jsonFile, statusCode: statusCode, HTTPMethod: httpMethod, bundle: bundle)
    }

    class func retrieveBundle(bundleName bundleName: String) -> NSBundle? {
        let bundlePath = NSBundle.mainBundle().pathForResource(bundleName, ofType: "bundle")!
        let bundle = NSBundle(path: bundlePath)
        return bundle
    }

    class func retrieveMappingsForBundle(bundle bundle: NSBundle) -> [NSDictionary]? {
        let mappingFilePath = bundle.pathForResource(MappingFilename, ofType: "plist")
        let mapping = NSArray(contentsOfFile: mappingFilePath!) as! [NSDictionary]
        return mapping
    }

    public class func retrieveDataFromBundleWithName(bundle bundleName: String, resource: String) -> NSData? {
        let bundle = NSBundle.mainBundle()

        guard let bundlePath = bundle.pathForResource(bundleName, ofType: "bundle") else { return nil }
        guard let jsonBundle = NSBundle(path: bundlePath) else { return nil }
        guard let path = jsonBundle.pathForResource(resource, ofType: "json") else { return nil }

        return NSData(contentsOfFile: path)
    }

    public class func stubAPICallsIfNeeded() {
        if isRunningAutomationTests() {
            stubAPICalls()
        }
    }

    public class func isRunningAutomationTests() -> Bool {
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

        let predicate = NSPredicate(format: "SELF like %@", stubPrefixForPredicate)

        let filteredArray = NSProcessInfo.processInfo().arguments.filter { predicate.evaluateWithObject($0) }

        let bundleName = filteredArray.first?.stringByReplacingOccurrencesOfString(stubPrefix, withString: "")

        if let bundleName = bundleName {
            HTTPStubber.applyStubsInBundleWithName(bundleName)
        }
    }
}
