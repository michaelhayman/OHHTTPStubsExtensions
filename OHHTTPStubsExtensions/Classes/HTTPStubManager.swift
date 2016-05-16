//
//  FFVHTTPStubManager.h
//  Foodfave
//
//  Created by Michael Hayman on 16/02/20.
//  Copyright (c) 2016 Infinum Ltd. All rights reserved.
//

#import "FFVHTTPStubManager.h"
#import "OHHTTPStubs+FFVAdditions.h"

static NSString *ffv_mappingFilename = @"stubRules";

static NSString const *ffv_matchingURL = @"matching_url";
static NSString const *ffv_jsonFile = @"json_file";
static NSString const *ffv_statusCode = @"status_code";
static NSString const *ffv_httpMethod = @"http_method";
static NSString const *ffv_inlineResponse = @"inline_response";

@implementation FFVHTTPStubManager

+ (void)applyStubsInBundleWithName:(NSString *)bundleName {
    NSParameterAssert(bundleName);

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *mappingFilePath = [bundle pathForResource:ffv_mappingFilename ofType:@"plist"];
    NSArray *mapping = [NSArray arrayWithContentsOfFile:mappingFilePath];

    [mapping enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull stubInfo, NSUInteger idx, BOOL * _Nonnull stop) {

        NSString *matchingURL = stubInfo[ffv_matchingURL];
        NSString *jsonFile = stubInfo[ffv_jsonFile];
        NSNumber *statusCode = stubInfo[ffv_statusCode];
        NSString *httpMethod = stubInfo[ffv_httpMethod];
        // NSString *inlineResponse = stubInfo[ffv_inlineResponse];

        id stub = [OHHTTPStubs stubURLThatMatchesPattern:matchingURL
                                        withJSONFileName:jsonFile
                                              statusCode:[statusCode integerValue]
                                              HTTPMethod:httpMethod
                                                  bundle:bundle];
        NSLog(@"stub loaded: %@", stub);
    }];
}

+ (void)removeAllStubs {
    [OHHTTPStubs removeAllStubs];
}

@end
