import Foundation

class UITestingSetup {

    func setupUITestingEnvironment() {
        // #ifndef APP_STORE_BUILD
        if NSProcessInfo.processInfo().arguments.contains("RUNNING_AUTOMATION_TESTS") {
            stubAPICallsIfNeeded()
        }
        // #endif
    }

    func stubAPICallsIfNeeded() {
        // e.g. if 'STUB_API_CALLS_stubsTemplate_addresses' is received as argument
        // we globally stub the app using the 'stubsTemplate_addresses.bundle'
        let stubPrefix = "STUB_API_CALLS_"

        let stubPrefixForPredicate = stubPrefix.stringByAppendingString("*");

        let predicate = NSPredicate(format: "SELF like \(stubPrefixForPredicate)")

        let filteredArray = NSProcessInfo.processInfo().arguments.filter { predicate.evaluateWithObject($0) }

        let bundleName = filteredArray.first?.stringByReplacingOccurrencesOfString(stubPrefix, withString: "")

        if bundleName != nil {
            HTTPStubber.applyStubsInBundleWithName(bundleName)
        }
    }

}