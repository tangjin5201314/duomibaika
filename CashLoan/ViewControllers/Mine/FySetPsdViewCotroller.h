//
//  FySetPsdViewCotroller.h
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseViewController.h"
#import "NSString+fyAdd.h"

@interface FySetPsdViewCotroller : FyBaseViewController

@property (nonatomic, copy) NSString *vcode;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * pwd;
@property (nonatomic, weak) UIViewController * lastVC;
@property (nonatomic, assign) BOOL isForget;

@end
