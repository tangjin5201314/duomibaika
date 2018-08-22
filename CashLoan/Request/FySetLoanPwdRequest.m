//
//  FySetLoanPwdRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FySetLoanPwdRequest.h"
#import "NSString+fyBase64.h"

@implementation FySetLoanPwdRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_SETTRADEPWD;
}

- (NSDictionary *)params{ //请求参数
    
    NSDictionary *dict;
    switch (self.payType) {
        case PayTypeSet:
        {
            dict = @{@"newPwd":[self.nPwd md5String],@"changeType":@(1), @"loginName":[FyUserCenter sharedInstance].userName};

        }
            break;
        case PayTypeChange:
        {
            dict = @{@"newPwd":[self.nPwd md5String],@"oldPwd":[self.oPwd md5String], @"changeType":@(2), @"loginName":[FyUserCenter sharedInstance].userName};

        }
            break;
        case PayTypeForget:
        {
            dict = @{@"newPwd":[self.nPwd md5String], @"changeType":@(3), @"loginName":[FyUserCenter sharedInstance].userName,@"vcode":self.vcode,@"businessType":self.bussinessType};

        }
            break;
        default:
            break;
    }

    return dict;
}



@end
