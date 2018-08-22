//
//  FyModifyPayPwdRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyModifyPayPwdRequest.h"
#import "NSString+fyBase64.h"

@implementation FyModifyPayPwdRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_SETTRADEPWD;
}

- (NSDictionary *)params{ //请求参数
    NSAssert(self.pwd, @"pwd不能为空");
    NSAssert(self.oldPwd, @"oldPwd不能为空");

    return @{@"newPwd":[self.pwd md5String], @"oldPwd":[self.oldPwd md5String],@"loginName":[FyUserCenter sharedInstance].userName,@"changeType":@"2"};
}


@end
