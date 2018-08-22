//
//  FyVerificationCodeRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "FyVerificationCodeModel.h"
@interface FyVerificationCodeRequest : FyBaseRequest

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *businessType;

@end
