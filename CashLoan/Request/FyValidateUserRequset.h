//
//  FyValidateUserRequset.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyValidateUserRequset : FyBaseRequest

@property (nonatomic, copy) NSString *iDCard;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *vcode;

@end
