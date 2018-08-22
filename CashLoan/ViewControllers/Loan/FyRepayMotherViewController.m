//
//  FyRepayMotherViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRepayMotherViewController.h"
#import "FyRepayViewController.h"
#import "RDPayPasswordView.h"
#import "FyForgetPayPwdViewController.h"
#import "FyCheckOldPayPwdRequest.h"
#import "NSString+fyBase64.h"
#import "FyPayInAdvanceRequest.h"
#import "FySuccessView.h"
#import "FyH5PageUtil.h"
#import "FyAutoDismissResultView.h"
#import "FyFastRepayRequest.h"
//#import "LLPaySdk.h"
#import "FyFastRepayCallbackRequest.h"
#import "FyPwdUtil.h"
#import "FySetLoanPwdRequest.h"

@interface FyRepayMotherViewController ()

@property (nonatomic, weak) FyRepayViewController *container;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic, copy) NSString *payMothed;
@property (nonatomic, strong) id data;

@end

@implementation FyRepayMotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"确认还款";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmRepayBtnClick:(id)sender {
    if ([self.payMothed isEqualToString:@"普通还款"]) {
        [self rePayMothedDefault];
    }else if([self.payMothed isEqualToString:@"快速还款"]){
        [self rePayFast];
    }
//    else{
//        [self LPShowAletWithContent:@"请选择还款方式"];
//    }
}

- (void)forgetPwd{
    //忘记交易密码
    FyForgetPayPwdViewController *vc = [[FyForgetPayPwdViewController alloc] init];
    vc.lastVC = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//设置支付密码
- (void)setPassword:(NSString *)pwd {
    //    [self showGif];
    
    NSLog(@"设置密码");
    [self showGif];
    
    FySetLoanPwdRequest *task = [[FySetLoanPwdRequest alloc] init];
    task.payType = PayTypeSet;
    task.nPwd = pwd;
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            self.isPwd = YES;
            [self validateTradePwdWithPwd:pwd];
        }else{
            if (error.errorCode != NSURLErrorCancelled) {
                 [self fy_toastMessages:error.errorMessage];
            }
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
        if (error.errorCode != NSURLErrorCancelled) {
             [self fy_toastMessages:error.errorMessage];
        }
    }];
}

- (void)rePayMothedDefault{
    if (!self.isPwd) {
        //设置密码 支付
        [FyPwdUtil configPwdWithComplete:^(NSString *pwd1, NSString *pwd2) {
            if ([pwd1 isEqualToString:pwd2]) {
                [self setPassword:pwd2];
            }else{
                [self LPShowAletWithContent:@"两次密码输入有误，请重试"];
            }
        }];
    }else{
        //支付
        [FyPwdUtil checkPwdWithShowTitle:nil Complete:^(NSString *pwd) {
            [self validateTradePwdWithPwd:pwd];
        } forgetPwd:^{
            [self forgetPwd];
        }];
    }
}

- (void)rePayFast{
    FyFastRepayRequest *t = [[FyFastRepayRequest alloc] init];
    t.borrowID = self.borrowID;
    
    [self showGif];
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [weakSelf hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            weakSelf.data = error.responseObject[@"data"];
            [weakSelf hideGif];
//            [weakSelf payToLLPay:error.responseObject[@"data"]];
#pragma mark -- 暂时屏蔽
//            [[LLTokenPaySDK sharedSdk] payApply:error.responseObject[@"data"] inVC:self complete:^(LLPayResult result, NSDictionary *dic) {
//                [weakSelf paymentEnd:result withResultDic:dic];
//            }];
        }else{
             [weakSelf fy_toastMessages:error.errorMessage];
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [weakSelf hideGif];
         [weakSelf fy_toastMessages:error.errorMessage];
    }];
    
}

