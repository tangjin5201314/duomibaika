//
//  FyUserInfoV2.m
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUserInfoV2.h"

@implementation FyUserInfoV2

-(FyBankCardModelV2 *)bank{
    if (!_bank) {
        _bank = [[FyBankCardModelV2 alloc] init];
    }
    return _bank;
}

@end
