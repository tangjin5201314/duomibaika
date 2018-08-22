//
//  FyLoanApplyRequestV2.m
//  CashLoan
//
//  Created by fyhy on 2017/12/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanApplyRequestV2.h"
#import "NSString+fyBase64.h"

@implementation FyLoanApplyRequestV2

- (NSString *)serviceCode{
    return API_SERVICE_CODE_ORDER_SAVEORDER;
}

- (NSDictionary *)params{
    return @{
             @"coordinate":CHECKNULL(self.coordinate),
             @"principal":CHECKNULL(self.principal),
             @"peroidValue":@(self.peroidValue),
             @"tradePwd":[self.tradePwd md5String],
             @"calculateMode":@(self.calculateMode),
             @"loanUsage":self.loanUsage,
             @"udid": CHECKNULL(self.udid),
             @"phoneModel": CHECKNULL(self.phoneModel),
             @"phoneMemory": CHECKNULL(self.phoneMemory)
             };
}

@end
