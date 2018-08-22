//
//  FyLoanHistoryRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "FyLoanLogListModel.h"

@interface FyLoanHistoryRequest : FyBaseRequest

@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger pageSize;

@end
