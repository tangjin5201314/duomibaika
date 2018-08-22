//
//  FyPhoneLoginSmsCodeViewController.m
//  CashLoan
//
//  Created by lilianpeng on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyPhoneLoginSmsCodeViewController.h"
#import "RichLabel.h"
#import "H5PageModel.h"
#import "FyProtocolListModel.h"
#import "FyGetUserProtocolRequest.h"
#import "EventHanlder.h"
#import "FyVerificationCodeRequest.h"
#import "RDCountDownButton.h"
#import "FyUserLoginReqeust.h"
#import "RDWebViewController.h"
#import "FySetLoginPwdViewController.h"
#import "FySetPsdViewCotroller.h"
#import "NSString+Validation.h"
#import <LCActionSheet/LCActionSheet.h>
#import "NSString+fyUrl.h"

@interface FyPhoneLoginSmsCodeViewController ()<UITextFieldDelegate>{
    BOOL agreeProtocol;
    NSString *type;
    NSString *vCodeBusinessType;
//    H5PageModel *registerProtocolModel;
//    H5PageModel *rulesProtocolModel;
    FyVerificationCodeRequest *smsTask;
}
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceCodeBtn;
@property (weak, nonatomic) IBOutlet RDCountDownButton *reSendSmsBtn;
//@property (weak, nonatomic) IBOutlet UIButton *reSendSmsBtn;
@property (weak, nonatomic) IBOutlet RichLabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hideBtns;
@property (weak, nonatomic) IBOutlet UITableViewCell *protocolCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *topCell;

@property (nonatomic, strong) NSArray *protocolList; //协议列表
@property (nonatomic, strong) NSArray *protocolUrlList; //协议列表


@end

@implementation FyPhoneLoginSmsCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    agreeProtocol = YES;
    type = @"1";
    [self configSubviews];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    switch (self.smsType) {
        case SMS_LoginOrRegister:
        {
            [self.navigationController setNavigationBarHidden:YES animated:animated];

        }
            break;
        case SMS_SetLoginPWD:
        {
            [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];

        }
            break;
        case SMS_ForgetLoginPWD:
        {
            [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];

        }
            break;
        case SMS_ForgetPayPWD:
        {
            [_loginBtn setTitle:@"下一步" forState:UIControlStateNormal];

        }
            break;
        default:
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_smsCodeTF becomeFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"dealloc login");
}

- (IBAction)protocolBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    //    login_ protocol_unselected
    [btn setImage:[UIImage imageNamed:btn.selected ? @"组7" : @"icon_Check_no"] forState: UIControlStateNormal];
    agreeProtocol = btn.selected;
}

- (void)configSubviews {
    self.protocolList = @[@"多米白卡征信调查授权协议",@"多米白卡注册协议"];
    self.protocolUrlList = @[[NSString stringWithFormat:@"%@%@",APP_H5_PRO,YMREFERENCECHECK],[NSString stringWithFormat:@"%@%@",APP_H5_PRO,YMREGISTRATIONAGREEMENT]];
    
    //输入框
    //    [_phoneNumberTF setValue:[UIColor colorWithHexString:@"9798999"] forKeyPath:@"_placeholderLabel.textColor"];
    [_reSendSmsBtn countDownChanging:^NSString *(RDCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"(%zd) 重新获取",second];
        return title;
    }];
    [_reSendSmsBtn  countDownFinished:^NSString *(RDCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        return @"重新获取";
    }];
    
    self.phoneNumberLabel.text = self.phoneNumber ? self.phoneNumber : [FyUserCenter sharedInstance].userName;
    if (_smsType == SMS_LoginOrRegister) {
        [self loadProtocol];
        
    }else{
        [self cell:_protocolCell setHidden:YES];
        [self reloadDataAnimated:NO];

    }
    if (_smsType == SMS_SetLoginPWD || _smsType == SMS_ForgetPayPWD || _smsType == SMS_ForgetLoginPWD) {
        for (UIView *v in _hideBtns) {
            [v setHidden:YES];
        }
        [self cell:_topCell setHeight:140.0f];
        [self reloadDataAnimated:NO];
        
    }
    if (_smsType != SMS_ForgetPayPWD) {
        [self sendCode];
        
    }else{
        vCodeBusinessType = @"findPay";
        [self countDownMethod];

    }
    UIButton *clearBtn1 = [_smsCodeTF valueForKey:@"_clearButton"];
    [clearBtn1 setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    _smsCodeTF.delegate = self;
    //    agreeProtocol = YES;

}

