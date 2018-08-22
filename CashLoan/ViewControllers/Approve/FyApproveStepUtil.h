//
//  FyApproveStepUtil.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FyApproveViewControllerDelegate.h"
#import "FyApproveCenterViewController.h"

typedef enum : NSUInteger {
    FyApproveStepTureName = 0, //实名认证
    FyAproveStepZhiMa = 1, //芝麻认证
    FyAproveStepOperator = 2, //运营商认证
    FyAproveStepContact = 3, //联系方式认证
    FyAproveStepNone = 4, //认证完成

} FyFyApproveStep;

@interface FyApproveStepUtil : NSObject

+ (UIViewController<FyApproveViewControllerDelegate> *)approveStepViewControllerWithStep:(FyFyApproveStep)step autoNext:(BOOL)autoNext;
+ (UIViewController<FyApproveViewControllerDelegate> *)approveStepViewControllerWithStep:(FyFyApproveStep)step autoNext:(BOOL)autoNext title:(NSString *)title;

+ (UIViewController *)approveCenterViewController;

@end
