
//
//  YMBuyOutRequest.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/2/26.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMBuyOutRequest.h"

@implementation YMBuyOutRequest
- (NSString *)serviceCode{
    return ACTIVE_REPAY;
}

- (NSDictionary *)params {
    return @{
             @"orderId" : CHECKNULL(self.orderId)
             };
}

- (Class)objectClass{
    return [NSDictionary class];
}
@end
