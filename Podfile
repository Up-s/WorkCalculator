target 'WorkCalculator' do
  use_frameworks!

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

target 'InWidgetExtension' do
  use_frameworks!

  pod 'CodableFirebase'
  
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
