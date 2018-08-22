

//
//  YMHistoryOrderRequest.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/31.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMHistoryOrderRequest.h"
#import "YMTool.h"
@implementation YMHistoryOrderRequest
- (NSString *)serviceCode{
    return ORDER_HISTORYPHONE;
}

- (NSDictionary *)params {
    return @{
             @"udid" : CHECKNULL([YMTool getUdid])
             };
}

- (Class)objectClass{
    return [NSDictionary class];
}
@end
