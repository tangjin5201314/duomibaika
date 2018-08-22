//
//  YMHomeLeaseTipView.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMHomeLeaseTipView : UIView
@property (strong, nonatomic) UIView *blackView;
@property (copy, nonatomic) void(^leaseBtnBlock)(NSInteger selectedIndex);

- (void)closeView;
- (void)show:(NSArray *)dataArr;
@end
