//
//  FySafeCenterViewController.m
//  CashLoan
//
//  Created by lilianpeng on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FySafeCenterViewController.h"
#import "FySetLoginPwd_GetVerifyCodeViewController.h"
#import "FyPhoneLoginSmsCodeViewController.h"
#import "FyChangeLoginPwdViewController.h"
#import "FyPwdUtil.h"
#import "FySetPsdViewCotroller.h"
#import "FyModifyPayPwdViewController.h"

@interface FySafeCenterViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *tradPwdCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *loginPwdCell;
@property (weak, nonatomic) IBOutlet UILabel *loginPwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPwdLabel;

@end

@implementation FySafeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([FyUserCenter sharedInstance].payPwd == false) {
        self.payPwdLabel.text = @"设置交易密码";
    }else{
        self.payPwdLabel.text = @"修改交易密码";
    }
    
    if ([FyUserCenter sharedInstance].loginPwd == false) {
        self.loginPwdLabel.text = @"设置登录密码";
    }else{
        self.loginPwdLabel.text = @"修改登录密码";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:_tradPwdCell]) {
        if ([FyUserCenter sharedInstance].payPwd == false) {
            FySetPsdViewCotroller *vc = [[FySetPsdViewCotroller alloc] init];
            vc.type = 1;
//            vc.lastVC = self;
            [self.navigationController pushViewController:vc animated:YES];

        }else {
            FyModifyPayPwdViewController *vc = [[FyModifyPayPwdViewController alloc] init];
            vc.type = 1;
            vc.forgetPayPwd = YES;
//            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }

        
    }
    
    if ([cell isEqual:_loginPwdCell]) {
        
        if ([FyUserCenter sharedInstance].loginPwd) {
            
            //修改登录密码
            FyChangeLoginPwdViewController *vc = [[UIStoryboard storyboardWithName:@"FyLoginStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FyChangeLoginPwdViewController"];
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            //设置登录密码
            FyPhoneLoginSmsCodeViewController *vc = [[UIStoryboard storyboardWithName:@"FyLoginStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FyPhoneLoginSmsCodeViewController"];
            vc.smsType = SMS_SetLoginPWD;
            vc.phoneNumber = [FyUserCenter sharedInstance].userName;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}


@end
