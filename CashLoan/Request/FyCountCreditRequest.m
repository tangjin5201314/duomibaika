//
//  FyCountCreditRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/12/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyCountCreditRequest.h"
#import "FyLoanPremiseModelV2.h"

@implementation FyCountCreditRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_COUNT_CREDIT;
}

- (Class)objectClass{
    return [FyLoanPremiseModelV2 class];
}

- (NSDictionary *)params{
    return @{@"coordinate": self.coordinate ?: @""};
}

@end
