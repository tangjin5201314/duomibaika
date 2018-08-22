
//
//  YMBuyOutNotifyRequest.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/2/26.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMBuyOutNotifyRequest.h"

@implementation YMBuyOutNotifyRequest
- (NSString *)serviceCode{
    return ACTIVE_REPAY_NOTIFY_SYNC;
}

- (NSDictionary *)params {
    return @{
             @"orderId" : CHECKNULL(self.orderId),
             @"resultPay": CHECKNULL(self.resultPay),
             @"returnParams": CHECKNULL(self.returnParams),
             @"orderNo": CHECKNULL(self.orderNo),
             };
}

- (Class)objectClass{
    return [NSDictionary class];
}
@end
