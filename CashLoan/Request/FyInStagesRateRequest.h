//
//  FyInStagesRateRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/12/8.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "FyInStagesRateModel.h"

@interface FyInStagesRateRequest : FyBaseRequest

@property (nonatomic, copy) NSString *principal;
@property (nonatomic, copy) NSString *peroidValue;
@property (nonatomic, assign) NSInteger calculateMode;

@end
