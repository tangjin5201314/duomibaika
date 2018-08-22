//
//  FyApplyLoanModelV2.m
//  CashLoan
//
//  Created by fyhy on 2017/11/22.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApplyLoanModelV2.h"

@implementation FyApplyLoanModelV2

- (FyBankCardModelV2 *)bank{
    if (!_bank) {
        _bank = [[FyBankCardModelV2 alloc] init];
    }
    return _bank;
}

@end
