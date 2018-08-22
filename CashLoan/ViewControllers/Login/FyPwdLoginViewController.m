//
//  FyPwdLoginViewController.m
//  CashLoan
//
//  Created by lilianpeng on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyPwdLoginViewController.h"
#import "RichLabel.h"
#import "H5PageModel.h"
#import "FyProtocolListModel.h"
#import "FyGetUserProtocolRequest.h"
#import "FyPhoneLoginSmsCodeViewController.h"
#import "RDWebViewController.h"
#import "FyUserLoginReqeust.h"
#import "NSString+Validation.h"
#import "NSString+fyBase64.h"
#import "DataBaseManager.h"
#import <AdSupport/AdSupport.h>
#import "FyPhoneLoginViewController.h"
#import <LCActionSheet/LCActionSheet.h>
#import "NSString+fyUrl.h"

@interface FyPwdLoginViewController ()<UITextFieldDelegate>{
    BOOL agreeProtocol;
//    H5PageModel *registerProtocolModel;
//    H5PageModel *rulesProtocolModel;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet RichLabel *protocolLabel;

@property (nonatomic, strong) NSArray *protocolList; //协议列表
@property (nonatomic, strong) NSArray *protocolUrlList; //协议列表

@end

@implementation FyPwdLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self configSubviews];
    [self loadProtocol];
    agreeProtocol = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    //输入框
    //    [_phoneNumberTF setValue:[UIColor colorWithHexString:@"9798999"] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIButton *clearBtn1 = [_phoneNumberTF valueForKey:@"_clearButton"];
    [clearBtn1 setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    _phoneNumberTF.delegate = self;
    UIButton *clearBtn2 = [_pwdTF valueForKey:@"_clearButton"];
    [clearBtn2 setImage:[UIImage imageNamed:@"icon_Invisible"] forState:UIControlStateNormal];
    _pwdTF.delegate = self;
    _phoneNumberTF.text = self.phoneNumber;
    if (self.phoneNumber.length > 0) {
        [_pwdTF becomeFirstResponder];
    }else{
        [_phoneNumberTF becomeFirstResponder];
    }
}

-(void)loginWithUserName:(NSString *)userName passWord:(NSString *)password isAgree:(BOOL)agree{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    if (!agree) {
        NSString *str = @"请先同意《注册相关协议》";
        [self LPShowAletWithContent:str];
        return;
    }

    if (userName.length <= 0){
        [self fy_toastMessages:@"请输入手机号"];
        return;
    }
    if (password.length <= 0){
        [self fy_toastMessages:@"请输入登录密码"];
        return;
    }
    if (![_phoneNumberTF.text validationType:ValidationTypePhone]){
        [self fy_toastMessages:@"手机号格式错误"];
        return;
    }
    if (![_pwdTF.text validationType:ValidationTypePassword]){
        [self fy_toastMessages:@"登录密码为6~16位字符，包括数字和字母"];
        return;
    }
    [self showGif];
    FyEasyRequest *task = [[FyEasyRequest alloc] init];
    task.loadUrlPath = API_SERVICE_CODE_PWDLOGIN;
    task.loadParams = @{@"loginName":_phoneNumberTF.text,
                        @"loginPwd":[_pwdTF.text md5String],
                        @"registerCoordinate":@"",
                        @"registerAddr":@"",
                        @"blackBox":idfa
                        };
    task.loadModelClass = [FyUserCenter class];
    [[FyUserCenter sharedInstance] cleanUp];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyUserCenter * model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            
            [model save];
            [SVProgressHUD showSuccessWithStatus:error.errorMessage];
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:FYNOTIFICATION_LOGINSUCCESS object:nil];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [self LPShowAletWithContent:error.errorMessage];
            
//            _loginBtn.enabled = YES;
        }
        [self hideGif];
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
//        _loginBtn.enabled = YES;
        [self LPShowAletWithContent:error.errorMessage];
        [self hideGif];
    }];

}

////请求协议信息
- (void)loadProtocol{
    
    self.protocolList = @[@"多米白卡征信调查授权协议",@"多米白卡注册协议"];
    self.protocolUrlList = @[[NSString stringWithFormat:@"%@%@",APP_H5_PRO,YMREFERENCECHECK],[NSString stringWithFormat:@"%@%@",APP_H5_PRO,YMREGISTRATIONAGREEMENT]];
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
//    UIColor *protocolColor = [UIColor colorWithHexString:@"979899"];
    UIColor *protocolColor = [UIColor colorWithHexString:@"333848"];

    _protocolLabel.fy_font = [UIFont systemFontOfSize:15];
    _protocolLabel.fy_color = protocolColor;
    
    _protocolLabel.orignText = @"我已阅读并同意《注册相关协议》";
    [_protocolLabel fy_setHighlightText:@"《注册相关协议》" color:[UIColor textGradientEndColor] backgroundColor:[UIColor whiteColor] tapAction:^(NSString *text, NSRange range) {
        [weakSelf pushToProtocol];
    }];
    
    _protocolLabel.numberOfLines = 0;
}

#pragma mark - UITextFieldDelegate
//输入框限制位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField == _phoneNumberTF) {

        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        
        return  textField.text.length < 11;
    }
    
        if (textField == _pwdTF) {
            if (range.length == 1 && string.length == 0) {
                return YES;
            }
    
            return  textField.text.length < 16;
        }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField.tag == 2000) {
        UIButton *clearBtn = [_pwdTF valueForKey:@"_clearButton"];
        [clearBtn setImage:[UIImage imageNamed:textField.secureTextEntry ?@"icon_visual" : @"icon_Invisible"] forState:UIControlStateNormal];
        textField.secureTextEntry = !textField.secureTextEntry;
        return NO;
    }
    return YES;
}


//登录
- (IBAction)nextBtnClick:(id)sender {

    [self loginWithUserName:_phoneNumberTF.text passWord:_pwdTF.text isAgree:agreeProtocol];
}

//dismiss
- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//切换
- (IBAction)phoneLoginBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//忘记密码
- (IBAction)forgetPwdBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    FyPhoneLoginViewController *loginvc = [[UIStoryboard storyboardWithName:@"FyLoginStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"FyPhoneLoginViewController"];
//    loginvc.phoneType = PhoneTypeFindLoginPwd;
//    [self.navigationController pushViewController:loginvc animated:YES];
}

@end
