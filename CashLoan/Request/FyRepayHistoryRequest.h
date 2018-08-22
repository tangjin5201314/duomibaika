//
//  FyRepayHistoryRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "FyRepayListModel.h"

@interface FyRepayHistoryRequest : FyBaseRequest

@property (nonatomic, assign) NSInteger current;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString * borrowID;

@end
