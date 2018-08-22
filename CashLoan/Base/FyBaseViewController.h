//
//  FyBaseViewController.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JENavView.h"

@interface FyBaseViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) JENavView *nav;

//返回
- (void)backAction;
- (void)rightAction;

-(void)customSet;
@end