- (void)loginWithUserName:(NSString *)userName withValidCode:(NSString *)code isAgree:(BOOL)agree{


    if (!agree) {
        NSString *str = @"请先同意《用户协议》";
        [self LPShowAletWithContent:str];
        return;
    }

    if (code.length <= 0){
        [self LPShowAletWithContent:@"请输入验证码"];

        return;
    }

    _loginBtn.enabled = NO;

    FyUserLoginReqeust *task = [[FyUserLoginReqeust alloc] init];
    task.phone = userName;
    task.code = code;
    task.type = type;
    task.businessType = vCodeBusinessType;

    [[FyUserCenter sharedInstance] cleanUp];
    [self showGif];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyUserCenter * model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            
            [model save];
            [SVProgressHUD showSuccessWithStatus:error.errorMessage];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:FYNOTIFICATION_LOGINSUCCESS object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        }else{
            [self LPShowAletWithContent:error.errorMessage];
            _loginBtn.enabled = YES;
            [_reSendSmsBtn stopCountDown];
        }
        [self hideGif];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        _loginBtn.enabled = YES;
        [_reSendSmsBtn stopCountDown];
        [self LPShowAletWithContent:error.errorMessage];
        [self hideGif];
    }];
}

////请求协议信息
- (void)loadProtocol{
    
    [self configUserProtocol];
}

- (void)pushToProtocolWithModel:(NSString *)urlStr title:(NSString *)title {
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = title;
    vc.url = [urlStr fy_UrlString];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)pushToProtocol{
    
    WS(weakSelf)
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitleArray:self.protocolList];
    actionSheet.clickedHandler = ^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex != 0) {
            [weakSelf pushToProtocolWithModel:weakSelf.protocolUrlList[buttonIndex-1] title:weakSelf.protocolList[buttonIndex-1]];
        }
    };
    
    actionSheet.titleFont = [UIFont systemFontOfSize:18];
    actionSheet.titleColor = [UIColor textColorV2];
    actionSheet.buttonFont = [UIFont systemFontOfSize:17];
    actionSheet.buttonColor = [UIColor textColorV2];
    actionSheet.unBlur = YES;
    [actionSheet show];
    
    
}

//配置用户协议信息
- (void)configUserProtocol{
    WS(weakSelf)
    UIColor *protocolColor = [UIColor colorWithHexString:@"333848"];
    _protocolLabel.fy_font = [UIFont systemFontOfSize:15];
    _protocolLabel.fy_color = protocolColor;
    
    _protocolLabel.orignText = @"我已阅读并同意《用户协议》";
    [_protocolLabel fy_setHighlightText:@"《用户协议》" color:[UIColor textGradientEndColor] backgroundColor:[UIColor whiteColor] tapAction:^(NSString *text, NSRange range) {
        [weakSelf pushToProtocol];
    }];
    
    _protocolLabel.numberOfLines = 0;
}

////h5
- (void)showH5WithModel:(H5PageModel *)model{
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = model.name;
    vc.url = [[FyNetworkManger sharedInstance] baseURLWithPath:model.value];
    vc.method = RDWebViewSendMethodGET;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextFieldDelegate
//输入框限制位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *targetString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _smsCodeTF) {
        if (targetString.length > 0) {
            //            _phoneLabel.text = @"手机号码";
        }else {
            //            _phoneLabel.text = @"";
        }
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        
        return  textField.text.length < 4;
    }

    return YES;
}

- (void)verifySMS {
    
}

//登录
- (IBAction)nextBtnClick:(id)sender {
    
    
    if (_smsCodeTF.text.length == 0) {
        [self LPShowAletWithContent:@"请输入验证码"];

        return;
    }
    if (![_smsCodeTF.text validationType:ValidationTypePhoneCode]) {
        [self LPShowAletWithContent:@"验证码格式错误"];
        return;
    }
    
    
    if (self.smsType == SMS_LoginOrRegister)
        {
            [self loginWithUserName:self.phoneNumber withValidCode:_smsCodeTF.text isAgree:_protocolBtn.selected];
            return;
        }
    [self vefiryCode];

    
}

//dismiss
- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//pop返回
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)sendSmsCodeBtnClick:(id)sender {
    [self sendCode];
}

- (IBAction)sendVoiceCodeBtnClick:(id)sender {
    [self sendVoiceCode];
}

//请求验证码
- (void)sendCode{
    type = @"1";
    [EventHanlder trackSendRegisterCodeEvent];
    _reSendSmsBtn.enabled = NO;
    [self showGif];
    smsTask = [[FyVerificationCodeRequest alloc] init];
    smsTask.phone = [FyUserCenter sharedInstance].userName.length != 0 ? [FyUserCenter sharedInstance].userName : self.phoneNumber;
    smsTask.type = @"1";
    
    switch (self.smsType) {
        case SMS_LoginOrRegister:
        {
            smsTask.businessType = @"registerOrSign";

        }
            break;
        case SMS_SetLoginPWD:
        {
            smsTask.businessType = @"findReg";

        }
            break;
        case SMS_ForgetLoginPWD:
        {
            smsTask.businessType = @"findReg";
            
        }
            break;
        case SMS_ForgetPayPWD:
        {
            smsTask.businessType = @"findPay";
            
        }
            break;
        default:
            break;
    }
    
    vCodeBusinessType = smsTask.businessType;
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:smsTask success:^(NSURLSessionDataTask *task, FyResponse *error, FyVerificationCodeModel * model) {
        [self hideGif];
//        [self.smsCodeTF becomeFirstResponder];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [self countDownMethod];
            
        }else{
//            [self LPShowAletWithContent:error.errorMessage];
            [self fy_toastMessages:error.errorMessage];
            [_reSendSmsBtn stopCountDown];
            _reSendSmsBtn.enabled = YES;
            

        }
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        [_reSendSmsBtn stopCountDown];

        _reSendSmsBtn.enabled = YES;
        
    }];
}

