//
//  FyLoanHistoryRequestV2.m
//  CashLoan
//
//  Created by fyhy on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanHistoryRequestV2.h"

@implementation FyLoanHistoryRequestV2

- (NSString *)serviceCode{
    return API_SERVICE_CODE_ORDER_FINDORDERLIST;
}

- (NSDictionary *)params{ //请求参数
    return @{@"current":@(self.current), @"pageSize":@(self.pageSize)};
}

- (Class)objectClass{
    return [FyLoanLogListModelV2 class];
}


@end
