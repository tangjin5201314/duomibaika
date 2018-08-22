//
//  FyBindingBankViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"
#import <MGBankCard/MGBankCard.h>

@interface FyBindingBankViewController : FyBaseStaticDataTableViewController

@property (nonatomic, copy) void (^bindSuccessBlock)(NSString *bankName,NSString *bankNumber, NSString *imageUrl);
@property (nonatomic) BOOL reBind;


@end
