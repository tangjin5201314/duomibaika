//
//  FyBankSelectViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseTableViewController.h"

@interface FyBankSelectViewController : FyBaseTableViewController

@property (nonatomic, copy) void (^selectBankBlock)(NSString *bankName);

@end
