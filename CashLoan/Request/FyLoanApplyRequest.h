//
//  FyLoanApplyRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyLoanApplyRequest : FyBaseRequest

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *coordinate;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *cardId;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *realAmount;
@property (nonatomic, copy) NSString *timeLimit;
@property (nonatomic, copy) NSString *tradePwd;
@property (nonatomic, copy) NSString *userId;


@end
