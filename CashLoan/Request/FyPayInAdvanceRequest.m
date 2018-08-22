//
//  FyPayInAdvanceRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyPayInAdvanceRequest.h"

@implementation FyPayInAdvanceRequest

- (NSString *)urlPath{
    return URLPATH_PAYINADVANCE;
}


- (NSDictionary *)params{ //请求参数
    return @{@"borrowId": self.borrowID};
}


@end
