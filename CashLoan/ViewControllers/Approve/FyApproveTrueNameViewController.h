//
//  FyApproveTrueNameViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"
#import "FyApproveViewControllerDelegate.h"

@interface FyApproveTrueNameViewController : FyBaseStaticDataTableViewController<FyApproveViewControllerDelegate>

@property (assign, nonatomic) BOOL autoNext; //自动进入下一步
@property (copy, nonatomic) BOOL (^tipAction)(void);//点击返回提示事件

@end
