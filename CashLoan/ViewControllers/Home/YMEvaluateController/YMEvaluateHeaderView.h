//
//  YMEvaluateHeaderView.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/22.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMEvaluateHeaderView : UIView
@property (nonatomic, copy) void (^applyBlock)(void);

- (void)displayWithTitle:(NSString *)title price:(CGFloat)price;
@end
