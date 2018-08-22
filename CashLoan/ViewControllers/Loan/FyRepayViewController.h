//
//  FyRepayViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"

@interface FyRepayViewController : FyBaseStaticDataTableViewController

@property (nonatomic, copy) NSString *borrowID;
@property (nonatomic, copy) void (^moneyBlock)(NSString *dueAmount, BOOL isPwd);
@property (nonatomic, copy) void (^selectPayMethodBlock)(NSString *typeString, NSInteger index);

@end
