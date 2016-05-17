# OHHTTPStubsExtensions

[![Version](https://img.shields.io/cocoapods/v/OHHTTPStubsExtensions.svg?style=flat)](http://cocoapods.org/pods/OHHTTPStubsExtensions)
[![License](https://img.shields.io/cocoapods/l/OHHTTPStubsExtensions.svg?style=flat)](http://cocoapods.org/pods/OHHTTPStubsExtensions)
[![Platform](https://img.shields.io/cocoapods/p/OHHTTPStubsExtensions.svg?style=flat)](http://cocoapods.org/pods/OHHTTPStubsExtensions)

## Overview

Quickly stub out the network for both your unit tests and UI tests in as few lines of
code as possible.

Concentrate on maintaining the JSON as returned from the API in a few bundles inside of your app.

The basis for this technique came from an article on the
[justeat blog](http://tech.just-eat.com/2015/11/23/offline-ui-testing-on-ios-with-stubs/).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

You can also run the tests to understand how the library works from within the demo.

## Installation

### Cocoapods

OHHTTPStubsExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile for both your main target and your
unit test target:

```ruby
pod "OHHTTPStubsExtensions"
```

This pod will install the underlying library `OHHTTPStubs` automatically.

### Carthage

TBA

## Usage

### Target 

Add the JSON response bundles to your main target so they can be accessed by both UI
and unit tests.

### JSON response bundles

The bundles consist of a rules plist file which specifies what type of response to stub
and which JSON to load for that response.

There are examples in the demo.

The URLs in the response bundles accept regular expressions. See the tests and the
bundles for examples.

### UI Tests

Because the UI tests don't have their own specialized environment, unfortunately testing
code needs to be added to your main target.

Add the following code to your UI test:

```swift
app = XCUIApplication()

app.launchArguments = [
    "STUB_API_CALLS_http_success_stubs",
    "RUNNING_AUTOMATION_TESTS"
]
```

The string `http_success_stubs` should be replaced with the name of the
JSON responses bundle you are loading. For example, you can load a bundle called
`http_failure_stubs` to test your error code.

In your app target, call the following function in AppDelegate:

```swift
@import OHHTTPStubsExtensions

#ifndef APP_STORE_BUILD
    HTTPStubber.stubAPICallsIfNeeded()
#endif
```

```objc
#import "OHHTTPStubsExtensions-Swift.h"

#ifndef APP_STORE_BUILD
    [HTTPStubber stubAPICallsIfNeeded];
#endif
```

### Unit tests

Add the following code to your unit test:

```swift
@import OHHTTPStubsExtensions

func setUp() {
    super.setUp()
    HTTPStubber.applyStubsInBundleWithName("http_success_stubs")
}

func tearDown() {
    super.tearDown()
    HTTPStubbber.removeAllStubs()
}
```

```objc
#import "OHHTTPStubsExtensions-Swift.h"

+ (void)setUp {
    [super setUp];

    [HTTPStubber applyStubsInBundleWithName:@"http_success_stubs"];
}

+ (void)tearDown {
    [super tearDown];

    [HTTPStubber removeAllStubs];
}

```

You can also call this at the top level of your unit tests in a class method
and it will only be invoked once for the entire set of unit tests for that
class.  There are additional methods to:

* apply the stubs in each bundle selectively;
* load the JSON from a stub into an NSData object (for example to test your parser code)

## Tests

After doing a `pod install` in the `Example` project:

```
xcodebuild \
    -workspace Example/OHHTTPStubsExtensions.xcworkspace \
    -scheme OHHTTPStubsExtensions-Example \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
    test
````

## Author

Michael Hayman, michael@springbox.ca

## License

OHHTTPStubsExtensions is available under the MIT license. See the LICENSE file for more info.

