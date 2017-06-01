#
#  Be sure to run `pod spec lint Evrythng-iOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "EvrythngiOS"
  s.version      = "0.0.1"
  s.summary      = "iOS variant of the Evrythng Platform SDK"
  s.description  = 'evrythng-ios-sdk is an SDK to be used when developing iOS enabled Applications using the Evrythng Platform.'
  s.homepage     = 'https://github.com/evrythng/evrythng-ios-sdk'
  s.license      = { :type => 'MIT', :file => 'license.md'}
  s.authors      = { 'JD Castro' => 'jd@imfreemobile.com' }
  s.platform     = :ios, '10.0'
  s.source       = { :git => 'https://github.com/imfree-jdcastro/Evrythng-iOS-SDK.git', :tag => '0.0.11' }
  s.source_files = 'Evrythng-iOS', 'Evrythng-iOS/**/*.{h,m,swift}'
  s.exclude_files = 'Classes/Exclude'
  #s.resources    = 'Evrythng-iOS/*.mp3'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.dependency 'Alamofire', '~> 4.4'
  s.dependency 'AlamofireObjectMapper', '~> 4.1'
  s.dependency 'SwiftyJSON', '~> 3.1'
  s.dependency 'Moya', '~> 8.0.3'
  s.dependency 'MoyaSugar', '~> 0.4'
  s.dependency 'SwiftEventBus', '~> 2.1'
  s.dependency 'Moya-SwiftyJSONMapper', '~> 2.2'
  s.dependency 'QRCodeReader.swift', '~> 7.4.1'

end