//- (void)payToLLPay:(NSDictionary *)data {
//    // 进行签名
//    [LLPaySdk sharedSdk].sdkDelegate = self;
//    //接入什么产品就传什么LLPayType
//    [[LLPaySdk sharedSdk] presentLLPaySDKInViewController:self
//                                               withPayType:LLPayTypeRealName
//                                             andTraderInfo:data];
//}
//
//#pragma - mark 支付结果 LLPaySdkDelegate
//- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
//    NSLog(@"resultCode == %d",resultCode);
//    FyFastRepayCallbackRequest *t = [[FyFastRepayCallbackRequest alloc] init];
//    t.borrowID = self.borrowID;
//    t.resultPay = resultCode == kLLPayResultSuccess ? @"SUCCESS":@"FAILURE";
//    t.orderNo = self.data[@"no_order"];
//    t.returnParam = [NSString convertToJSONData:dic];
//
//    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:nil failure:nil];
//
//    if (resultCode == kLLPayResultSuccess) {
//        [self loadFastRepaySuccessView];
//    }else{
//        [self LPShowAletWithContent:[NSString stringWithFormat:@"错误代码%@,%@",dic[@"ret_code"],dic[@"ret_msg"]]];
//    }
//}


- (void)validateTradePwdWithPwd:(NSString *)password{
    FyCheckOldPayPwdRequest *task = [[FyCheckOldPayPwdRequest alloc] init];
    task.pwd = password;
    
    [self showGif];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
            if ([[error.resData objectForKey:@"pass"] integerValue] == 1) {
                //走主动还款接口
                [self requestData];
            }else{
                [self hideGif];
                [self LPShowAletWithContent:@"交易密码错误"];
            }
        }else
        {
            [self hideGif];
             [self fy_toastMessages:error.errorMessage];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
         [self fy_toastMessages:error.errorMessage];
    }];
}

-(void)requestData{
    FyPayInAdvanceRequest *task = [[FyPayInAdvanceRequest alloc] init];
    task.borrowID = self.borrowID;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self hideGif];
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            [self loadSuccessView];
        }else{
            [self loadTipView];
        }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self hideGif];
         [self fy_toastMessages:error.errorMessage];

    }];
}

- (void)loadSuccessView{
    WS(weakSelf)
    FySuccessView *view = [FySuccessView loadNib];
    view.popBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    view.titleLabel.text = @"还款提交成功";
    view.tipLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    view.tipLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    view.tipLabel.numberOfLines = 0;

    NSString *str = [NSString  stringWithFormat:@"实际还款时间以银行划扣时间为准。如有问题，请致电客服%@（9:00~18:00）", [FyH5PageUtil phoneNumber]];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    text.yy_font = [UIFont systemFontOfSize:14];
    text.yy_color = [UIColor subTextColor];
    text.yy_lineSpacing = 5;
    NSString *str1 = [FyH5PageUtil phoneNumber];
    NSRange range1 = [str rangeOfString:str1 ];
    
    [text yy_setTextHighlightRange:range1
                             color:[UIColor textLinkColor]
                   backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             
                             NSLog(@"点击了电话");
                             [FyH5PageUtil call];
                         }];

    view.tipLabel.attributedText = text;
    [view show];
    
}

- (void)loadTipView{
    WS(weakSelf)
    FyAutoDismissResultView *view = [FyAutoDismissResultView loadNib];
    view.dismissBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [view.imageView setImage:[UIImage imageNamed:@"icon_failed"]];
    view.titleLabel.textColor = [UIColor promptColor];
    view.titleLabel.text = @"还款失败";
    view.contentLabel.text = @"很抱歉，暂不支持提前还款，请您稍后再试";
    [view show];
}

- (void)loadFastRepaySuccessView {
    WS(weakSelf)
    FyAutoDismissResultView *view = [FyAutoDismissResultView loadNib];
    view.dismissBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    view.titleLabel.text = @"还款成功";
    view.contentLabel.text = @"";
    [view show];
}


- (void)call {
    [self LPShowAletWithTitle:[FyH5PageUtil phoneNumber] Content:@"" left:@"取消" right:@"拨打" leftClick:^{
    } rightClick:^{
        //拨打电话
        [self makeCall:[FyH5PageUtil phoneNumber]];
    }];
}

- (void)makeCall:(NSString *)phoneNumber {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WS(weakSelf)
    if ([segue.identifier isEqualToString:@"payinadvancecontainerview"]) {
        FyRepayViewController *vc = [segue destinationViewController];
        self.container = vc;
        vc.borrowID = self.borrowID;
        vc.moneyBlock = ^(NSString *dueAmount, BOOL isPwd) {
            weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%@元",dueAmount];
            weakSelf.isPwd = isPwd;
        };
        vc.selectPayMethodBlock = ^(NSString *typeString, NSInteger index) {
            weakSelf.payMothed = typeString;
        };
    }
}

@end
