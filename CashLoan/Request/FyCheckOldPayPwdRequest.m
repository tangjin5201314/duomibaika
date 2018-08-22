//
//  FyCheckOldPayPwdRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyCheckOldPayPwdRequest.h"
#import "NSString+fyBase64.h"

@implementation FyCheckOldPayPwdRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_CHECKOLDPWD;
}

- (NSDictionary *)params{ //请求参数
    NSAssert(self.pwd, @"pwd不能为空");
    return @{@"loginName":[FyUserCenter sharedInstance].userName,@"oldPwd":[self.pwd md5String],@"changeType":@"2"};
}


@end
