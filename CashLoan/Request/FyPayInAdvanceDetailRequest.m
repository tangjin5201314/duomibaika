//
//  FyPayInAdvanceDetailRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyPayInAdvanceDetailRequest.h"

@implementation FyPayInAdvanceDetailRequest

- (NSString *)urlPath{
    return URLPATH_PAYINADVANCEDETAIL;
}


- (NSDictionary *)params{ //请求参数
    return @{@"borrowId": self.borrowID};
}

- (Class)objectClass{
    return [FyPayInAdvanceDetailModel class];
}


@end
