#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'beacon_scanner_ios'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for Scanning iBeacon.'
  s.description      = <<-DESC
A Flutter plugin for making the underlying platform (Android or iOS) scan for iBeacons.
                       DESC
  s.homepage         = 'https://github.com/TODO'
  s.license          = { :type => 'TODO', :file => '../LICENSE' }
  s.author           = { 'TODO' => 'TODO@gmail.com' }
  s.source           = { :http => 'https://github.com/TODO' }
  s.documentation_url = 'https://pub.dev/packages/TODO'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end