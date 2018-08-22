//
//  FyApproveGetZhiMaUrlRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveGetZhiMaUrlRequest.h"

@implementation FyApproveGetZhiMaUrlRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_ZHIMA_AUTHORIZE;
}

- (Class)objectClass{
    return [FyApproveUrlModel class];
}


@end
