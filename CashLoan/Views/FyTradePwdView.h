//
//  FyTradePwdView.h
//  CashLoan
//
//  Created by fyhy on 2017/11/15.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPasswordView.h"

typedef NS_ENUM(NSInteger,TradeType){
    TradeTypeUnkown = 0, 
    TradeTypeInput = 1, //输入交易密码
    TradeTypeSet = 2, //设置密码
    TradeTypeSetAgain = 3 //再次输入密码
};


@interface FyTradePwdView : UIView

@property (nonatomic, weak) IBOutlet SYPasswordView *passwordView;
@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) TradeType tradeType;

@property (nonatomic, copy) void (^allPasswordPut)(NSString *password);
@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^frogetPassword)(void);
@property (nonatomic, copy) void (^changeToTradePwdViewBlock)(FyTradePwdView *);

@property (nonatomic, assign) BOOL pwdError;

@end
