//
//  FyPopupView.h
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FyPopupView : UIView

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, copy) void (^readDetailBlock)(void);
@property (nonatomic, copy) void (^closeBlock)(void);


- (void)show;

@end
