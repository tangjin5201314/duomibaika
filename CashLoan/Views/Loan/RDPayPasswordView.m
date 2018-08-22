//
//  RepaymentViewController.m
//  Erongdu
//
//  Created by 李帅良 on 2017/2/15.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "RDPayPasswordView.h"
#import "HexColor.h"

#define viewWidth (kScreenWidth == 320.0 ? 260.0 : (kScreenWidth == 375.0 ? 300.0 : 340.0))

@interface RDPayPasswordView ()



@property (nonatomic, retain) UIView *keyBack;              //密码盘部分背景
@property (nonatomic, retain) UIView *topView;              //顶部背景

@property (nonatomic, retain) UILabel *keyDescLabel;        //密码盘说明
@property (nonatomic, retain) UIView  *topLine;             //分割线
@property (nonatomic, retain) UILabel *borrowTypeLabel;     //借款/还款区分
@property (nonatomic, retain) UILabel *payMoneyLabel;       //钱

@property (nonatomic, retain) UIButton *closeBtn;           //关闭按钮
@property (nonatomic, retain) UIButton *TopCloseBtn;        //关闭按钮
@property (nonatomic, retain) UIButton *forgetPasswordBtn;     //忘记密码

@property (nonatomic, retain) NSMutableArray *keyArray;     //记录KEYlabel

@property (nonatomic, assign) moneyType type;

@end

