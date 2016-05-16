//
//  OHHTTPStubs+Extension.swift
//  MyTicker
//
//  Created by Michael Hayman on 2016-02-25.
//  Copyright © 2016 MyTicker, Inc. All rights reserved.
//

import UIKit
import OHHTTPStubs

extension OHHTTPStubs {
    class func stubURLThatMatchesPattern(regexPattern: String, jsonFileName: String, statusCode: Int, HTTPMethod: String, bundle: NSBundle) -> AnyObject? {
        // let targetBundle: NSBundle = bundle ? bundle : NSBundle(forClass: object_getClass(self))
        let targetBundle = bundle

        let path = targetBundle.pathForResource(jsonFileName, ofType: "json")
       
        var responseString: String?

        do {
            responseString = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        } catch _ {
            print("error")
            return nil
        }

        return self._stubURLThatMatchesPattern(regexPattern, responseString: responseString!, statusCode: statusCode, HTTPMethod: HTTPMethod)
    }

    class func _stubURLThatMatchesPattern(regexPattern: String, responseString: String, statusCode: Int, HTTPMethod: String) -> AnyObject? {
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: regexPattern, options: [])
        } catch _ {
            print("regex error")
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

            let response = responseString.dataUsingEncoding(NSUTF8StringEncoding)

            let headers = [ "Content-Type": "application/json; charset=utf-8" ]

            return OHHTTPStubsResponse(data: response!, statusCode: Int32(statusCode), headers: headers)
        }
    }
}
