# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'

target 'MyHome' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
   use_frameworks!
  
  pod 'AFNetworking'
  pod 'SVProgressHUD'
  pod 'SDWebImage'
  pod 'IQKeyboardManager'
  pod 'JVFloatLabeledTextField'
  pod 'MARKRangeSlider'
  pod 'InfinitePagingView'
  pod 'CKCalendar'
#  pod 'SSKeychain'
  pod 'CCDropDownMenus'
  pod 'AAChartKit'
  pod 'RateView'
  pod 'CircleProgressBar'
  pod 'ELCImagePickerController'
  pod 'ionicons'
  pod 'UIBarButtonItem-Badge-Coding'
#  pod 'Google-Mobile-Ads-SDK'
#  pod 'GLCalendarView'
  # Pods for MyHome
  
end


post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
