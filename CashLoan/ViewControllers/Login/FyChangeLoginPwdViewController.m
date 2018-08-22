//
//  FyChangeLoginPwdViewController.m
//  CashLoan
//
//  Created by lilianpeng on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyChangeLoginPwdViewController.h"
#import "FySetLoginPwdViewController.h"
#import "FyPhoneLoginSmsCodeViewController.h"
#import "NSString+Validation.h"

@interface FyChangeLoginPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@end

@implementation FyChangeLoginPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _oldPwdTF.placeholder = @"输入原密码";
    self.navigationController.navigationBar.hidden = NO;
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    [_oldPwdTF becomeFirstResponder];
}

- (IBAction)nextBtnClick:(id)sender {
    if (![_oldPwdTF.text validationType:ValidationTypePassword]) {
        [self LPShowAletWithContent:@"原密码格式有误"];
        return;
    }
    /**
     修改登录密码
     */
    FySetLoginPwdViewController *vc = [FySetLoginPwdViewController loadFromStoryboardName:@"FyLoginStoryboard" identifier:nil];
    vc.oldPwd = _oldPwdTF.text;
    vc.pwdType = Pwd_ResetLogin;
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)forgetPwdClick:(id)sender {
//忘记密码
    FyPhoneLoginSmsCodeViewController *smsVC = [[UIStoryboard storyboardWithName:@"FyLoginStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FyPhoneLoginSmsCodeViewController"];
    smsVC.phoneNumber = [FyUserCenter sharedInstance].userName;
    smsVC.smsType = SMS_ForgetLoginPWD;
    [self.navigationController pushViewController:smsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
