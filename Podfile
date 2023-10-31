# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Altyn-Yoda' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
   pod 'EasyPeasy', '1.9.0'
   pod 'AdvancedPageControl'
   pod 'ToosieSlide', '~> 1.1'  
   pod 'Localize-Swift', '~> 3.2'
   pod 'RxSwift', '6.5.0'
   pod 'RxCocoa', '6.5.0'
   pod 'RxAlamofire'
   pod 'Kingfisher', '~> 6.3.1'
   pod 'GoogleMaps'
   pod 'ContextMenuSwift'
   pod "BSImagePicker", "~> 3.1"
   pod 'FirebaseAnalytics'
   pod 'Firebase/Messaging'
   
  # Pods for Altyn-Yoda
  
  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
                 end
            end
     end
  end
  
  
end

