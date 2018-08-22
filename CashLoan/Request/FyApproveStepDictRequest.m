//
//  FyApproveStepDictRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveStepDictRequest.h"
#import "AuthDictListModel.h"

@implementation FyApproveStepDictRequest

- (NSString *)serviceCode{
    return API_SERVICE_GETDICTS;
}

- (Class)objectClass{
    return [AuthDictListModel class];
}

- (NSDictionary *)params{ //请求参数
    NSAssert(self.type, @"type不能为空");
    return @{@"type":self.type};
}


@end
