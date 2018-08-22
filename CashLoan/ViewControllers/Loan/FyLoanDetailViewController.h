//
//  FyLoanDetailViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"
#import "LoanState.h"

@interface FyLoanDetailViewController : FyBaseStaticDataTableViewController

@property (nonatomic, copy) NSString *borrowID;
@property (nonatomic, assign) LoanState borrowState;

@end
