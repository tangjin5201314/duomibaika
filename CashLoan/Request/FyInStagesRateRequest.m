//
//  FyInStagesRateRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/12/8.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyInStagesRateRequest.h"

@implementation FyInStagesRateRequest

- (NSDictionary *)params{
    return @{@"principal": self.principal, @"peroidValue":self.peroidValue, @"calculateMode":@(self.calculateMode)};
}

- (NSString *)serviceCode{
    return API_SERVICE_CODE_ORDER_PREVIEWORDER;
}

- (Class)objectClass{
    return [FyInStagesRateModel class];
}


@end
