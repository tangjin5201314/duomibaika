//
//  FyLoanDetailBorrowListModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyBorrowDetailModel.h"
#import "FyRepayDetailModel.h"

@interface FyLoanDetailBorrowListModel : NSObject

@property(nonatomic,strong)NSArray *borrow;
@property(nonatomic,strong)NSArray *repay;

- (FyBorrowDetailModel *)defaultBorrowDetailModel;
- (FyRepayDetailModel *)defaultRepayModel;

@end
