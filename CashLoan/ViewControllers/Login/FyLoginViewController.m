//
//  FyLoginViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoginViewController.h"
#import "RDCountDownButton.h"
#import "RichLabel.h"
#import "NSString+Validation.h"
#import "FyVerificationCodeModel.h"
#import "FyVerificationCodeRequest.h"
#import "FyProtocolListModel.h"
#import "FyGetUserProtocolRequest.h"
#import "RDWebViewController.h"
#import "FyUserLoginReqeust.h"
#import "FyUserCenter.h"
#import "EventHanlder.h"

@interface FyLoginViewController ()<UITextFieldDelegate>{
    BOOL agreeProtocol;
    NSString *type;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *verifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet RichLabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet RDCountDownButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *BGScrollView;


@property (weak, nonatomic) IBOutlet UIButton *voiceCodeBtn;


@end

@implementation FyLoginViewController

- (void)dealloc{
    NSLog(@"dealloc login");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    type = @"1";
    [self configSubviews];
    [self loadProtocol];
    [self addObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)addObserver{
    WS(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        //等DidFinished方法结束后,将其添加至window上(不然会检测是否有rootViewController)
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.voiceCodeBtn.enabled = YES;
        });
    }];
    
}

- (void)configSubviews {
    //输入框
    [_phoneNumberTF setValue:[UIColor defaultPlaceholderColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_verifyTF setValue:[UIColor defaultPlaceholderColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIButton *clearBtn1 = [_phoneNumberTF valueForKey:@"_clearButton"];
    UIButton *clearBtn2 = [_verifyTF valueForKey:@"_clearButton"];
    [clearBtn1 setImage:[UIImage imageNamed:@"clearBtn"] forState:UIControlStateNormal];
    [clearBtn2 setImage:[UIImage imageNamed:@"clearBtn"] forState:UIControlStateNormal];
    _tipLabel.text = @"";
    _phoneLabel.text = @"";
    _verifyLabel.text = @"";
    _phoneNumberTF.delegate = self;
    _verifyTF.delegate = self;
    agreeProtocol = YES;
    self.navigationItem.leftBarButtonItems = [self createBackButton]; //返回按钮
    [_phoneNumberTF becomeFirstResponder];
}


- (IBAction)protocolBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    agreeProtocol = btn.selected;
}

//获取验证码
- (IBAction)getVerifyCodeBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (![_phoneNumberTF.text validationType:ValidationTypePhone]){
        _tipLabel.text =  @"请输入正确的手机号码";
        return;
    }
    
    [self sendCode];
}

- (IBAction)getVoiceVerifyCodeBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (![_phoneNumberTF.text validationType:ValidationTypePhone]){
        _tipLabel.text =  @"请输入正确的手机号码";
        return;
    }
    
    [self sendVoiceCode];
}


//登录
- (IBAction)loginBtnClick:(id)sender {
    [self loginWithUserName:_phoneNumberTF.text withValidCode:_verifyTF.text isAgree:_protocolBtn.selected];
}


-(void)loginWithUserName:(NSString *)userName withValidCode:(NSString *)code isAgree:(BOOL)agree{
    
    if (![_phoneNumberTF.text validationType:ValidationTypePhone]){
        _tipLabel.text = @"请输入正确的手机号码";
        return;
    }
    
    if (!agree) {
        [self LPShowAletWithContent:@"请先同意《用户协议》和《信息收集及使用规则》"];
        return;
    }
    
    if (code.length <= 0){
        _tipLabel.text = @"请输入验证码";
        return;
    }
    
    _loginBtn.enabled = NO;
    
    FyUserLoginReqeust *task = [[FyUserLoginReqeust alloc] init];
    task.phone = userName;
    task.code = code;
    task.type = type;
    task.businessType = @"registerOrSign";
    [[FyUserCenter sharedInstance] cleanUp];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyUserCenter * model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [model save];
            
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:FYNOTIFICATION_LOGINSUCCESS object:nil];
            [EventHanlder trackCommitRegisterEventWithSuccess:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        }else{
            [EventHanlder trackCommitRegisterEventWithSuccess:NO];
            _tipLabel.text = error.errorMessage;
            _loginBtn.enabled = YES;
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        _loginBtn.enabled = YES;
        _tipLabel.text = error.errorMessage;
    }];
}



//请求协议信息
-(void)loadProtocol{
    
    FyGetUserProtocolRequest *task = [[FyGetUserProtocolRequest alloc] init];
    
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyProtocolListModel * model) {
        [weakSelf configUserProtocolWithModel:model];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        
    }];
}

