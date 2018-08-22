//
//  FyRootTabBarViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/11/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRootTabBarViewController.h"
#import "FyHomeViewController.h"
#import "FyLoanHistoryViewController.h"
#import "FyUserCenterMotherViewController.h"
#import "FyHomeViewControllerV2.h"
#import "FyLoginUtil.h"
#import "EventHanlder.h"
#import "FYCustomerService.h"
#import "FyLoginStatRequest.h"
#import "YMMineCenterViewController.h"

@interface FyRootTabBarViewController ()<UITabBarControllerDelegate>{
    FyBaseNavigationController *homeNav;
//    FyBaseNavigationController *loanHistoryNav;
    FyBaseNavigationController *mineNav;
    BOOL hasLogout;
}

@end

@implementation FyRootTabBarViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logout{
    [EventHanlder login:nil];
    [[FYCustomerService defaultService] logout];
    
    [self popToRootVCWithNavigationController:homeNav];
//    [self popToRootVCWithNavigationController:loanHistoryNav];
    [self popToRootVCWithNavigationController:mineNav];

    [[FyUserCenter sharedInstance] cleanUp];
    //    [[FyUserCenter sharedInstance]save];
    [FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self];
}

- (void)popToRootVCWithNavigationController:(UINavigationController *)nav{
    if (nav.presentedViewController) {
        [nav.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    [nav popToRootViewControllerAnimated:NO];

}

- (void)uploadStatistics {
    FyLoginStatRequest *t = [[FyLoginStatRequest alloc] init];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:nil failure:nil];
}


- (void)loginSuccess{
    [EventHanlder login:[FyUserCenter sharedInstance].userId];
    //    [self uploadStatistics];
    hasLogout = NO;
}

//借款成功，回到首页
- (void)loanSuccess{
    self.selectedViewController = homeNav;

}

-(void)filterErrorType:(NSNotification*)notification{
    FyResponse *error = notification.userInfo[@"error"];

    if (error.errorCode == RDP2PAppErrorTypeRefreshTokenTimeOut ||
        error.errorCode == RDP2PAppErrorTypeTokenNoExist ||
        error.errorCode == RDP2PAppErrorTypeUserInfoNoExist ||
        error.errorCode == RDP2PAppErrorTypeLoginError ||
        error.errorCode == RDP2PAppErrorTypeRefreshTokenNoExist ||
        error.errorCode == RDP2PAppErrorTypeIllegalLogin ||
        error.errorCode == RDP2PAppErrorTypeIllegalRequest ||
        error.errorCode == RDP2PAppErrorTypeUserVerificationFailed){
        if (hasLogout) return;
        hasLogout = YES;
        if (error.errorCode == RDP2PAppErrorTypeRefreshTokenTimeOut) {
            [self fy_toastMessages:@"登录已过期，请重新登录"];
        }else{
            [self fy_toastMessages:error.errorMessage];
        }
        [self logout];
    }else if (error.errorCode == RDP2PAppErrorTypeLoginOtherClient){
        [[FyUserCenter sharedInstance] cleanUp];
        if (hasLogout) return;
        hasLogout = YES;
        
        [self fyShowAletWithContent:@"您的账号在其他设备上登录，请重新登录" left:@"取消" right:@"重新登录" leftClick:^{
            [self logout];
        } rightClick:^{
            [self logout];
        }];
    }
    else if (error.errorCode != RDP2PAppErrorTypeYYSuccess && error.errorCode != NSURLErrorCancelled){
        [self fy_toastMessages:error.errorMessage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:FYNOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:FYNOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterErrorType:) name:NOTICE_AppErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loanSuccess) name:FYNOTIFICATION_LOAN object:nil];

    
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = [UIColor textColor];
    [self loadViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadViewControllers{
    FyHomeViewControllerV2 *homeVC = [[FyHomeViewControllerV2 alloc] init];
//    FyLoanHistoryViewController *loanHistoryVC = [[FyLoanHistoryViewController alloc] init];
//    FyUserCenterMotherViewController *mineVC = [FyUserCenterMotherViewController loadFromStoryboardName:@"FyMineStoryboard" identifier:nil];
    YMMineCenterViewController *mineVC = [[YMMineCenterViewController alloc] init];
    homeNav = [[FyBaseNavigationController alloc] initWithRootViewController:homeVC];
//    loanHistoryNav = [[FyBaseNavigationController alloc] initWithRootViewController:loanHistoryVC];
    mineNav = [[FyBaseNavigationController alloc] initWithRootViewController:mineVC];
    
    homeNav.title = @"租赁";
    [homeNav.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_loan_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [homeNav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_loan_up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    loanHistoryNav.title = @"账单";
//    [loanHistoryNav.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_bill_down"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [loanHistoryNav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_bill_up"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//
    mineNav.title = @"我的";
    [mineNav.tabBarItem setImage:[[UIImage imageNamed:@"tabbar_my_down"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [mineNav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabbar_my_up"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    homeVC.hidesBottomBarWhenPushed = NO;
//    loanHistoryVC.hidesBottomBarWhenPushed = NO;
    mineVC.hidesBottomBarWhenPushed = NO;
    
//    self.viewControllers = @[homeNav, loanHistoryNav, mineNav];
    self.viewControllers = @[homeNav, mineNav];

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //    if (viewController == loanHistoryNav) {
    //        return [FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self];
    //
    //    }
    return YES;
}

- (void)selectLoandHistory{
//    self.selectedViewController = loanHistoryNav;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
