#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'beacon_scanner_ios'
  s.version          = '0.0.3'
  s.summary          = 'A Flutter plugin for scanning iBeacon.'
  s.description      = <<-DESC
A Flutter plugin for making the underlying platform (Android or iOS) scan for iBeacons.
                       DESC
  s.homepage         = 'https://github.com/Lukangi/beacon_scanner/tree/main/beacon_scanner_ios'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Lukangi' => 'lukanga.games@gmail.com' }
  s.source           = { :http => 'https://github.com/Lukangi/beacon_scanner/tree/main/beacon_scanner_ios' }
  s.documentation_url = 'https://pub.dev/packages/beacon_scanner_ios'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end