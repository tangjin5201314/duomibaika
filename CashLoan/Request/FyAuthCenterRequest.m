//
//  FyAuthCenterRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/12/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyAuthCenterRequest.h"
#import "FyLoanPremiseModelV2.h"

@implementation FyAuthCenterRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_CENTRE_AUTH_INFO;
}

- (Class)objectClass{
    return [FyLoanPremiseModelV2 class];
}


@end
