//
//  OHHTTPStubs+FFVAdditions.h
//  Foodfaves
//
//  Created by Michael Hayman on 16/02/20.
//  Copyright (c) 2016 Infinum Ltd. All rights reserved.
//

@import Foundation;
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface OHHTTPStubs (FFVAdditions)

+ (id)stubURLThatMatchesPattern:(NSString *)regexPattern
               withJSONFileName:(NSString *)jsonFileName
                     statusCode:(NSInteger)statusCode
                     HTTPMethod:(NSString *)HTTPMethod
                         bundle:(NSBundle *)bundle;

@end
