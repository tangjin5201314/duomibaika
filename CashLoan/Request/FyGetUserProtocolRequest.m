//
//  FyGetUserProtocolRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyGetUserProtocolRequest.h"
#import "FyProtocolListModel.h"

@implementation FyGetUserProtocolRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_USERPROCOL;
}

//- (NSString *)mothod{
//    return @"GET";
//}

- (NSDictionary *)params {
    //protocol_register_原始的链接
    //protocol_vestone_register_马甲1的链接
    return @{@"userId":[FyUserCenter sharedInstance].userId ? [FyUserCenter sharedInstance].userId : @"",@"code":@"protocol_vestone_register_"};
}

- (Class)objectClass{
    return [FyProtocolListModel class];
}


@end
