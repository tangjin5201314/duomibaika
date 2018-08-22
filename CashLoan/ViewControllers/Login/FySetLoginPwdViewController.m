//
//  FySetLoginPwdViewController.m
//  CashLoan
//
//  Created by lilianpeng on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FySetLoginPwdViewController.h"
#import "DataBaseManager.h"
#import "FyEasyModel.h"
#import "NSString+Validation.h"
#import "FyPhoneLoginSmsCodeViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#define KSetLoginPwd_InputPwd @"请输入密码！"
#define KSetLoginPwd_ConfirmPPwd @"请确认密码！"
#define KSetLoginPwd_VefifyPwd @"密码为6~16位字符，包括数字和字母！"
#define KSetLoginPwd_PwdNotSame @"两次输入密码不一致！"

@interface FySetLoginPwdViewController ()<UITextFieldDelegate>
{
    UIButton *clearBtn1;
    UIButton *clearBtn2;
}
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *rePwdTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@end

@implementation FySetLoginPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"设置登录密码";
    _rePwdTF.delegate = self;
    _pwdTF.delegate = self;
    if (_pwdType != Pwd_ForgetPay) {
        clearBtn1 = [_pwdTF valueForKey:@"_clearButton"];
        [clearBtn1 setImage:[UIImage imageNamed:@"icon_Invisible"] forState:UIControlStateNormal];
        clearBtn2 = [_rePwdTF valueForKey:@"_clearButton"];
        [clearBtn2 setImage:[UIImage imageNamed:@"icon_Invisible"] forState:UIControlStateNormal];
    }

    [self configTitle];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [_pwdTF becomeFirstResponder];
//    [IQKeyboardManager sharedManager].enable = NO;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)configTitle {
    //    self.title = @"修改登录密码";
    /*
     Pwd_ResetPay = 1,//修改交易密码
     Pwd_SetLogin,//设置登录密码
     Pwd_ForgetLogin,//忘记登录密码
     Pwd_ResetLogin,//修改登录密码
     Pwd_ForgetPay,//忘记交易密码
     
     */
    WS(weakSelf)
    switch (_pwdType) {
        case Pwd_ResetPay:
        {
//            _titleLabel.text = @"修改交易密码";
            //逻辑不太一样
        }
            break;
        case Pwd_SetLogin:
        {
            _titleLabel.text = @"设置登录密码";
            self.tipAction = ^BOOL{
                [weakSelf LPShowAletWithTitle:@"设置密码尚未完成，确认退出？" Content:@"" left:@"取消" right:@"确定" leftClick:^{
                } rightClick:^{
                    [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];

                } ];
                return NO;
            };

        }
            break;
        case Pwd_ForgetLogin:
        {
            _titleLabel.text = @"设置新登录密码";
            _pwdTF.placeholder = @"设置密码";
            _rePwdTF.placeholder = @"重复密码";

        }
            break;
        case Pwd_ResetLogin:
        {
            _titleLabel.text = @"修改登录密码";
            _pwdTF.placeholder = @"输入新密码";
            _rePwdTF.placeholder = @"重复新密码";

        }
            break;
        case Pwd_ForgetPay:
        {
            _titleLabel.text = @"验证您的身份信息";
            _pwdTF.placeholder = @"输入真实姓名";
            _pwdTF.returnKeyType = UIReturnKeyDone;
            _rePwdTF.placeholder = @"输入身份证号";
            [_clickBtn setTitle:@"下一步" forState:UIControlStateNormal];
            _pwdTF.secureTextEntry = NO;
            _rePwdTF.secureTextEntry = NO;
        }
            break;
            
        default:
            break;
    }
    [_pwdTF becomeFirstResponder];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//设置密码
