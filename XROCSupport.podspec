#
# Be sure to run `pod lib lint XROCSupport.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
# 学习 https://juejin.cn/post/7159494385204199437

Pod::Spec.new do |s|
    s.name             = 'XROCSupport'
    s.version          = '1.2.0'
    if ENV['package']
        s.version          = "#{s.version}.d"
    end
    s.summary          = '公有库使用'
    s.description      = '创建、上传、pod、打包、脚本等'
    s.homepage         = 'https://github.com/MissSunday/XROCSupport'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'MissSunday' => '963217127@qq.com' }
    s.source           = { :git => 'https://github.com/MissSunday/XROCSupport.git', :tag => s.version.to_s }
    # s.social_media_url = '社交平台地址'
    s.ios.deployment_target = '9.0'
    
    
    if ENV['source']
        #source=1 pod install 相当于源码形式，用于打公有库
        s.source_files = 'XROCSupport/Classes/XROCSupport.h'
        
        s.subspec 'Resources' do |ss|
            ss.source_files = 'XROCSupport/Classes/Base/XRResourcesIndex.{h,m}'
            ss.resources = 'XROCSupport/Classes/Base/XROCSupport.bundle'
        end
        
        s.subspec 'A' do |ss|
            ss.source_files = 'XROCSupport/Classes/Tools/*'
        end
        
        s.subspec 'Category' do |ss|
            ss.dependency 'XROCSupport/A'
            ss.dependency 'XROCSupport/Resources'
            ss.source_files = 'XROCSupport/Classes/Category/*'
        end
        
        s.subspec 'Base' do |ss|
            ss.dependency 'XROCSupport/A'
            ss.dependency 'XROCSupport/Category'
            ss.source_files = 'XROCSupport/Classes/Base/XRBase*.{h,m}'
        end
    else
        #设置一个暴露的头文件，方便调用，可以不设置，能够在framework内部找到
        s.source_files = 'XROCSupport/Classes/**/*.h'
        # 设置framework可见的.h文件，如果不设置，XROCSupport.h头文件会找不到而报错
        #s.public_header_files = 'XROCSupport/Classes/**/*.h'
        #s.ios.vendored_libraries = "XROCSupport/Products/lib/lib#{s.name}.a"
        s.static_framework = true
        s.vendored_frameworks = "FrameWork-#{s.version}/ios/XROCSupport.framework"
        s.resource = 'XROCSupport/Classes/Base/XROCSupport.bundle'
        
    end
    
    
    
    
    
    #     s.resource_bundles = {
    #       'XROCSupport' => ['XROCSupport/Classes/Base/XROCSupport.bundle']
    #     }
    
    # s.public_header_files = 'XROCSupport/Classes/*.{h}'
    s.frameworks = ['UIKit', 'ImageIO','Accelerate','Foundation']
    # s.dependency 'AFNetworking', '~> 2.3'
    
    
    
    #执行xcode12的适配
    @@jdcnXcodeVersion = `xcodebuild -version`
    @@jdcnVersionS= @@jdcnXcodeVersion.split();
    @@jdcnUseVersion = @@jdcnVersionS[1].to_f
    puts @@jdcnUseVersion
    if  @@jdcnUseVersion>=12.0
        s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'ONLY_ACTIVE_ARCH' => 'YES' }
        s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64','ONLY_ACTIVE_ARCH' => 'YES' }
    end
    
end
