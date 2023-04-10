# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WorkCalculator' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WorkCalculator
  
  pod 'CodableFirebase'
  
  pod 'Firebase/Analytics', '~> 9.6'
  pod 'Firebase/Auth', '~> 9.6'
  pod 'Firebase/Core', '~> 9.6'
  pod 'Firebase/Crashlytics', '~> 9.6'
  pod 'Firebase/Firestore', '~> 9.6'
  pod 'Firebase/Messaging', '~> 9.6'
  pod 'Firebase/Storage', '~> 9.6'
  
  pod 'Realm', '~> 10.38'
  pod 'RealmSwift', '~> 10.38'
  
  pod 'UPsKit'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
