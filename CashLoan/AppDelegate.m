//
//  AppDelegate.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "AppDelegate.h"
#import "FyHomeViewController.h"
#import <MGBaseKit/MGBaseKit.h>
#import <MGLivenessDetection/MGFaceQualityManager.h>
#import <AMapFoundationKit/AMapServices.h>
//#import <UMMobClick/MobClick.h>
#import "FMDeviceManager.h"
#import "EventHanlder.h"
//#import "FYShareUtil.h"
//#import "FYApnsUtil.h"
#import "FYCustomerService.h"
#import "FYPopupManger.h"
#import "FrontView.h"
#import "FyFirstStartRequest.h"
#import "AppDelegate+LPAdvertisement.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "FyRootTabBarViewController.h"
#import "YMHomeShowAlertManager.h"

@interface AppDelegate ()<FrontViewDelegate>

@end

@implementation AppDelegate

- (void)configTongDun{
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    // 准备SDK初始化参数
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
   //
    /*
     * SDK具有防调试功能，当使用xcode运行时(开发测试阶段),请取消下面代码注释，
     * 开启调试模式,否则使用xcode运行会闪退。上架打包的时候需要删除或者注释掉这
     * 行代码,如果检测到调试行为就会触发crash,起到对APP的保护作用
     */
#ifdef DEBUG
//    // 上线Appstore的版本，请记得删除此行，否则将失去防调试防护功能！
     [options setValue:@"allowd" forKey:@"allowd"];  // TODO
//
//    // 指定对接同盾的测试环境，正式上线时，请删除或者注释掉此行代码，切换到同盾生产环境
    [options setValue:@"sandbox" forKey:@"env"]; // TODO
#endif
    // 此处已经替换为您的合作方标识了
    [options setValue:@"gongying" forKey:@"partner"];
    // 使用上述参数进行SDK初始化
    manager->initWithOptions(options);
    
}

#pragma mark ---配置高德地图-----
- (void)configAmap{
    [[AMapServices sharedServices] setApiKey:AMapID];
}

#pragma mark ---配置face+++-----
- (void)configFacePlusPlus{
    [MGLicenseManager licenseForNetWokrFinish:^(bool License) {
        NSLog(@"MGLicenseManager == %@",License ? @"\n============\nFace++激活成功\n==========" : @"\n==========\nFace++激活失败\n==========");
    }];
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

/**
 * 配置友盟统计
 */
//- (void)configUMClick {
//    UMConfigInstance.appKey = UMKey;
//    UMConfigInstance.channelId = @"App Store";
//    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
//}

- (void)removeBadge{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)uploadStatistics { //初次打开统计
    FyFirstStartRequest *t = [[FyFirstStartRequest alloc] init];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:nil failure:nil];
}

#pragma mark --- 显示引导页----
- (void)showUserGuideIfNeed{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first"] == nil) {
        FrontView *frontView = [[FrontView alloc]init];
        frontView.imagesName = @[@"youmi1", @"youmi2"];
        frontView.autoDismissAnimation = ForntViewAnimationTypeFromRight;
        frontView.delegate = self;
        frontView.showPageControl = NO;
        [frontView show];
        frontView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        frontView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
//        [self uploadStatistics];
    }else{
        [FYPopupManger sharedInstance].guideReady = YES;
    }
}

- (void)loadHomeVC{
    FyRootTabBarViewController *vc = [[FyRootTabBarViewController alloc] init];
    self.window.rootViewController = vc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //兼容ios11 scrollView 偏移问题，
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [FyNetworkManger sharedInstance].useProductionServer = YES;
#ifdef DEBUG
    [FyNetworkManger sharedInstance].useProductionServer = NO;
#endif

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kInView: @(YES)}];

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    检查是否有更新
    [[FYPopupManger sharedInstance] requestCheckUpdate];
//去掉边角数字提示
    [self removeBadge];
//    配置友盟
//    [self configUMClick];

//    神策统计
//    [EventHanlder configSensorsAnalytics]; //神策统计
//    分享初始化
//    [FYShareUtil config]; //分享初始化
//    注册apns
//    [self registerRemoteNotification];
//    配置极光推送
//    [[FYApnsUtil shareApnsUtil] configWithOptions:launchOptions]; //推送
//    暂时没用
//    [[FYCustomerService defaultService] config];
//    设置hud 显示时长
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
//    配置face++
    [self configFacePlusPlus];
//    加载主控制器
    [self loadHomeVC];
//    配置高德地图
    [self configAmap];
//    配置同盾
    [self configTongDun];
//    显示引导页
    [self showUserGuideIfNeed];
//    设置广告
//    [self setupAdvert];
    return YES;
}

/** 远程通知注册成功委托 */
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    [[FYApnsUtil shareApnsUtil] registerDeviceToken:deviceToken];
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
//}

#pragma mark --- frontView.delegate
-(void)frontView:(FrontView *)frontView clickedPage:(NSInteger)currentPage isLastPage:(BOOL)last{
    if (last) {
        [frontView dismiss:ForntViewAnimationTypeGradual];
        [FYPopupManger sharedInstance].guideReady = YES;
    }
}

-(void)frontView:(FrontView *)frontView didScrollToPage:(NSInteger)currentPage isLastPage:(BOOL)last {
    if (last) {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"first"];
        [FYPopupManger sharedInstance].guideReady = YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self removeBadge];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier{
    return NO;
}


@end
