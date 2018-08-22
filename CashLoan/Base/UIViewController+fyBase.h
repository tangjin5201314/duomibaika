//
//  UIViewController+fyBase.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (fyBase)

@property (nonatomic, strong) UIColor *fy_navigationBarColor;
@property (nonatomic, strong) UIColor *fy_navigationBarLineColor;

@property (copy, nonatomic) BOOL (^tipAction)(void);//点击返回提示事件
-(NSArray<UIBarButtonItem *>*) createBackButton;

@end
