//
//  FyBuyoutTipView.h
//  CashLoan
//
//  Created by lilianpeng on 2018/3/31.
//  Copyright © 2018年 多米. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyBuyoutTipView : UIView
@property (nonatomic, copy) void (^wechatBlock)(void);
@property (nonatomic, copy) void (^alipayBlock)(void);

- (void)show;
- (void)hidenCompletion:(void (^)(void))completion;



@end
