#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint deepwall_flutter_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'deepwall_flutter_plugin'
  s.version          = '1.1.0'
  s.summary          = 'Deepwall Flutter plugin.'
  s.description      = <<-DESC
Deepwall Flutter plugin.
                       DESC
  s.homepage         = 'https://www.deepwall.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Deepwall' => 'https://deepwall.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'DeepWall', '~> 2.2'
  s.static_framework = true
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '4.2'
end
