//
//  FyConfrmLoanViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"
#import "LoanApplyModel.h"
#import "CalculateBorrowDataModel.h"

@interface FyConfrmLoanViewController : FyBaseStaticDataTableViewController

@property(nonatomic,strong)LoanApplyModel *model;
@property (nonatomic, strong) CalculateBorrowDataModel *calculateModel; //计算利息model

@end
