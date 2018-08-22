//
//  FyCalculateBorrowRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "CalculateBorrowDataModel.h"

@interface FyCalculateBorrowRequest : FyBaseRequest

@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *day;

@end
