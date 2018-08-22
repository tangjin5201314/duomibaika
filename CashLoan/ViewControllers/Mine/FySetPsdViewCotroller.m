//
//  FySetPsdViewCotroller.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FySetPsdViewCotroller.h"
#import "SYPasswordView.h"
#import "UILabel+Masonry.h"
#import "FySetLoanPwdRequest.h"
#import "NSString+fyBase64.h"
#import "NSString+fyAdd.h"

@interface FySetPsdViewCotroller ()

@property (nonatomic,strong)SYPasswordView *passwordView;

@end

@implementation FySetPsdViewCotroller

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
    
    WS(weakSelf);

    
    NSString *titleStr;
    if (_type == 1) {
        titleStr = @"设置交易密码";
    }else{
        titleStr = @"确认交易密码";
    }
//    self.title = titleStr;
    
    [self createSubViews];  //加载页面控件
    [self createRemarkLabel];

    self.tipAction = ^BOOL{
        if (weakSelf.lastVC) {
            [weakSelf popToLastVcIfNeeded];

        }else{
            [weakSelf LPShowAletWithTitle:@"设置密码尚未完成，确认退出？" Content:@"" left:@"取消" right:@"确定" leftClick:^{
            } rightClick:^{
                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
                
            } ];
        }
        return NO;
    };
    

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.passwordView clearUpPassword];
    [self.passwordView.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UILabel *remark = [UILabel getLabelWithFontSize:24 textColor:[UIColor textColorV2] superView:self.view];
    remark.textAlignment = NSTextAlignmentCenter;
    [remark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(124);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    
    NSString *text;
    if (_type == 1) {
        text = @"请输入交易密码";
    }else{
        text = @"再次输入交易密码";
    }
    remark.text = text;
}

- (void)reSetPwdWithPassword:(NSString *)password{
    FySetPsdViewCotroller *vc = [[FySetPsdViewCotroller alloc] init];
    vc.isForget = self.isForget;
    if (password.length == 0) {
        vc.type = 1;
    }else{
        vc.type = 2;
        vc.pwd = password;

    }
    vc.businessType = self.businessType;
    vc.vcode = self.vcode;
    vc.lastVC = self.lastVC;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadPassword:(NSString *)password{
    if ([self.pwd isEqualToString:password]) {
        FySetLoanPwdRequest *task = [[FySetLoanPwdRequest alloc] init];
        task.payType = PayTypeSet;
        task.nPwd = password;
        if (_isForget) {
            task.vcode =  SAFESTRING(self.vcode);
            task.payType = PayTypeForget;
            task.bussinessType = SAFESTRING(self.businessType);
        }
        [self showGif];
        [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
            [self hideGif];
            if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
            {
                FyUserCenter *userModel = [FyUserCenter sharedInstance];
                userModel.payPwd = YES;
                [userModel save];
                [self LPShowAletWithContent:error.errorMessage okClick:^{

                    if (_lastVC) {
                        [self.navigationController popToViewController:_lastVC animated:YES];
                    }else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }

                }];
            }else
            {
                [self fy_toastMessages:error.errorMessage];
            }
        } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
            [self hideGif];
            [self fy_toastMessages:error.errorMessage];
        }];
        
    }else{
        [self LPShowAletWithContent:@"两次输入的密码不一致" left:@"重新设置" right:@"再试一次" leftClick:^{
            [self reSetPwdWithPassword:nil];
        } rightClick:^{
            [self.passwordView clearUpPassword];
            [self.passwordView.textField becomeFirstResponder];
        }];
    }
}

-(void)nextStep:(NSString *)password
{
    if (_type == 1) {
        //确认密码
        [self reSetPwdWithPassword:password];
    }else{
        //进入确认页面之后 如果两次密码一样 就设置密码
        if ([_pwd isEqualToString:password]) {
            [self uploadPassword:password];
        }else{
            [self fy_toastMessages:@"两次输入交易密码不一致，请重试！"];
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
