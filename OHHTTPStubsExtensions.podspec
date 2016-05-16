#
# Be sure to run `pod lib lint OHHTTPStubsExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "OHHTTPStubsExtensions"
  s.version          = "0.1.0"
  s.summary          = "Extends OHHTTPStubs with extra functionality for standardized testing."

  s.description      = <<-DESC
    This pod extends and standardizes the use of OHHTTPStubs for both unit and UI testing.

    It includes certain helper methods which expect bundles to be set up in a certain way.

    The bundles are independent of code and the JSON returned from the server is stored in the
    bundles.
  DESC

  s.homepage         = "https://github.com/michaelhayman/OHHTTPStubsExtensions"
  s.license          = 'MIT'
  s.author           = { "Michael Hayman" => "michael@springbox.ca" }
  s.source           = { :git => "https://github.com/michaelhayman/OHHTTPStubsExtensions.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'OHHTTPStubsExtensions/Classes/**/*'

  # s.dependency 'OHHTTPStubs', '~> 2.3'
end
