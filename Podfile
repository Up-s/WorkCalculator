# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WorkCalculator' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WorkCalculator
  
  pod 'CodableFirebase'
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Messaging'
  pod 'Firebase/Storage'
  
  pod 'Realm'
  pod 'RealmSwift'
  
  pod 'UPsKit'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
