//
//  FyLoginStatRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/26.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoginStatRequest.h"

@implementation FyLoginStatRequest

- (NSString *)urlPath{
    return URL_LOGINSTAT;
}

- (NSDictionary *)params{
    return @{@"name":@"appstore",@"code":@"bd0100130001",@"phoneType":@(2)};
}

@end
