//
//  FySetLoanPwdRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

typedef NS_ENUM(NSInteger,PayPwdType){
    PayTypeSet = 1,
    PayTypeChange,
    PayTypeForget
};

@interface FySetLoanPwdRequest : FyBaseRequest

@property (nonatomic, copy) NSString *nPwd;
@property (nonatomic, copy) NSString *oPwd;
@property (nonatomic, assign) PayPwdType payType;
@property (nonatomic, copy) NSString *vcode;
@property (nonatomic, copy) NSString *bussinessType;



@end
