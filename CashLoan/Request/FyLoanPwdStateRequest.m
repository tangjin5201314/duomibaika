//
//  FyLoanPwdStateRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanPwdStateRequest.h"

@implementation FyLoanPwdStateRequest

- (NSString *)urlPath{
    return URLPATH_LOANPSDSTATE;
}

- (NSString *)mothod{
    return @"GET";
}

- (Class)objectClass{
    return [MineSettingModel class];
}

@end
