//
//  FyFirstStartRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/25.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyFirstStartRequest.h"

@implementation FyFirstStartRequest

- (NSString *)urlPath{
    return URL_FIRSTSTART;
}

- (NSDictionary *)params{
    return @{@"name":@"appstore",@"code":@"bd0100130001",@"phoneType":@(2)};
}

@end
