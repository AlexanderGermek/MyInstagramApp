# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyInstagramApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyInstagramApp
pod 'Appirater'
pod 'SDWebImage'
 

#Firebasae

pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Analytics'
pod 'Firebase/Crashlytics'
pod  'Firebase/Storage'

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
 end
end

end
