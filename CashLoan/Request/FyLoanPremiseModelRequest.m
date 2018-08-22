//
//  FyLoanPremiseModelRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/12/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanPremiseModelRequest.h"
#import "FyLoanPremiseModelV2.h"

@implementation FyLoanPremiseModelRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_HOMEINDEX;
}

- (Class)objectClass{
    return [FyLoanPremiseModelV2 class];
}


@end
