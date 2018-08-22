


//
//  YMApproveManager.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/2/5.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMApproveManager.h"
#import "FyAuthCenterRequest.h"
#import "YMProgressViewController.h"
#import "LEEAlertManager.h"

@implementation YMApproveManager

- (void)loadAprroveData: (UIViewController *)vc block:(YMApproveSuccessBlock)block {
    self.stateModel = nil;
    self.vc = nil;
    self.vc = vc;
    self.successBlock = block;
    [self.vc showGif];
    FyAuthCenterRequest *task = [[FyAuthCenterRequest alloc] init];
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [weakSelf.vc hideGif];
        weakSelf.stateModel = model;
        [weakSelf configData:block];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [weakSelf.vc hideGif];
        if (error.errorCode == NSURLErrorCancelled) {
        }else{
            [vc fy_toastMessages:error.errorMessage];
        }
    }];
}

- (void)configData:(YMApproveSuccessBlock)block {
    self.vcTitle = [NSString stringWithFormat:@"%ld/3",[self getCompletedApproveNumber] + 1];
    self.approveStep = [self getYMApproveManagerStep];
    
//    认证完成,直接返回到YMEvaluateViewController
    if (self.approveStep == FyAproveStepNone) {
        if ([LEEAlertManager sharedManager].successBlock) {
            [LEEAlertManager sharedManager].successBlock();
        }
        if ([self.vc isKindOfClass:[YMProgressViewController class]]) {
            return;
        }
        
        for (UIViewController *temp in self.vc.navigationController.viewControllers) {
            if ([temp isKindOfClass:[YMProgressViewController class]]) {
                [self.vc.navigationController popToViewController:temp animated:YES];
            }
        }
        return;
    }
    
    UIViewController *v = [FyApproveStepUtil approveStepViewControllerWithStep:self.approveStep autoNext:YES title:self.vcTitle];
    [self.vc.navigationController pushViewController:v animated:YES];
    if (![self.vc isKindOfClass:[YMProgressViewController class]]) {
        [self.vc removeSelfWhenPushToNext];
    }
}

- (FyFyApproveStep)getYMApproveManagerStep {
    if (_stateModel.auth.auth.idState != AuthStateTypePass) {
        return FyApproveStepTureName;
    }
    
//    if (_stateModel.auth.auth.zhimaState != AuthStateTypePass) {
//        return FyAproveStepZhiMa;
//    }
    
    if (_stateModel.auth.auth.phoneState != AuthStateTypePass) {
        return FyAproveStepOperator;
    }
    
    if (_stateModel.auth.auth.contactState != AuthStateTypePass) {
        return FyAproveStepContact;
    }
    
    return FyAproveStepNone;
}

//获取已完成认证流程数量
- (NSInteger)getCompletedApproveNumber {
    NSInteger i = 0;
    //实名认证
    if (_stateModel.auth.auth.idState == AuthStateTypePass) {
        i++;
    }
//    //芝麻信用
//    if (_stateModel.auth.auth.zhimaState == AuthStateTypePass) {
//        i++;
//    }
    //运营商
    if (_stateModel.auth.auth.phoneState == AuthStateTypePass || _stateModel.auth.auth.phoneState == AuthStateTypeWait) {
        i++;
    }
    //紧急联系人
    if (_stateModel.auth.auth.contactState == AuthStateTypePass) {
        i++;
    }
    
    return i;
}

@end
