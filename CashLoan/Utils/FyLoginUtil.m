//
//  FyLoginUtil.m
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoginUtil.h"
#import "FyUserCenter.h"
//#import "FyLoginViewController.h"
#import "FyPhoneLoginViewController.h"

@implementation FyLoginUtil

+ (BOOL)showLoginViewControllerFromViewConrollerInNeeded:(UIViewController *)vc{ //返回yes如果不需要登录
    if (![FyUserCenter sharedInstance].isLogin) {
        //展示登录试图
        
//        FyLoginViewController *loginvc = [[FyLoginViewController alloc] init];
        FyPhoneLoginViewController *loginvc = [[UIStoryboard storyboardWithName:@"FyLoginStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"FyPhoneLoginViewController"];
        loginvc.phoneType = PhoneTypeLogin;
        FyBaseNavigationController *nav = [[FyBaseNavigationController alloc] initWithRootViewController:loginvc];
        [vc presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}

@end
