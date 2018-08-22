//
//  FySaveBankCardRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FySaveBankCardRequest.h"

@implementation FySaveBankCardRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_BIND_BANK_CARD;
}

- (NSDictionary *)params{ //请求参数
    return @{@"cardNo": self.cardNO, @"bank":self.bank, @"bindMob":self.bindMob};
}

- (Class)objectClass{
    return [NSDictionary class];
}

@end
