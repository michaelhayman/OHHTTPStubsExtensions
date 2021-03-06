//
//  OHHTTPStubs+Extension.swift
//
//  Created by Michael Hayman on 2016-05-16.

import UIKit
import OHHTTPStubs

extension OHHTTPStubs {
    class func stubURLThatMatchesPattern(regexPattern: String, jsonFileName: String, statusCode: Int, HTTPMethod: String, bundle: NSBundle) -> AnyObject? {
        guard let path = bundle.pathForResource(jsonFileName, ofType: "json") else { return nil }
       
        do {
            let responseString = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            return self._stubURLThatMatchesPattern(regexPattern, responseString: responseString, statusCode: statusCode, HTTPMethod: HTTPMethod)
        } catch {
            print("Parse error \(error)")
            return nil
        }
    }

    class func _stubURLThatMatchesPattern(regexPattern: String, responseString: String, statusCode: Int, HTTPMethod: String) -> AnyObject? {
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: regexPattern, options: [])
        } catch {
            print("Regular expression error \(error)")
            return nil
        }
        
        return OHHTTPStubs.stubRequestsPassingTest({ request in

            if request.HTTPMethod != HTTPMethod {
                return false
            }

            let requestURLString = request.URL?.absoluteString
            if regex.firstMatchInString(requestURLString!, options: [], range: NSMakeRange(0, requestURLString!.characters.count)) != nil {
                return true
            }

            return false
        }) { (request) -> OHHTTPStubsResponse in

            guard let response = responseString.dataUsingEncoding(NSUTF8StringEncoding) else { return OHHTTPStubsResponse() }

            let headers = [ "Content-Type": "application/json; charset=utf-8" ]

            let statusCode = Int32(statusCode)

            if statusCode == 422 || statusCode == 500 {
                let error = NSError(domain: NSURLErrorDomain, code: Int(CFNetworkErrors.CFURLErrorCannotLoadFromNetwork.rawValue), userInfo: nil)
                return OHHTTPStubsResponse(error: error)
            }

            return OHHTTPStubsResponse(data: response, statusCode: statusCode, headers: headers)
        }
    }
}
