//
//  FyShareAppRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyShareAppRequest.h"

@implementation FyShareAppRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_SHARE;
}

//- (NSString *)mothod{
//    return @"GET";
//}

//- (NSDictionary *)params {
//    return  @{@"serviceCode":@"SHARE_LINK"};
//
//}

- (Class)objectClass{
    return [NSDictionary class];
}

@end