- (void)sendVoiceCode{
    type = @"2";

    [EventHanlder trackSendRegisterCodeEvent];
    _voiceCodeBtn.enabled = NO;
    [self showGif];
    FyVerificationCodeRequest *task = [[FyVerificationCodeRequest alloc] init];
    task.phone = self.phoneNumber;
    task.type = @"2";
    task.businessType = @"voiceSign";
    vCodeBusinessType = task.businessType;

    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyVerificationCodeModel * model) {
        [self hideGif];
//        [self.smsCodeTF becomeFirstResponder];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [_voiceCodeBtn setTitle:@"语音验证码发送中..." forState:UIControlStateNormal];
            
        }else{
            [self LPShowAletWithContent:error.errorMessage];
            _voiceCodeBtn.enabled = YES;
            
        }
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        _voiceCodeBtn.enabled = YES;
        
    }];
}


-(void)countDownMethod{
    _reSendSmsBtn.enabled = NO;
    [_reSendSmsBtn setTitleColor:[UIColor timeDownBtnColor] forState:UIControlStateNormal];
    [_reSendSmsBtn startCountDownWithSecond:60];
    
}



/**
 设置登录密码
 */
- (void)setLoginPwdClick {
    
    FySetLoginPwdViewController *vc = [FySetLoginPwdViewController loadFromStoryboardName:@"FyLoginStoryboard" identifier:nil];
    vc.vCode = _smsCodeTF.text;
    vc.vCodeBusinessType = vCodeBusinessType;
    vc.pwdType = Pwd_SetLogin;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 忘记登录密码
 */
- (void)seForgettLoginPwdClick {

    FySetLoginPwdViewController *vc = [FySetLoginPwdViewController loadFromStoryboardName:@"FyLoginStoryboard" identifier:nil];
    vc.vCode = _smsCodeTF.text;
    vc.vCodeBusinessType = vCodeBusinessType;
    vc.pwdType = Pwd_ForgetLogin;
    vc.phoneNumber = self.phoneNumber;
    [self.navigationController pushViewController:vc animated:YES];

}
/**
 忘记交易密码
 */
- (void)seForgetPayPwdClick {
    FySetPsdViewCotroller *vc = [[FySetPsdViewCotroller alloc] init];
    vc.type = 1;
    vc.isForget = YES;
    vc.vcode = self.smsCodeTF.text;
    vc.businessType = vCodeBusinessType;
    vc.lastVC = self.lastVC;
    [self.navigationController pushViewController:vc animated:YES];
}
//校验验证码
- (void)vefiryCode{
    _voiceCodeBtn.enabled = NO;
    [self showGif];
    FyEasyRequest *task = [[FyEasyRequest alloc] init];
    task.loadUrlPath = API_SERVICE_CODE_VERIFYSCODE;
    task.loadParams = @{@"businessType":vCodeBusinessType,@"type":type,@"vcode":_smsCodeTF.text,@"phone":[FyUserCenter sharedInstance].userName.length != 0 ? [FyUserCenter sharedInstance].userName : self.phoneNumber};
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyVerificationCodeModel * model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {

                switch (_smsType) {
                    case SMS_LoginOrRegister:
                    {
//                        [self loginWithUserName:self.phoneNumber withValidCode:_smsCodeTF.text isAgree:_protocolBtn.selected];
                    }
                        break;
                    case SMS_SetLoginPWD:
                        {
                            [self setLoginPwdClick];
                        }
                        break;
                    case SMS_ForgetPayPWD:
                    {
                        //setPayPwd设置交易密码
                        [self seForgetPayPwdClick];                    }
                        break;
                    case SMS_ForgetLoginPWD:
                    {
                        //setLogin设置登录密码
                        [self seForgettLoginPwdClick];                    }
                        break;
                    default:
                        break;
                }
            
            
        }else{
            [self LPShowAletWithContent:error.errorMessage];
            _voiceCodeBtn.enabled = YES;
            
        }
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        _voiceCodeBtn.enabled = YES;
        
    }];
}

@end

