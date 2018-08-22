//
//  FyRepayHistoryRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRepayHistoryRequest.h"

@implementation FyRepayHistoryRequest

- (NSString *)urlPath{
    return URLPATH_REPAYHISTORY;
}

- (NSDictionary *)params{ //请求参数
    return @{@"current":@(self.current), @"pageSize":@(self.pageSize), @"borrowId": self.borrowID};
}

- (Class)objectClass{
    return [FyRepayListModel class];
}


@end
