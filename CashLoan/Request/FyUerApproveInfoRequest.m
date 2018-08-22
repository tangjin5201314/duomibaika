//
//  FyUerApproveInfoRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUerApproveInfoRequest.h"

@implementation FyUerApproveInfoRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_GET_USER_INFO;
}

- (Class)objectClass{
    return [FyApproveInfoModel class];
}

@end
