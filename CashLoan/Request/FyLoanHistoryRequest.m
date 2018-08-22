//
//  FyLoanHistoryRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanHistoryRequest.h"

@implementation FyLoanHistoryRequest

- (NSString *)urlPath{
    return URLPATH_LOANHISTORY;
}

- (NSDictionary *)params{ //请求参数
    return @{@"current":@(self.current), @"pageSize":@(self.pageSize)};
}

- (Class)objectClass{
    return [FyLoanLogListModel class];
}

@end
