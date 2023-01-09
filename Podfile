# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WorkCalculator' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WorkCalculator

  pod 'Firebase/Analytics', '~> 9'
  pod 'Firebase/Auth', '~> 9'
  pod 'Firebase/Core', '~> 9'
  pod 'Firebase/Crashlytics', '~> 9'
  pod 'Firebase/Firestore', '~> 9'
  pod 'Firebase/Messaging', '~> 9'
  pod 'Firebase/Storage', '~> 9'
  
  pod 'UPsKit'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
    end
  end
end
