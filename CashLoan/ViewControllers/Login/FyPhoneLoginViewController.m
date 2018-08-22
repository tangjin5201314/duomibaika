//
//  FyPhoneLoginViewController.m
//  CashLoan
//
//  Created by lilianpeng on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyPhoneLoginViewController.h"
#import "RichLabel.h"
#import "H5PageModel.h"
#import "FyProtocolListModel.h"
#import "FyGetUserProtocolRequest.h"
#import "FyPhoneLoginSmsCodeViewController.h"
#import "FyPwdLoginViewController.h"
#import "NSString+Validation.h"
#import "EventHanlder.h"
#import "FyVerificationCodeRequest.h"
#import "RDCountDownButton.h"
#import "RDWebViewController.h"

@interface FyPhoneLoginViewController ()<UITextFieldDelegate>{
    BOOL agreeProtocol;
    H5PageModel *registerProtocolModel;
    H5PageModel *rulesProtocolModel;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet RichLabel *protocolLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *HideBtns;
@property (weak, nonatomic) IBOutlet UITableViewCell *protocolCell;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation FyPhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    agreeProtocol = YES;
    [self configSubviews];
//    if (self.phoneType == PhoneTypeLogin) {
//        [self loadProtocol];
//
//    }else{
        [self cell:_protocolCell setHidden:YES];
        [self reloadDataAnimated:NO];
//    }

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
//    agreeProtocol = YES;
    [_phoneNumberTF becomeFirstResponder];
    switch (_phoneType) {
        case PhoneTypeLogin:
        {
            self.titleLabel.text = @"进入多米白卡";

        }
            break;
        case PhoneTypeFindLoginPwd:
        {
            self.navigationController.navigationBarHidden = NO;
            self.titleLabel.text = @"输入手机号找回密码";
            for (UIView *v in _HideBtns) {
                [v setHidden:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

////请求协议信息
- (void)loadProtocol{
    
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
    UIColor *protocolColor = [UIColor colorWithHexString:@"333848"];
    _protocolLabel.fy_font = [UIFont systemFontOfSize:15];
    _protocolLabel.fy_color = protocolColor;
    
    registerProtocolModel = [model registerProtocolModel];
    rulesProtocolModel = [model rulesProtocolModel];
    
    _protocolLabel.orignText = [NSString stringWithFormat:@"我已阅读并同意《%@》《%@》", registerProtocolModel.name, rulesProtocolModel.name];
    [_protocolLabel fy_setHighlightText:[NSString stringWithFormat:@"《%@》", registerProtocolModel.name] color:[UIColor textGradientEndColor] backgroundColor:[UIColor whiteColor] tapAction:^(NSString *text, NSRange range) {
        [weakSelf showH5WithModel:registerProtocolModel];
    }];
    
    [_protocolLabel fy_setHighlightText:[NSString stringWithFormat:@"《%@》", rulesProtocolModel.name] color:[UIColor textGradientEndColor] backgroundColor:[UIColor whiteColor] tapAction:^(NSString *text, NSRange range) {
        [weakSelf showH5WithModel:rulesProtocolModel];
    }];
    _protocolLabel.numberOfLines = 3;
    
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
    
    if (textField == _phoneNumberTF) {
        if (targetString.length > 0) {
//            _phoneLabel.text = @"手机号码";
        }else {
//            _phoneLabel.text = @"";
        }
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        
        return  textField.text.length < 11;
    }
 
    return YES;
}

//登录
- (IBAction)nextBtnClick:(id)sender {
//    [self loginWithUserName:_phoneNumberTF.text withValidCode:_verifyTF.text isAgree:_protocolBtn.selected];
    [self.view endEditing:YES];
    if (!agreeProtocol) {
        NSString *str = [NSString stringWithFormat:@"请先同意《%@》和《%@》", registerProtocolModel.name, rulesProtocolModel.name];
        [self LPShowAletWithContent:str];
        return;
    }
    if (_phoneNumberTF.text.length == 0) {
        [self LPShowAletWithContent:@"请输入手机号"];
        return;
    }else if (![_phoneNumberTF.text validationType:ValidationTypePhone]){
        [self LPShowAletWithContent:@"手机号格式错误"];
        return;
    }
    FyEasyRequest *task = [[FyEasyRequest alloc] init];
    task.loadUrlPath = URLPATH_IsPhoneExists;
    task.loadParams = @{@"phone" : _phoneNumberTF.text};
    [self smsLogin];
}



//dismiss
- (IBAction)closeBtnClick:(id)sender {
    [self dismissViewControllerAnimated:self completion:nil];
}

//切换
- (IBAction)pwdLoginBtnClick:(id)sender {
    [self pwdLogin];
}

- (void)smsLogin {
    FyPhoneLoginSmsCodeViewController *smsVC = [[UIStoryboard storyboardWithName:@"FyLoginStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FyPhoneLoginSmsCodeViewController"];
    smsVC.phoneNumber = self.phoneNumberTF.text;
    switch (_phoneType) {
        case PhoneTypeFindLoginPwd:
            {
                smsVC.smsType = SMS_ForgetLoginPWD;

            }
            break;
        case PhoneTypeLogin:
        {
            smsVC.smsType = SMS_LoginOrRegister;

        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:smsVC animated:YES];
}

- (void)pwdLogin {
    FyPwdLoginViewController *pwdLoginVC = [[UIStoryboard storyboardWithName:@"FyLoginStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FyPwdLoginViewController"];
    pwdLoginVC.phoneNumber = self.phoneNumberTF.text;  
    [self.navigationController pushViewController:pwdLoginVC animated:YES];
}
         
@end
