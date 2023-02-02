Pod::Spec.new do |s|
  s.name = "XROCSupport"
  s.version = "1.1.3.d"
  s.summary = "\u516C\u6709\u5E93\u4F7F\u7528"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"MissSunday"=>"963217127@qq.com"}
  s.homepage = "https://github.com/MissSunday/XROCSupport"
  s.description = "\u521B\u5EFA\u3001\u4E0A\u4F20\u3001pod\u3001\u6253\u5305\u3001\u811A\u672C\u7B49"
  s.frameworks = ["UIKit", "ImageIO", "Accelerate", "Foundation"]
  s.source = { :path => '.' }

  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'ios/XROCSupport.framework'
end
