//
//  FyBankRemarkRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBankModelRequest.h"
#import "BankCardModel.h"

@implementation FyBankModelRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_GET_USER_BANKCARD;
}

- (Class)objectClass{
    return [BankCardModel class];
}


@end
