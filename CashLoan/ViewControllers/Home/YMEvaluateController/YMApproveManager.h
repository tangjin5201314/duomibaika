//
//  YMApproveManager.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/2/5.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyLoanPremiseModelV2.h"
#import "FyApproveStepUtil.h"


typedef void(^YMApproveSuccessBlock)(BOOL ret);

@interface YMApproveManager : NSObject

@property (nonatomic, strong) FyLoanPremiseModelV2 *stateModel;

//跳转vc的title
@property (nonatomic, copy) NSString *vcTitle;
//跳转vc的步骤
@property (nonatomic, assign) FyFyApproveStep approveStep;

@property (nonatomic, assign) YMApproveSuccessBlock successBlock;

//接收跳转的vc
@property (nonatomic, strong) UIViewController *vc;

- (void)loadAprroveData: (UIViewController *)vc block:(YMApproveSuccessBlock)block;
- (void)configData:(YMApproveSuccessBlock)block;
@end
