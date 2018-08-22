#source 'http://git.rd.com/mobility-ios/RdSpecs.ios.git' #私有仓库地址（源文件）
#source 'https://github.com/CocoaPods/Specs.git' #官方仓库地址

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
    end
end

platform:ios, '9.0'
inhibit_all_warnings!
use_frameworks! 


target 'CashLoan' do  #工程名称
    pod 'SensorsAnalyticsSDK', :inhibit_warnings => true
    #  pod 'UMengUShare/Social/WeChat', :inhibit_warnings => true
    #   pod '65UShare/Social/QQ', :inhibit_warnings => true

    #三方开源
    pod 'IQKeyboardManager', :inhibit_warnings => true
    pod 'SVProgressHUD','2.0', :inhibit_warnings => true
    pod 'SDWebImage', :inhibit_warnings => true
    pod 'FMDB', :inhibit_warnings => true
    pod 'MJRefresh', :inhibit_warnings => true
    pod 'LCActionSheet'

    #友盟统计
#    pod 'UMengAnalytics' , :inhibit_warnings => true
    #高德
#    pod 'AMap3DMap' , :inhibit_warnings => true
    pod 'AMapLocation', :inhibit_warnings => true
#    pod 'AMapSearch', :inhibit_warnings => true

    pod "MBProgressHUD", :inhibit_warnings => true
    pod 'MJExtension', :inhibit_warnings => true
#    pod 'JPush', '~>3.0.6', :inhibit_warnings => true


    #补充三方类库
    pod 'AFNetworking', :inhibit_warnings => true
#    pod 'DZNEmptyDataSet', :inhibit_warnings => true
    pod 'Masonry', :inhibit_warnings => true
    pod 'YYText', :inhibit_warnings => true
    pod 'YYCategories', :inhibit_warnings => true
    pod 'LLTokenPaySDK', :inhibit_warnings => true
#    pod 'Toast', '~> 3.1.0'



end


