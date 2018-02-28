#
# Be sure to run `pod lib lint Omnivore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Omnivore'
  s.version          = '0.1.0'
  s.summary          = 'Omnivore is dependency use for easy integration of Category and Subcategory Tree.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: This is just a demo description of this pod for demo purpose and will be change as soon as provided.
                       DESC

  s.homepage         = 'https://github.com/etDev24/Omnivore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'etDev24' => 'et_dev24@theentertainerme.com' }
  s.source           = { :git => 'https://github.com/etDev24/Omnivore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.swift_version = '3.2'
  s.source_files = 'Omnivore/Classes/**/*'
  # s.resource_bundles = {
  #   'Omnivore' => ['Omnivore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'Alamofire', '~> 4.4'
   s.dependency 'NVActivityIndicatorView'
   s.dependency 'Toast-Swift'
   s.dependency 'IQKeyboardManagerSwift'
   s.dependency 'Kingfisher', '~> 4.0'
end
