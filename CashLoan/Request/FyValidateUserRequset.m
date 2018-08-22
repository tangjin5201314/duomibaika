//
//  FyValidateUserRequset.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyValidateUserRequset.h"

@implementation FyValidateUserRequset

- (NSString *)urlPath{
    return URLPATH_VALIDATAUSER;
}

- (NSDictionary *)params{ //请求参数
    NSAssert(self.iDCard, @"iDCard不能为空");
    NSAssert(self.realName, @"realName不能为空");
    NSAssert(self.vcode, @"vcode不能为空");

    return @{@"idNo":self.iDCard, @"realName":self.realName, @"vcode":self.vcode};
}


- (Class)objectClass{
    return [NSDictionary class];
}

@end
