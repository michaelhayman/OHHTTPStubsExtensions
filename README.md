# OHHTTPStubsExtensions

[![CI Status](http://img.shields.io/travis/Michael Hayman/OHHTTPStubsExtensions.svg?style=flat)](https://travis-ci.org/Michael Hayman/OHHTTPStubsExtensions)
[![Version](https://img.shields.io/cocoapods/v/OHHTTPStubsExtensions.svg?style=flat)](http://cocoapods.org/pods/OHHTTPStubsExtensions)
[![License](https://img.shields.io/cocoapods/l/OHHTTPStubsExtensions.svg?style=flat)](http://cocoapods.org/pods/OHHTTPStubsExtensions)
[![Platform](https://img.shields.io/cocoapods/p/OHHTTPStubsExtensions.svg?style=flat)](http://cocoapods.org/pods/OHHTTPStubsExtensions)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

OHHTTPStubsExtensions is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "OHHTTPStubsExtensions"
```

### Inspiration

The basis for this technique came from the
[justeat blog](http://tech.just-eat.com/2015/11/23/offline-ui-testing-on-ios-with-stubs/).

## Usage

### Target 

If using UI tests, add this pod and the JSON response bundles to your main target.

Otherwise, add them to the unit testing target.

### JSON response bundles

The bundles consist of a rules plist file which specifies what type of response to stub
and which JSON to load for that response.

There are examples in the demo.

### UI Tests

In a UI test, you would use it like this:

```swift
app = XCUIApplication()

app.launchArguments = [
    "STUB_API_CALLS_http_success_stubs",
    "RUNNING_AUTOMATION_TESTS"
]
```

`http_success_stubs` should be replaced with the name of the JSON responses bundle
you are loading. For example, you can load failure stubs as well.

In your app target, call the following function in AppDelegate:
```swift
#ifndef APP_STORE_BUILD
    HTTPStubber.stubAPICallsIfNeeded()
#endif
```

### Unit tests

In a unit test, you would use it like this:

setUp:
    `HTTPStubber.applyStubsInBundleWithName("http_success_stubs")`

tearDown:
    `HTTPStubbber.removeAllStubs()`

You can call this at the top level of your unit tests in a class method
and it will only be invoked once for the entire set of unit tests for that
class.

Or you can do it on a class-by-class basis as well.

## Author

Michael Hayman, michael@springbox.ca

## License

OHHTTPStubsExtensions is available under the MIT license. See the LICENSE file for more info.
