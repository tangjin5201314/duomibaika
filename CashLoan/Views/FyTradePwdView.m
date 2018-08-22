//
//  FyTradePwdView.m
//  CashLoan
//
//  Created by fyhy on 2017/11/15.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyTradePwdView.h"
#import "UIView+fyShow.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface FyTradePwdView()

@property (nonatomic, weak) IBOutlet UIButton *backBtn;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (nonatomic, weak) IBOutlet UIButton *forgetBtn;

@property (nonatomic, copy) NSString *password1;
@property (nonatomic, copy) NSString *password2;

@end

@implementation FyTradePwdView

- (void)setPwdError:(BOOL)pwdError{
    self.tipLabel.text = pwdError ? @"交易密码错误" : @"";
    self.tipLabel.hidden = !pwdError;
    [self.passwordView makeLineRed:pwdError];
}

- (void)setTradeType:(TradeType)tradeType{
    if (tradeType != _tradeType) {
        _tradeType = tradeType;
        [self configUI];
    }
}

- (void)configUI{
    self.backBtn.hidden = self.tradeType != TradeTypeSetAgain;
    self.forgetBtn.hidden = self.tradeType != TradeTypeInput;
    self.tipLabel.hidden = YES;
    
    NSString *title = @"输入交易密码";
    if (self.tradeType == TradeTypeSet) {
        title = @"设置交易密码";
    }else if(self.tradeType == TradeTypeSetAgain){
        title = @"再次输入交易密码";
    }
    
    self.titleLabel.text = title;
    
    WS(weakSelf)
    self.passwordView.allPasswordPut = ^(NSString *password) {
        [weakSelf allPasswordPut:password];
    };
    
    self.passwordView.textChange = ^{
        weakSelf.pwdError = NO;
    };
    
    self.willShowBlock = ^{
//        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;

        [weakSelf.passwordView.textField becomeFirstResponder];
    };
    self.willHiddenBlock = ^{
//        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        [weakSelf endEditing:YES];
    };
}

- (IBAction)backAction:(id)sender{
    if (self.tradeType == TradeTypeSetAgain) {
        FyTradePwdView *view = [FyTradePwdView loadNib];
        view.frame = self.frame;
        view.tradeType = TradeTypeSet;
        view.fyMarkView = self.fyMarkView;
        view.allPasswordPut = self.allPasswordPut;
        
        [UIView transitionWithView:self.fyMarkView
                          duration:0.5
                           options: UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            [self.fyMarkView addSubview:view];
                        }
                        completion:^(BOOL finished) {
                            [self removeFromSuperview];
                            self.fyMarkView = nil;
                            if (self.changeToTradePwdViewBlock) {
                                self.changeToTradePwdViewBlock(view);
                            }
                        }];
        [view.passwordView.textField becomeFirstResponder];

    }
}

- (IBAction)closeAction:(id)sender{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self fy_Hidden];
}

- (IBAction)forgetAction:(id)sender{
    if (self.frogetPassword) {
        self.frogetPassword();
    }
}

- (void)allPasswordPut:(NSString *)pwd{
    self.tipLabel.hidden = YES;
    if (self.tradeType == TradeTypeInput) {
        if (self.allPasswordPut) {
            self.allPasswordPut(pwd);
        }
//        [self fy_Hidden];
    }else if (self.tradeType == TradeTypeSetAgain){
        if ([self.password1 isEqualToString:pwd]) {
            if (self.allPasswordPut) {
                self.allPasswordPut(pwd);
            }
//            [self fy_Hidden];
        }else{
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"两次输入不一致";
        }
    }else{
        [self inputAgainWithPassword:pwd];
    }
}

- (void)inputAgainWithPassword:(NSString *)password{
    FyTradePwdView *againView = [FyTradePwdView loadNib];
    againView.frame = self.frame;
    againView.tradeType = TradeTypeSetAgain;
    againView.fyMarkView = self.fyMarkView;
    againView.allPasswordPut = self.allPasswordPut;
    againView.password1 = password;
    [UIView transitionWithView:self.fyMarkView
                      duration:0.5
                       options: UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self.fyMarkView addSubview:againView];
                    }
                    completion:^(BOOL finished) {
                        [self removeFromSuperview];
                        self.fyMarkView = nil;
                        if (self.changeToTradePwdViewBlock) {
                            self.changeToTradePwdViewBlock(againView);
                        }

                    }];
    [againView.passwordView.textField becomeFirstResponder];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
