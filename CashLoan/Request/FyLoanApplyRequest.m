//
//  FyLoanApplyRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanApplyRequest.h"
#import "GetIpAddress.h"
#import "NSString+fyAdd.h"
#import "NSString+fyBase64.h"

@implementation FyLoanApplyRequest

- (NSDictionary *)params{
    NSString *ipStr = [[GetIpAddress getIPAddresses] objectForKey:@"en0/ipv4"];

    return @{@"address": SAFESTRING(self.address), @"coordinate":SAFESTRING(self.self.coordinate), @"amount":self.amount, @"cardId":self.cardId, @"fee":self.fee, @"realAmount":self.realAmount, @"timeLimit":self.timeLimit, @"tradePwd":[self.tradePwd md5String], @"userId":self.userId, @"client":@"10", @"ip":ipStr};
}

- (NSString *)urlPath{
    return URL_LOADAPPLY;
}


@end
