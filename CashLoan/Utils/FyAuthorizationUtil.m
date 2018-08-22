//
//  FyAuthorizationUtil.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyAuthorizationUtil.h"

@implementation FyAuthorizationUtil

+ (void)canReadCameraWithBlock:(FyCameraBlock)block{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        if (block) {
            block(NO, authStatus);
        }
    }else if(authStatus ==AVAuthorizationStatusNotDetermined){
        if (block) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = granted ? AVAuthorizationStatusAuthorized : AVAuthorizationStatusDenied;
                block(granted, status);

            }];
        }

    }else{
        if (block) {
            block(YES, authStatus);
        }
    }
}

+ (void)showRequestCameraTipFromViewController:(UIViewController *)viewController{
    if (viewController) {
        [viewController LPShowAletWithContent:[NSString stringWithFormat:@"请您设置允许%@访问您的相机",AppName] left:@"取消" right:@"去设置" rightClick:^{
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
            
        }];
    }
}



+ (void)canReadAddressBookWithBlock:(FyAddressBookBlock)block{
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, NULL), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted) {
                    //拒绝访问
                    block(NO,kABAuthorizationStatusDenied);
                }else{
                    block(YES,0);
                }
            });
        });
    }else if (authStatus == kABAuthorizationStatusAuthorized){
        block(YES,0);
    }else{
        block(NO,authStatus);
    }
}

+ (void)showRequestAddressBookTipFromViewController:(UIViewController *)viewController autoPop:(BOOL)pop{
    if (viewController) {
        [viewController LPShowAletWithTitle:[NSString stringWithFormat:@"请您设置允许%@访问您的通讯录",AppName] Content:@"" left:@"取消" right:@"去设置" leftClick:^{
            if (pop) {
                [viewController.navigationController popViewControllerAnimated:YES];
            }
        } rightClick:^{
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
            if (pop) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [viewController.navigationController popViewControllerAnimated:YES];
                });
            }
            
        }];
    }

}

+ (BOOL)allowLocation{
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusNotDetermined) {
        return NO;
    }else if (authStatus == kCLAuthorizationStatusAuthorizedAlways || authStatus == kCLAuthorizationStatusAuthorizedWhenInUse){
        return YES;
    }else{
        return NO;
    }
}

+ (void)showRequestLoacationTipFromViewController:(UIViewController *)viewController autoPop:(BOOL)pop{
    if (viewController) {
        [viewController LPShowAletWithTitle:@"请开启定位功能" Content:@"" left:@"取消" right:@"去设置" leftClick:^{
            if (pop) {
                [viewController.navigationController popViewControllerAnimated:YES];
            }
            
        } rightClick:^{
            // 无权限 引导去开启
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
            
            if (pop) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [viewController.navigationController popViewControllerAnimated:YES];
                });
            }
            
        }];
    }

}

@end
