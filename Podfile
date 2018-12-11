# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'MaintainMyCity' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  inhibit_all_warnings!
  
   pod 'Fabric'
   pod 'Crashlytics'
   pod 'SwiftLint'
   pod 'FBSDKLoginKit'
   pod 'FacebookCore'
   pod 'FacebookLogin'
   pod 'FacebookShare'
   pod 'Alamofire', '~> 4.7'
   pod 'AlamofireImage', '~> 3.3'
   pod 'KeychainSwift', '~> 11.0'

   pod 'Reveal-SDK', :configurations => ['Debug']
   pod 'AWSS3'
  # Pods for MaintainMyCity

end

   post_install do |installer|
       installer.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
               config.build_settings['SWIFT_VERSION'] = '4.0'
           end
       end
   end
