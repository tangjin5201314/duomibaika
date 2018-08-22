//
//  FyLoanApplyRequestV2.h
//  CashLoan
//
//  Created by fyhy on 2017/12/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyLoanApplyRequestV2 : FyBaseRequest
@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSString *phoneModel;
@property (nonatomic, copy) NSString *phoneMemory;
@property (nonatomic, copy) NSString *coordinate; //经纬度
@property (nonatomic, copy) NSString *principal; //借款本金
@property (nonatomic, assign) NSInteger peroidValue; //借款期限
@property (nonatomic, copy) NSString *tradePwd; //借款密码
@property (nonatomic, assign) NSInteger calculateMode; //借款期限
@property (nonatomic, copy) NSString *loanUsage; //借款本金
@end