@implementation RDPayPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(moneyType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    _textfield = [[UITextField alloc] init];
    _textfield.keyboardType = UIKeyboardTypeNumberPad;
    _textfield.secureTextEntry = YES;

    [_textfield addTarget:self action:@selector(textfieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textfield];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backView.backgroundColor = [UIColor fy_colorWithHexString:@"#000000" alpha:0.3f];
    [self addSubview:backView];
    
    _keyBack = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - viewWidth) / 2.0, iPhone4? 11 : SCALE6Width(50), viewWidth,0)];
    _keyBack.layer.masksToBounds = YES;
    _keyBack.layer.cornerRadius = 8.0;

    _keyBack.layer.cornerRadius = 10.0;
    CGFloat labelWidth = (viewWidth - 34.0) / 6;
    _keyBack.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardUp)];
    [_keyBack addGestureRecognizer:gesture];
    [self addSubview:_keyBack];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
    [_keyBack addSubview:_topView];
    
    _keyDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCALE6Width(10) + 20, viewWidth, 20)];
    _keyDescLabel.text =  @"请输入交易密码";
    _keyDescLabel.backgroundColor = [UIColor clearColor];
    _keyDescLabel.font = [UIFont systemFontOfSize:17];
    _keyDescLabel.textColor = [UIColor fy_colorWithHexString:@"#333333"];
    _keyDescLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_keyDescLabel];
    
    
    _TopCloseBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];

    [_TopCloseBtn setImage:[UIImage imageNamed:@"KDHomepage"] forState:UIControlStateNormal];
    [_TopCloseBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_TopCloseBtn];
    
    
    _borrowTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ((_type == borrow)?40:0)+(iPhone4 ? 15 : 20)*SCALE6Width(1), viewWidth, 30)];
    _borrowTypeLabel.font = [UIFont systemFontOfSize:15.f];
    _borrowTypeLabel.textColor = [UIColor fy_colorWithHexString:@"#000000"];
    _borrowTypeLabel.textAlignment = NSTextAlignmentCenter;
    _borrowTypeLabel.text = _type == borrow ? @"借款金额" : @"还款总额";
    [_keyBack addSubview:_borrowTypeLabel];
    
    _payMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_borrowTypeLabel.frame)+10.f*SCALE6Width(1), viewWidth, 31)];
    _payMoneyLabel.font = [UIFont systemFontOfSize:25.f];
    _payMoneyLabel.textColor = [UIColor fy_colorWithHexString:@"#000000"];
    _payMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [_keyBack addSubview:_payMoneyLabel];
    
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, ((_type == borrow)?40:0)+(iPhone4 ? 15 : 20)*SCALE6Width(1), 30, 20*SCALE6Width(1)+10)];
    [_closeBtn setImage:[UIImage imageNamed:@"KDHomepage"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [_keyBack addSubview:_closeBtn];
    
    
    CGFloat forgetPasswordBtnHeight ;
    if (_type == borrow) {
        forgetPasswordBtnHeight =  CGRectGetMaxY(_keyDescLabel.frame) + 15*SCALE6Width(1) + 60+labelWidth;
    }else{
        
        forgetPasswordBtnHeight =  CGRectGetMaxY(_payMoneyLabel.frame)+15*SCALE6Width(1)+labelWidth+15 + 20;
    }
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, forgetPasswordBtnHeight - 10.5 , viewWidth, 0.5)];
    
    _topLine.backgroundColor = [UIColor fy_colorWithHexString:@"#F1F1F1"];
    [_keyBack addSubview:_topLine];
    
    _forgetPasswordBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth/2-40, forgetPasswordBtnHeight-5, 80, 30)];
    _forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_forgetPasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_forgetPasswordBtn setTitleColor:[UIColor fy_colorWithHexString:@"#1E81D2"] forState:UIControlStateNormal];
    [_forgetPasswordBtn addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    [_keyBack addSubview:_forgetPasswordBtn];
    
    _keyArray = [@[] mutableCopy];
    
    
    
    CGFloat height ;
    if (_type == borrow) {
        height =  CGRectGetMaxY(_keyDescLabel.frame) + 15*SCALE6Width(1) + 20;
    }else{
    
        height =  CGRectGetMaxY(_payMoneyLabel.frame) + 15*SCALE6Width(1);
    }
    for (int i = 0; i < 6; i ++) {
        UILabel *passwordKey = [[UILabel alloc] initWithFrame:CGRectMake(15 + i * labelWidth, height, labelWidth + 1, labelWidth)];
        passwordKey.font = [UIFont systemFontOfSize:12];
        passwordKey.textColor = [UIColor fy_colorWithHexString:@"#000000"];
        passwordKey.layer.masksToBounds = YES;
        passwordKey.layer.borderColor = [UIColor fy_colorWithHexString:@"#F1F1F1"].CGColor;
        passwordKey.layer.borderWidth = .5f;
        passwordKey.textAlignment = NSTextAlignmentCenter;
        
        passwordKey.backgroundColor = [UIColor fy_colorWith8BitRed:247 green:248 blue:247];
        [_keyArray addObject:passwordKey];
        [_keyBack addSubview:passwordKey];
    }
    
    CGFloat keyBackHigh;
    if (_type == borrow) {
        keyBackHigh = CGRectGetMaxY(_forgetPasswordBtn.frame) ;
        
        _topView.hidden = NO;
        _closeBtn.hidden = YES;
        _forgetPasswordBtn.hidden = NO;
        _borrowTypeLabel.hidden = YES;
        _payMoneyLabel.hidden = YES;
        
        
        
    }else{
        keyBackHigh = CGRectGetMaxY(_payMoneyLabel.frame)+15*SCALE6Width(1)+labelWidth+15*SCALE6Width(1)+30 + 20;
        _topView.hidden = YES;
        _closeBtn.hidden = NO;
        _forgetPasswordBtn.hidden = NO;
    }
     _keyBack.frame = CGRectMake(_keyBack.frame.origin.x, _keyBack.frame.origin.y, viewWidth, keyBackHigh);
    //设置交易密码
    if (_type == setTradPwd) {
        _borrowTypeLabel.text = @"设置交易密码";
        _forgetPasswordBtn.hidden = YES;
        
    }else if (_type == setTradPwdAgain){
        _borrowTypeLabel.text = @"确认交易密码";
        _forgetPasswordBtn.hidden = YES;

        
    }

}

- (void)keyBoardUp
{
    [_textfield becomeFirstResponder];
}

- (void)refreshUI
{
    _textfield.text = @"";
    for (UILabel *label in _keyArray) {
        label.text = @"";
    }
    
    if (_type == setTradPwd || _type == setTradPwdAgain) {
        _payMoneyLabel.text = @"";
        for (UILabel *label in _keyArray) {
            label.text = @"";
        }
    }
    [_textfield becomeFirstResponder];

}

- (void)removeSelf
{
    
    [_textfield resignFirstResponder];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
    
}

- (void)findPassword
{
    
    if (self.frogetPassword) {
        self.frogetPassword();
        [self removeSelf];

    }
}

#pragma mark textfield相关
- (void)textfieldChange:(UITextField *)textfield
{
    for (UILabel *label in _keyArray) {
        if ([_keyArray indexOfObject:label] < _textfield.text.length) {
            label.text = @"●";
        } else {
            label.text = @"";
        }
    }
    
    if (_textfield.text.length >= 6) {
        
        [self performSelector:@selector(inputFinish) withObject:self afterDelay:0.0];
    }
}
- (void)inputFinish
{
    [self removeSelf];
    if (self.allPasswordPut) {
        if (_textfield.text.length>=6) {
            self.allPasswordPut([self.textfield.text substringToIndex:6]);
        }
    }
}



@end
