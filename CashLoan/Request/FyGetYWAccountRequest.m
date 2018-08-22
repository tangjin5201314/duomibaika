//
//  FyGetYWAccountRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyGetYWAccountRequest.h"

@implementation FyGetYWAccountRequest

- (NSString *)urlPath{
    return URLPATH_YWUSERINFO;
}

- (NSDictionary *)params{ //请求参数
    return @{@"userId":self.userId};
}

- (Class)objectClass{
    return [NSDictionary class];
}


@end
