//
//  FyGetUserInfoRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyGetUserInfoRequest.h"

@implementation FyGetUserInfoRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_UserCenter;
}

- (NSDictionary *)params {
    //vest 马甲版本
    return @{@"userId":@([FyUserCenter sharedInstance].uId),@"vest":@"4"};
}

- (Class)objectClass {
    return [FyUserInfoV2 class];
}

@end
