//
//  FindTradePwdView.m
//  CashLoan
//
//  Created by rdmacmini on 17/2/23.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "FindTradePwdView.h"
#import <Masonry/Masonry.h>
#import "NSString+Validation.h"
#import "SVProgressHUD.h"
#import "UILabel+Masonry.h"
#import "UIView+Masonry.h"
#import "UITextField+Masonry.h"
#import "UIButton+Masonry.h"

@implementation FindTradePwdView
-(instancetype)initFindTradePwdView
{
    self = [super init];
    if (self) {
        [self createViews];
    }
    return self;
}
-(void)createViews
{
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor viewBackgroundColor];
    
    //新密码背景view
    UIView *phoneView = [UIView getViewWithColor:[UIColor whiteColor] superView:self];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(15);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    //新密码标签
    UILabel *phoneLabel = [UILabel getLabelWithFontSize:16 textColor:[UIColor textColor] superView:phoneView];
    phoneLabel.text = @"手机号码";
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(phoneView).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 44));
    }];
    //新密码
    _phoneTF = [UITextField getTextFieldWithFontSize:15 textColorHex:[UIColor textColor] placeHolder:@"手机号码" superView:phoneView];
    [_phoneTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _phoneTF.keyboardType = UIKeyboardTypeDefault;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(phoneLabel.mas_right).offset(5);
        make.right.equalTo(phoneView).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    //确认新密码背景view
    UIView *nameView = [UIView getViewWithColor:[UIColor whiteColor] superView:self];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).offset(1);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    //确认新密码标签
    UILabel *nameLabel = [UILabel getLabelWithFontSize:16 textColor:[UIColor textColor] superView:nameView];
    nameLabel.text = @"真实姓名";
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(nameView).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 44));
    }];
    //确认新密码
    _nameTF = [UITextField getTextFieldWithFontSize:15 textColorHex:[UIColor textColor] placeHolder:@"请填写真实姓名" superView:nameView];
    [_nameTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _nameTF.keyboardType = UIKeyboardTypeDefault;
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;

    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(nameLabel.mas_right).offset(5);
        make.right.equalTo(nameView).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    
    
    //确认新密码背景view
    UIView *CardIdView = [UIView getViewWithColor:[UIColor whiteColor] superView:self];
    [CardIdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).offset(1);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    UILabel *CardIdLabel = [UILabel getLabelWithFontSize:16 textColor:[UIColor textColor] superView:CardIdView];
    CardIdLabel.text = @"身份证号";
    [CardIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(CardIdView).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 44));
    }];
    //身份证号
    _CardIdTF = [UITextField getTextFieldWithFontSize:15 textColorHex:[UIColor textColor] placeHolder:@"请填写身份证号" superView:CardIdView];
    [_CardIdTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _CardIdTF.keyboardType = UIKeyboardTypeDefault;
    _CardIdTF.clearButtonMode = UITextFieldViewModeWhileEditing;

    [_CardIdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(CardIdLabel.mas_right).offset(5);
        make.right.equalTo(CardIdView).offset(-15);
        make.height.mas_equalTo(44);
    }];

    //确认新密码背景view
    UIView *codeView = [UIView getViewWithColor:[UIColor whiteColor] superView:self];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(CardIdView.mas_bottom).offset(1);
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    UILabel *codeLabel = [UILabel getLabelWithFontSize:16 textColor:[UIColor textColor] superView:codeView];
    codeLabel.text = @"短信验证码";
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(codeView).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 44));
    }];
    
    
    //获取验证码按钮
    _getCodeBtn = [RDCountDownButton buttonWithType:UIButtonTypeCustom];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_getCodeBtn setTitleColor:[UIColor fyThemeColor] forState:UIControlStateNormal];
    [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:_getCodeBtn];
    
    
    [_getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.right.equalTo(codeView).offset(-15);
//        make.height.mas_equalTo(44);
//        
        
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
    UIView *_lineView = [UIView getViewWithColor:[UIColor separatorColor] superView:codeView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_getCodeBtn);
        make.height.equalTo(@(30));
        make.right.mas_equalTo(_getCodeBtn.mas_left).offset(1);
        make.width.equalTo(@(1));
    }];
    
    //身份证号
    _codeTF = [UITextField getTextFieldWithFontSize:15 textColorHex:[UIColor textColor] placeHolder:@"请输入验证码" superView:codeView];
    [_codeTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;

    [_codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(codeLabel.mas_right).offset(5);
        make.right.equalTo(_getCodeBtn.mas_left).offset(0);
        make.height.mas_equalTo(44);
    }];
    
    

    
    //下一步
    _resetBtn = [UIButton getButtonWithFontSize:15 TextColorHex:[UIColor whiteColor] backGroundColor:[UIColor disabledButtonTextColor] radius:5.f superView:self];
    _resetBtn.userInteractionEnabled = NO;
    [_resetBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_resetBtn addTarget:self action:@selector(resetPwd) forControlEvents:UIControlEventTouchUpInside];
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom).offset(20);
        make.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-20);
        make.height.mas_equalTo(44);
    }];
}
-(void)loadPhoneTF:(NSString *)phone
{
    _phoneTF.text = phone;
    _phoneTF.userInteractionEnabled = NO;
}
-(void)getCodeAction
{
    if (_FindTradePwdViewDelegate && [_FindTradePwdViewDelegate respondsToSelector:@selector(FindTradePwdSendValidCode:)]) {
        [_FindTradePwdViewDelegate FindTradePwdSendValidCode:_phoneTF.text];
    }
}
-(void)resetPwd
{
    
    
    if(_nameTF.text.length <= 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    
    if (![_nameTF.text validationType:ValidationTypeChinese]) {
        [SVProgressHUD showErrorWithStatus:@"真实姓名仅为中文"];
        return;
    }
    
    if (_CardIdTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号"];
        return;
    }
    if (![_CardIdTF.text validationType:ValidationTypeIDCard]) {
        [SVProgressHUD showErrorWithStatus:@"身份证号输入有误"];
        return;
    }
    
    if (_FindTradePwdViewDelegate && [_FindTradePwdViewDelegate respondsToSelector:@selector(FindTradePhone:withRealName:withCardId:withCode:)]) {
        [_FindTradePwdViewDelegate FindTradePhone:_phoneTF.text withRealName:_nameTF.text withCardId:_CardIdTF.text withCode:_codeTF.text];
    }
}
-(void)textFieldChanged:(UITextField*)textfield
{
    if (_phoneTF.text.length > 11) {
        _phoneTF.text = [_phoneTF.text substringToIndex:11];
    }
    if (_nameTF.text.length > 16) {
        _nameTF.text = [_nameTF.text substringToIndex:16];
    }
    if (_codeTF.text.length > 4) {
        _codeTF.text = [_codeTF.text substringToIndex:4];
    }
    if (_CardIdTF.text.length > 18) {
        _CardIdTF.text = [_CardIdTF.text substringToIndex:18];
    }
    
    if (_phoneTF.text.length == 11 && _nameTF.text.length >= 2 && _CardIdTF.text.length >= 16 && _codeTF.text.length >= 4) {
        _resetBtn.backgroundColor = [UIColor buttonBackgroundColor];
        _resetBtn.userInteractionEnabled = YES;
    }else{
        _resetBtn.backgroundColor = [UIColor disabledButtonTextColor];
        _resetBtn.userInteractionEnabled = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
