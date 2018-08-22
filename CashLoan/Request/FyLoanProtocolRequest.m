//
//  FyLoanProtocolRequest.m
//  CashLoan
//
//  Created by fyhy on 2018/1/4.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "FyLoanProtocolRequest.h"

@implementation FyLoanProtocolRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_USERPROCOL;
}

- (NSDictionary *)params {
    if (self.orderId) {
        return @{@"userId":[FyUserCenter sharedInstance].userId ? [FyUserCenter sharedInstance].userId : @"",@"code":@"protocol_loan_", @"orderId": self.orderId};
    }else{
        return @{@"userId":[FyUserCenter sharedInstance].userId ? [FyUserCenter sharedInstance].userId : @"",@"code":@"protocol_loan_"};
    }
}

- (Class)objectClass{
    return [FyProtocolListModel class];
}


@end