- (IBAction)confirmBtnClick:(id)sender {
    NSDictionary *params;
    NSString *erroMessage;
    switch (_pwdType) {
        case Pwd_ResetPay:
        {
            //这个操作是个单独的页面，跟这个不一样
        }
            break;
        case Pwd_SetLogin:
        {
            if (_pwdTF.text.length == 0) {
//                [self LPShowAletWithContent:@"请输入密码！"];
                erroMessage = KSetLoginPwd_InputPwd;
                
            }else if (_rePwdTF.text.length == 0){
//                [self LPShowAletWithContent:@"请确认密码！"];
                erroMessage = KSetLoginPwd_ConfirmPPwd;


            } else if (![_pwdTF.text validationType:ValidationTypePassword]) {
//                [self LPShowAletWithContent:@"密码为6~16位字符，包括数字和字母！"];
                erroMessage = KSetLoginPwd_VefifyPwd;

            }else if (![_rePwdTF.text validationType:ValidationTypePassword]) {
//                [self LPShowAletWithContent:@"密码为6~16位字符，包括数字和字母！"];
                erroMessage = KSetLoginPwd_VefifyPwd;

            }else if (![_pwdTF.text isEqualToString:_rePwdTF.text]) {
//                [self LPShowAletWithContent:@"两次输入密码不一致！"];
                erroMessage = KSetLoginPwd_PwdNotSame;

                
            }else{
                params = @{@"newPwd":[_rePwdTF.text md5String],@"vcode":self.vCode,@"businessType":self.vCodeBusinessType,@"changeType":@"1",@"loginName":[FyUserCenter sharedInstance].userName};
                [self requestData:params loadUrlPath:API_SERVICE_CODE_SETORRESETLOGINPWD];
            }


        }
            break;
        case Pwd_ForgetLogin:
        {
            //{"newPwd":"qwe123","vcode":"5973","businessType":"findReg","changeType":3,"loginName":"18911058573"}
            //两种情况，一种有token 一种无token
            if (_pwdTF.text.length == 0) {
                //                [self LPShowAletWithContent:@"请输入密码！"];
                erroMessage = KSetLoginPwd_InputPwd;
                
            }else if (_rePwdTF.text.length == 0){
                //                [self LPShowAletWithContent:@"请确认密码！"];
                erroMessage = KSetLoginPwd_ConfirmPPwd;
                
                
            } else if (![_pwdTF.text validationType:ValidationTypePassword]) {
                //                [self LPShowAletWithContent:@"密码为6~16位字符，包括数字和字母！"];
                erroMessage = KSetLoginPwd_VefifyPwd;
                
            }else if (![_rePwdTF.text validationType:ValidationTypePassword]) {
                //                [self LPShowAletWithContent:@"密码为6~16位字符，包括数字和字母！"];
                erroMessage = KSetLoginPwd_VefifyPwd;
                
            }else if (![_pwdTF.text isEqualToString:_rePwdTF.text]) {
                //                [self LPShowAletWithContent:@"两次输入密码不一致！"];
                erroMessage = KSetLoginPwd_PwdNotSame;
                
                
            }else{
                if ([FyUserCenter sharedInstance].isLogin) {
                    //有token
                    params = @{@"newPwd":[_rePwdTF.text md5String],@"vcode":self.vCode,@"businessType":self.vCodeBusinessType,@"changeType":@"3",@"loginName":[FyUserCenter sharedInstance].userName.length != 0 ? [FyUserCenter sharedInstance].userName : self.phoneNumber};
                    [self requestData:params loadUrlPath:API_SERVICE_CODE_SETORRESETLOGINPWD];
                }else{
                    //无token
                    //{"osType":"ios","accessToken":"90232886ab9440aea80f10ef5cda5d9b","serviceData":"{\"newPwd\":\"99999\",\"vcode\":\"6695\",\"businessType\":\"findReg\",\"changeType\":3,\"loginName\":\"1804716****\"}","timeStamp":"2017-12-19 09:56:47"}
                    
                    params = @{@"newPwd":[_rePwdTF.text md5String],@"vcode":self.vCode,@"businessType":self.vCodeBusinessType,@"changeType":@"3",@"loginName":[FyUserCenter sharedInstance].userName.length != 0 ? [FyUserCenter sharedInstance].userName : self.phoneNumber};
                    [self requestData:params loadUrlPath:API_SERVICE_CODE_FORGETPWDNOTOKEN];
                }

            }
        }
            break;
        case Pwd_ResetLogin:
        {
            //"serviceData":"{"newPwd":"qwe123","OldPwd":"123456","changeType":2,"loginName":"18911058573"}",
            if (_pwdTF.text.length == 0) {
                //                [self LPShowAletWithContent:@"请输入密码！"];
                erroMessage = KSetLoginPwd_InputPwd;
                
            }else if (_rePwdTF.text.length == 0){
                //                [self LPShowAletWithContent:@"请确认密码！"];
                erroMessage = KSetLoginPwd_ConfirmPPwd;
                
                
            } else if (![_pwdTF.text validationType:ValidationTypePassword]) {
                //                [self LPShowAletWithContent:@"密码为6~16位字符，包括数字和字母！"];
                erroMessage = KSetLoginPwd_VefifyPwd;
                
            }else if (![_rePwdTF.text validationType:ValidationTypePassword]) {
                //                [self LPShowAletWithContent:@"密码为6~16位字符，包括数字和字母！"];
                erroMessage = KSetLoginPwd_VefifyPwd;
                
            }else if (![_pwdTF.text isEqualToString:_rePwdTF.text]) {
                //                [self LPShowAletWithContent:@"两次输入密码不一致！"];
                erroMessage = KSetLoginPwd_PwdNotSame;
                
                
            }else{

                params = @{@"newPwd":[_rePwdTF.text md5String],@"oldPwd":[self.oldPwd md5String],@"changeType":@"2",@"loginName":[FyUserCenter sharedInstance].userName};
                [self requestData:params loadUrlPath:API_SERVICE_CODE_SETORRESETLOGINPWD];
            }

        }
            break;
        case Pwd_ForgetPay:
        {//忘记交易密码---发验证码
            
            
            if ((_pwdTF.text.length != 0) && (_rePwdTF.text.length != 0)) {

                if(![_rePwdTF.text isValidIDCard]){
                    erroMessage = @"身份证号格式错误";
                }else{
                    //认证个人信息
                    [self virifyUserInfo];
                }
            }else if(_pwdTF.text.length == 0){
                erroMessage = @"请输入真实姓名！";

            }else if(_rePwdTF.text.length == 0){
               erroMessage = @"请输入身份证号！";
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
    if (erroMessage.length) {
        [self LPShowAletWithContent:erroMessage];
        
    }
    
  
}

- (void)requestData:(NSDictionary *)params loadUrlPath:(NSString *)urlPath {
    [self showGif];
    FyEasyRequest *task = [[FyEasyRequest alloc] init];
//    task.loadUrlPath = API_SERVICE_CODE_SETORRESETLOGINPWD;
    task.loadUrlPath = urlPath;
    task.loadModelClass = [FyUserCenter class];
    task.loadParams = params;
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyUserCenter  *model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
                FyUserCenter *userModel = [FyUserCenter sharedInstance];
            if (_pwdType == Pwd_SetLogin) {
                userModel.loginPwd = YES;

            }
                
                if ([userModel save]) {
                    [self LPShowAletWithContent:error.errorMessage okClick:^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
            }else{
                [self LPShowAletWithContent:error.errorMessage];
            }
            
            
        }
        else
        {
            [self fy_toastMessages:error.errorMessage];
        }
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [self fy_toastMessages:error.errorMessage];
    }];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (_pwdType != Pwd_ForgetPay) {

        UIButton *clearBtn = [textField valueForKey:@"_clearButton"];
        [clearBtn setImage:[UIImage imageNamed:textField.secureTextEntry ?@"icon_visual" : @"icon_Invisible"] forState:UIControlStateNormal];
        textField.secureTextEntry = !textField.secureTextEntry;
        return NO;
        
    }else{
        return YES;
    }
}
//认证个人信息
- (void)virifyUserInfo {
    [self showGif];
    FyEasyRequest *task = [[FyEasyRequest alloc] init];
    task.loadUrlPath = API_SERVICE_CODE_VERIFYIDENTITY;
    task.loadModelClass = [FyEasyModel class];
    task.loadParams = @{@"loginName":[FyUserCenter sharedInstance].userName,@"realName":_pwdTF.text,@"idNo":_rePwdTF.text};
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyUserCenter  *model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
            [self forgetPayPwdSmsVC];
        }
        else
        {
             [self fy_toastMessages:error.errorMessage];
        }
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
         [self fy_toastMessages:error.errorMessage];
    }];
}

//忘记交易密码的短信发送
- (void)forgetPayPwdSmsVC {
    FyPhoneLoginSmsCodeViewController *smsVC = [[UIStoryboard storyboardWithName:@"FyLoginStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FyPhoneLoginSmsCodeViewController"];
    smsVC.phoneNumber = [FyUserCenter sharedInstance].userName;
    smsVC.smsType = SMS_ForgetPayPWD;
    smsVC.lastVC = self.lastVC;
    [self.navigationController pushViewController:smsVC animated:YES];
}

//输入框限制位数
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//
//    if (textField == _pwdTF) {
//
//        if (range.length == 1 && string.length == 0) {
//            return YES;
//        }
//        
//        return  textField.text.length < 11;
//    }
//
//    if (textField == _rePwdTF) {
//        if (range.length == 1 && string.length == 0) {
//            return YES;
//        }
//
//        return  textField.text.length < 16;
//    }
//
//    return YES;
//}


@end
