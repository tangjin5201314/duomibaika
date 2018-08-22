//
//  FyLoanHistoryRequestV2.h
//  CashLoan
//
//  Created by fyhy on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "FyLoanLogListModelV2.h"

@interface FyLoanHistoryRequestV2 : FyBaseRequest

@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger pageSize;


@end
