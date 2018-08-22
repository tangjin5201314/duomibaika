//
//  FyModifyPayPwdViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseViewController.h"
#import "MineSettingModel.h"

@interface FyModifyPayPwdViewController : FyBaseViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * pwd;
@property (nonatomic, copy) NSString * oldPwd;

@property (nonatomic, weak) UIViewController * lastVC;
@property (nonatomic, strong) MineSettingModel *model;

@property (nonatomic) BOOL forgetPayPwd;

@end
