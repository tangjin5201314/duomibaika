//
//  RepaymentViewController.h
//  Erongdu
//
//  Created by 李帅良 on 2017/2/15.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,moneyType){
    borrow,
    repay,
    setTradPwd, //设置借款密码
    setTradPwdAgain //再次设置借款密码

};

@interface RDPayPasswordView : UIView <UITextFieldDelegate>


@property (nonatomic, retain) NSString *payMoneyNum;

@property (nonatomic, copy) void (^allPasswordPut)(NSString *password);
@property (nonatomic, copy) void (^cancelBlock)(void);

@property (nonatomic, copy) void (^frogetPassword)(void);

@property (nonatomic, retain) UITextField *textfield;       //隐藏的密码输入框
- (instancetype)initWithFrame:(CGRect)frame type:(moneyType)type;

- (void)refreshUI;

@end
