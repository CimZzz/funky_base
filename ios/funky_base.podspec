#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint funky_base.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'funky_base'
  s.version          = '0.0.1'
  s.summary          = 'base for develop'
  s.description      = <<-DESC
base for develop
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.public_header_files = 'Classes/**/*.h'
  # 第三方.a文件
  s.vendored_libraries = 'Classes/**/*.a'
  # 第三方framework
  s.vendored_frameworks = 'Classes/**/*.framework'
  s.dependency 'Flutter'
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
