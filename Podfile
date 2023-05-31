# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Cliqued' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cliqued
 
  # keyboard handler
  pod 'IQKeyboardManager'
  
  # Json helper
  pod 'SwiftyJSON', '4.2'

  # To load images from web
  pod 'SDWebImage'

  # API
  pod 'Alamofire'

  #Loader
  pod 'SVProgressHUD'

  # Pull to refresh
  pod 'MJRefresh'

  # Google Login
  pod 'GoogleSignIn'

  # Facebook Login
  pod 'FBSDKLoginKit'

  # Photopicker
  pod "TLPhotoPicker"

  # Card Suffle
  pod "Koloda"

  # Custom Alert
  pod 'SwiftMessages'

  pod 'RangeSeekSlider'
  pod "GrowingTextView"
  pod 'Socket.IO-Client-Swift', '~> 16.0.1'
  pod 'CocoaDebug', :configurations => ['Debug']
  pod 'DropDown'
  pod "SoundWave"
  pod 'RangeSeekSlider'
  pod 'SkeletonView'
  pod 'SKPhotoBrowser'
  pod 'Google-Mobile-Ads-SDK'
  pod 'lottie-ios'

post_install do |installer|
      
      installer.pods_project.targets.each do |target|
        if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
          target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
          end
        end
      end
      
    end
end
