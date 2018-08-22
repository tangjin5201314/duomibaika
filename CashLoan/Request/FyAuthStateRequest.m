//
//  FyAuthStateRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyAuthStateRequest.h"
#import "FyLoanPremiseModelV2.h"

@implementation FyAuthStateRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_UserCenter;
}

- (Class)objectClass{
    return [FyLoanPremiseModelV2 class];
}


@end
