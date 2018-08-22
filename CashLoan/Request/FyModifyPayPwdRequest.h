//
//  FyModifyPayPwdRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyModifyPayPwdRequest : FyBaseRequest

@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *oldPwd;


@end
