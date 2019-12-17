#
# Be sure to run `pod lib lint phrase_swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'phrase_swift'
  s.version          = '0.1.0'
  s.summary          = 'A swift port of Squares Phrase library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/tornanextbike/phrase-swift'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = { 'Jan Meier' => 'meier@nextbike.com' }
  s.source           = { :git => 'https://github.com/tornanextbike/phrase-swift.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  
  s.swift_version = '5.0'

  s.source_files = 'phrase_swift/**/*.swift'

  # s.resource_bundles = {
  #   'phrase_swift' => ['phrase_swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
