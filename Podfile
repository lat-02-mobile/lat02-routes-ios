# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!

def shared_pods
  pod 'SwiftLint', '0.47.1'
  pod 'CodableFirebase'
  pod 'SVProgressHUD', '2.2.5'
  pod 'IQKeyboardManagerSwift', '6.2.1'
  pod 'GoogleSignIn', '6.2.2'
  pod 'CountryPickerSwift', '1.8'
  pod 'SwiftAlertView', '2.2.1'
  pod 'FacebookCore', '0.9.0'
  pod 'FacebookLogin', '0.9.0'
  pod 'GoogleMaps', '7.0.0'
  pod 'GooglePlaces', '7.1.0'
  pod 'EzPopup', '1.2.4'
  pod 'Kingfisher', '~> 7.0'
  pod 'Amplitude', '~> 8.8.0'
end

target 'RoutesApp_ios' do
  shared_pods

  target 'RoutesApp_iosTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

target 'RoutesApp_ios Prod' do
  shared_pods
end  


