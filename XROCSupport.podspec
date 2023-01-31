#
# Be sure to run `pod lib lint XROCSupport.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XROCSupport'
  s.version          = '0.4.3'
  s.summary          = '公有库使用'
  s.description      = '创建、上传、pod、打包、脚本等'

  s.homepage         = 'https://github.com/MissSunday/XROCSupport'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MissSunday' => '963217127@qq.com' }
  s.source           = { :git => 'https://github.com/MissSunday/XROCSupport.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'XROCSupport/Classes/XROCSupport.h'
  
  s.subspec 'Tools' do |ss|
      
      ss.source_files = 'XROCSupport/Tools/**/*'
      ss.public_header_files = 'XROCSupport/Tools/XRPCH.h'
      
  end
  s.subspec 'Base' do |ss|
      
      ss.source_files = 'XROCSupport/Base/**/*'
      
  end
  
  s.subspec 'Category' do |ss|
      
      ss.source_files = 'XROCSupport/Category/**/*'
      
  end
  # s.resource_bundles = {
  #   'XROCSupport' => ['XROCSupport/Assets/*.png']
  # }

  # s.public_header_files = 'XROCSupport/Classes/*.{h}'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
