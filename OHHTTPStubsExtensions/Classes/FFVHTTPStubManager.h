//
//  FFVHTTPStubManager.h
//  Foodfave
//
//  Created by Michael Hayman on 16/02/20.
//  Copyright (c) 2016 Infinum Ltd. All rights reserved.
//

@import Foundation;

@interface FFVHTTPStubManager : NSObject

+ (void)applyStubsInBundleWithName:(NSString *)bundleName;
+ (void)removeAllStubs;

@end
