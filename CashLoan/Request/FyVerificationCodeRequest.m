//
//  FyVerificationCodeRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyVerificationCodeRequest.h"

@implementation FyVerificationCodeRequest

- (NSDictionary *)params{ //请求参数
    NSAssert(self.phone, @"手机号不能为空");
    NSAssert(self.type, @"验证码类型不能为空");
    NSAssert(self.businessType, @"businessType == 业务类型");

    return @{@"phone":self.phone, @"type":self.type, @"businessType":self.businessType};
}

- (NSString *)serviceCode{
    return API_SERVICE_CODE_FETCHSMSCODE;
}

- (Class)objectClass{
    return [FyVerificationCodeModel class];
}


@end
