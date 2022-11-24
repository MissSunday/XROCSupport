#
# Be sure to run `pod lib lint XROCSupport.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XROCSupport'
  s.version          = '0.1.0'
  s.summary          = '公有库使用学习XROCSupport.'
  s.description      = '创建、上传、pod、打包尝试'

  s.homepage         = 'https://github.com/MissSunday/XROCSupport'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MissSunday' => '963217127@qq.com' }
  s.source           = { :git => 'git@github.com:MissSunday/XROCSupport.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'XROCSupport/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XROCSupport' => ['XROCSupport/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