//配置用户协议信息
- (void)configUserProtocolWithModel:(FyProtocolListModel *)model{
    WS(weakSelf)
    _protocolLabel.numberOfLines = 2;
    _protocolLabel.fy_font = [UIFont systemFontOfSize:13];
    _protocolLabel.fy_color = [UIColor whiteColor];

    H5PageModel *registerProtocolModel = [model registerProtocolModel];
    H5PageModel *rulesProtocolModel = [model rulesProtocolModel];

    _protocolLabel.orignText = [NSString stringWithFormat:@"我已阅读并同意《%@》《%@》", registerProtocolModel.name, rulesProtocolModel.name];
    
    [_protocolLabel fy_setHighlightText:[NSString stringWithFormat:@"《%@》", registerProtocolModel.name] color:[UIColor interspersedColor] backgroundColor:[UIColor textGradientEndColor] tapAction:^(NSString *text, NSRange range) {
        [weakSelf showH5WithModel:registerProtocolModel];
    }];
    
    [_protocolLabel fy_setHighlightText:[NSString stringWithFormat:@"《%@》", rulesProtocolModel.name] color:[UIColor interspersedColor] backgroundColor:[UIColor textGradientEndColor] tapAction:^(NSString *text, NSRange range) {
        [weakSelf showH5WithModel:rulesProtocolModel];
    }];

}

//h5
- (void)showH5WithModel:(H5PageModel *)model{
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = model.name;
    vc.url = [[FyNetworkManger sharedInstance] baseURLWithPath:model.value];
    vc.method = RDWebViewSendMethodGET;

    [self.navigationController pushViewController:vc animated:YES];
    
}



//请求验证码
- (void)sendCode{
    type = @"1";
//    [EventHanlder trackSendRegisterCodeEvent];
//    _verifyCodeBtn.enabled = NO;
//    [self showGif];
//    FyVerificationCodeRequest *task = [[FyVerificationCodeRequest alloc] init];
//    task.phone = _phoneNumberTF.text;
//    task.type = @"registerOrSign";
//    task.signMsg = [[FyNetworkManger sharedInstance] validateMD5EncryptionBody:[NSString stringWithFormat:@"%@%@",_phoneNumberTF.text,@"register"]];
//    NSLog(@"%@", task.signMsg);
//    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyVerificationCodeModel * model) {
//        [self hideGif];
//        [self.verifyTF becomeFirstResponder];
//        if (error.errorCode == RDP2PAppErrorTypeYYSuccess && model.state == FyVerificationCodeStateSuccess) {
//            [self countDownMethod];
//            _tipLabel.text = nil;
//
//        }else{
//            _tipLabel.text = model.message;
//            _verifyCodeBtn.enabled = YES;
//        }
//
//    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
//        [self hideGif];
//        _verifyCodeBtn.enabled = YES;
//
//    }];
}

- (void)sendVoiceCode{
    type = @"2";
//    self.voiceCodeBtn.enabled = NO;
//    [EventHanlder trackSendRegisterCodeEvent];
//    [self showGif];
//    FyVerificationCodeRequest *task = [[FyVerificationCodeRequest alloc] init];
//    task.phone = _phoneNumberTF.text;
//    task.type = @"voiceSign";
//    task.signMsg = [[FyNetworkManger sharedInstance] validateMD5EncryptionBody:[NSString stringWithFormat:@"%@%@",_phoneNumberTF.text,@"register"]];
//    NSLog(@"%@", task.signMsg);
//    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyVerificationCodeModel * model) {
//        [self hideGif];
//        [self.verifyTF becomeFirstResponder];
//        if (error.errorCode == RDP2PAppErrorTypeYYSuccess && model.state == FyVerificationCodeStateSuccess) {
//        }else{
//            _tipLabel.text = model.message;
//            self.voiceCodeBtn.enabled = YES;
//        }
//
//    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
//        [self hideGif];
//        self.voiceCodeBtn.enabled = YES;
//
//    }];
}


-(void)countDownMethod{
    WS(weakSelf)
    _verifyCodeBtn.enabled = NO;
    [_verifyCodeBtn setTitleColor:[UIColor timeDownBtnColor] forState:UIControlStateNormal];
    [_verifyCodeBtn startCountDownWithSecond:60];
    
    [_verifyCodeBtn countDownChanging:^NSString *(RDCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"%zds 重新获取",second];
        weakSelf.verifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        return title;
    }];
    [_verifyCodeBtn  countDownFinished:^NSString *(RDCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        weakSelf.verifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [countDownButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        return @"重新获取";
    }];
}

#pragma mark - UITextFieldDelegate
//输入框限制位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _tipLabel.text = @"";
    
    NSString *targetString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _phoneNumberTF) {
        if (targetString.length > 0) {
            _phoneLabel.text = @"手机号码";
        }else {
            _phoneLabel.text = @"";
        }
        if (range.length == 1 && string.length == 0) {
            return YES;
        }

        return  textField.text.length < 11;
    }
    
    if (textField == _verifyTF) {
        if (targetString.length > 0) {
            _verifyLabel.text = @"验证码";
        }else {
            _verifyLabel.text = @"";
        }
        if (range.length == 1 && string.length == 0) {
            return YES;
        }

        return  textField.text.length < 4;
    }
    
    return YES;
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
