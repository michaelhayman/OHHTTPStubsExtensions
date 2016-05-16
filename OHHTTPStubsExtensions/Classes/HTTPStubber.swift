//
//  HTTPStubber.swift
//  MyTicker
//
//  Created by Michael Hayman on 2016-02-25.
//  Copyright © 2016 MyTicker, Inc. All rights reserved.
//

let MappingFilename = "stubRules"
let MatchingURL = "matching_url"
let JSONFile = "json_file"
let StatusCode = "status_code"
let HTTPMethod = "http_method"
let InlineResponse = "inline_response"

import OHHTTPStubs

final public class HTTPStubber {
    
    class func removeAllStubs() {
        OHHTTPStubs.removeAllStubs()
    }

    class func applyStubsInBundleWithName(bundleName: String) {
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
            print("stub loaded \(stub)");
        })
    }
}

