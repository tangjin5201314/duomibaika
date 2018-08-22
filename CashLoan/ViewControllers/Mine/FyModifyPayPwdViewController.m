//
//  FyModifyPayPwdViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyModifyPayPwdViewController.h"
#import "SYPasswordView.h"
#import "UILabel+Masonry.h"
#import "FySetLoanPwdRequest.h"
#import "FySetPsdViewCotroller.h"
#import "FyCheckOldPayPwdRequest.h"
#import "FyModifyPayPwdRequest.h"
#import "FyForgetPayPwdViewController.h"
#import "FySetLoginPwdViewController.h"
@interface FyModifyPayPwdViewController (){
    
}

@property (nonatomic,strong)SYPasswordView *passwordView;
@property (nonatomic, retain) UIButton *btnRight;

@end

@implementation FyModifyPayPwdViewController

- (void)popToLastVcIfNeeded{
    if (self.lastVC) {
        [self.navigationController popToViewController:self.lastVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    NSString *titleStr;
    if (_type == 1) {
        titleStr = @"修改交易密码";
        
        if (self.model.forgetable) {
//            [self configNavigationRightItem];
        }

    }else if (_type == 2){
        titleStr = @"新交易密码";
    }else{
        titleStr = @"确认交易密码";
    }
//    self.title = titleStr;
    [self createSubViews];  //加载页面控件
    [self createRemarkLabel];
    
    WS(weakSelf);
    self.tipAction = ^{
        [weakSelf popToLastVcIfNeeded];
        return NO;
    };
    if (_forgetPayPwd) {
        [self configForgetBtn];
        
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.passwordView clearUpPassword];
    [self.passwordView.textField becomeFirstResponder];
}

-(void)configForgetBtn
{
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 30,0, 120, 18)];
    [_btnRight setTitle:@"忘记密码？" forState:UIControlStateNormal];
//    _btnRight.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [_btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_btnRight setTitleColor:[UIColor textGradientEndColor] forState:UIControlStateNormal];
    [_btnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_btnRight addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _btnRight.top = _passwordView.bottom + 10;
    _btnRight.right = kScreenWidth - 20;
    [self.view addSubview:_btnRight];
//    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc]initWithCustomView:_btnRight];
//    self.navigationItem.rightBarButtonItem = itemRight;
    
    
}

-(void)forgetBtnClick
{
    //忘记交易密码
//    FyForgetPayPwdViewController *vc = [[FyForgetPayPwdViewController alloc] init];
//    vc.lastVC = self.lastVC;
//    [self.navigationController pushViewController:vc animated:YES];
    
    FySetLoginPwdViewController *vc = [FySetLoginPwdViewController loadFromStoryboardName:@"FyLoginStoryboard" identifier:nil];
//    vc.vCode = _smsCodeTF.text;
//    vc.vCodeBusinessType = vCodeBusinessType;
    vc.pwdType = Pwd_ForgetPay;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createSubViews
{
    __weak typeof(self)weakself = self;
    
    self.passwordView = [[SYPasswordView alloc]initWithFrame:CGRectMake(16, 160, (kScreenWidth)-32, 40)];
    [self.view addSubview:self.passwordView];
    self.passwordView.allPasswordPut = ^(NSString *password){
        [weakself nextStep:password];
    };
}
-(void)createRemarkLabel
{
    UILabel *remark = [UILabel getLabelWithFontSize:24 textColor:[UIColor textColor] superView:self.view];
    remark.textAlignment = NSTextAlignmentCenter;
    [remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(124);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    NSString *text;
    if (_type == 1) {
        text = @"输入原交易密码";
    }else if (_type == 2){
        text = @"输新交易密码";
    }else{
        text = @"再次输入新交易密码";
    }
    remark.text = text;
}

- (void)chectOldPassword:(NSString *)password{
    FyCheckOldPayPwdRequest *task = [[FyCheckOldPayPwdRequest alloc] init];
    task.pwd = password;
    
    [self showGif];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
//            if ([[error.resData objectForKey:@"pass"] integerValue] == 1) {
                [self modifyPayWithPassword:nil type:2 oldPassword:password];
//            }else{
//                [self LPShowAletWithContent:@"原交易密码错误" okClick:^{
//                    [self.passwordView clearUpPassword];
//                    [self.passwordView.textField becomeFirstResponder];
//
//                }];
//            }
        }else
        {
            [self fy_toastMessages:error.errorMessage];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [self fy_toastMessages:error.errorMessage];
    }];
}

- (void)modifyPayWithPassword:(NSString *)password type:(NSInteger)type oldPassword:(NSString *)oldPwd{
    FyModifyPayPwdViewController *vc = [[FyModifyPayPwdViewController alloc] init];
    vc.type = type;
    vc.pwd = password;
    vc.oldPwd = oldPwd;
    vc.lastVC = self.lastVC;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadNewPwd{
    FyModifyPayPwdRequest *task = [[FyModifyPayPwdRequest alloc] init];
    task.oldPwd = self.oldPwd;
    task.pwd = self.pwd;
    
    [self showGif];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
            [self LPShowAletWithContent:@"交易密码修改成功！" okClick:^{
//                if (_lastVC) {
//                    [self.navigationController popToViewController:_lastVC animated:YES];
//                }else{
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }
                [self.navigationController popToRootViewControllerAnimated:YES];

            }];
        }else
        {
            [self fy_toastMessages:error.errorMessage];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [self fy_toastMessages:error.errorMessage];
    }];

}

-(void)nextStep:(NSString *)password
{
    if (_type == 1) {
        //旧密码输入完毕, 校验 , 通过之后开始新密码
        [self chectOldPassword:password];
    }else if (_type == 2){
        //确认密码
        [self modifyPayWithPassword:password type:3 oldPassword:self.oldPwd];
    }else{
        //进入确认页面之后 如果两次密码一样 就设置密码
        if ([_pwd isEqualToString:password]){
            [self uploadNewPwd];
        }else{
            [self LPShowAletWithContent:@"两次输入的密码不一致" left:@"重新设置" right:@"再试一次" leftClick:^{
                [self modifyPayWithPassword:nil type:2 oldPassword:self.oldPwd];
            } rightClick:^{
                [self.passwordView clearUpPassword];
                [self.passwordView.textField becomeFirstResponder];
            }];

        }
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
