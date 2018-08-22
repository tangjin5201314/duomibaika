//
//  FyApproveStepUtil.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveStepUtil.h"
#import "FyApproveTrueNameViewController.h"
#import "FyApproveZhiMaViewController.h"
#import "FyApproveOperatorViewController.h"
#import "FyApproveContactsViewController.h"
#import "YMProgressViewController.h"

@implementation FyApproveStepUtil

+ (UIViewController<FyApproveViewControllerDelegate> *)approveStepViewControllerWithStep:(FyFyApproveStep)step autoNext:(BOOL)autoNext{
    UIViewController<FyApproveViewControllerDelegate> *vc = nil;
    if (step == FyApproveStepTureName) {
        vc = [FyApproveTrueNameViewController loadFromStoryboardName:@"FyApproveCenterStoryboard" identifier:nil];
    }else if (step == FyAproveStepZhiMa){
        vc = [[FyApproveZhiMaViewController alloc] init];
    }else if (step == FyAproveStepOperator){
        vc = [[FyApproveOperatorViewController alloc] init];
    }else if (step == FyAproveStepContact){
        vc = [FyApproveContactsViewController loadFromStoryboardName:@"FyApproveCenterStoryboard" identifier:nil];

    }
    vc.autoNext = autoNext;

    autoNext = YES;
    if (autoNext) {
        __weak typeof(vc) weakVC = vc;
        vc.tipAction = ^{
            [weakVC LPShowAletWithTitle:@"您确认要退出认证流程？" Content:@"" left:@"确认" right:@"继续认证" leftClick:^{
                [weakVC.navigationController popViewControllerAnimated:YES];
            } rightClick:^{
            } ];
            return NO;
        };
        vc.fy_navigationBarLineColor = [UIColor clearColor];
    }

    return vc;
}

+ (UIViewController<FyApproveViewControllerDelegate> *)approveStepViewControllerWithStep:(FyFyApproveStep)step autoNext:(BOOL)autoNext title:(NSString *)title {
    UIViewController<FyApproveViewControllerDelegate> *vc = nil;
    if (step == FyApproveStepTureName) {
        vc = [FyApproveTrueNameViewController loadFromStoryboardName:@"FyApproveCenterStoryboard" identifier:nil];
        vc.title = [NSString stringWithFormat:@"实名认证(%@)",title];
    }else if (step == FyAproveStepZhiMa){
        vc = [[FyApproveZhiMaViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"芝麻认证(%@)",title];
    }else if (step == FyAproveStepOperator){
        vc = [[FyApproveOperatorViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"运营商认证(%@)",title];
    }else if (step == FyAproveStepContact){
        vc = [FyApproveContactsViewController loadFromStoryboardName:@"FyApproveCenterStoryboard" identifier:nil];
        vc.title = [NSString stringWithFormat:@"联系方式认证(%@)",title];
    }
    vc.autoNext = autoNext;
    autoNext = YES;
    if (autoNext) {
        __weak typeof(vc) weakVC = vc;
        vc.tipAction = ^{
            [weakVC LPShowAletWithTitle:@"您确认要退出认证流程？" Content:@"" left:@"确认" right:@"继续认证" leftClick:^{
                for (UIViewController *temp in weakVC.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[YMProgressViewController class]]) {
                        [weakVC.navigationController popToViewController:temp animated:YES];
                    }
                }
            } rightClick:^{
            } ];
            return NO;
        };
        vc.fy_navigationBarLineColor = [UIColor clearColor];
    }
    
    return vc;
}


+ (UIViewController *)approveCenterViewController{
    FyApproveCenterViewController *approveCenter = [FyApproveCenterViewController loadFromStoryboardName:@"FyApproveCenterStoryboard" identifier:nil];
    return approveCenter;
}

@end
