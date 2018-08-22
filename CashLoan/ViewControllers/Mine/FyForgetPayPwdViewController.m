//
//  FyForgetPayPwdViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyForgetPayPwdViewController.h"
#import "FindTradePwdView.h"
#import <Masonry/Masonry.h>
#import "FyUserCenterModel.h"
#import "FyGetUserInfoRequest.h"
#import "FyUserCenterModel.h"
#import "FyVerificationCodeRequest.h"
#import "FyValidateUserRequset.h"
#import "FySetPsdViewCotroller.h"

@interface FyForgetPayPwdViewController ()<FindTradePwdViewDelegate>
@property (nonatomic, strong) FindTradePwdView *findTradePwdView;
@property (nonatomic,strong)FyUserCenterModel *viewModel;

@end

@implementation FyForgetPayPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"找回交易密码";
    
    [self createSubViews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestPhone];
}
-(void)createSubViews
{
    _findTradePwdView = [[FindTradePwdView alloc] initFindTradePwdView];
    _findTradePwdView.FindTradePwdViewDelegate = self;
    [self.view addSubview:_findTradePwdView];
    [_findTradePwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(void)requestPhone{
    FyGetUserInfoRequest *task = [[FyGetUserInfoRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
            if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
                FyUserCenterModel *userInfoModel = [FyUserCenterModel mj_objectWithKeyValues:error.responseObject];
                [_findTradePwdView loadPhoneTF:userInfoModel.data.phone];
            }
            else{
                [self fy_toastMessages:error.errorMessage];
            }

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self fy_toastMessages:error.errorMessage];
    }];

}
-(void)FindTradePwdSendValidCode:(NSString *)phone
{
//    if (phone.length < 11)
//    {
//        [self fy_toastMessages:@"请输入正确的手机号"];
//        return;
//    }
//    _findTradePwdView.getCodeBtn.enabled = NO;
//    [SVProgressHUD show];
//    
//    FyVerificationCodeRequest *task = [[FyVerificationCodeRequest alloc] init];
//    task.phone = phone;
//    task.type = @"findPay";
//    task.signMsg = [[FyNetworkManger sharedInstance] validateMD5EncryptionBody:[NSString stringWithFormat:@"%@%@",phone,@"findPay"]];
//    
//    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyVerificationCodeModel * model) {
//        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
//        {
//            if (model.state == FyVerificationCodeStateSuccess) {
//                [SVProgressHUD showSuccessWithStatus:error.errorMessage];
//                [self countDownMethod];
//            }else{
//                [self fy_toastMessages:[error.resData objectForKey:@"message"]];
//                _findTradePwdView.getCodeBtn.enabled = YES;
//            }
//        }else
//        {
//            _findTradePwdView.getCodeBtn.enabled = YES;
//        }
//
//        
//    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
//        _findTradePwdView.getCodeBtn.enabled = YES;
//    }];

}
-(void)countDownMethod
{
    _findTradePwdView.getCodeBtn.enabled = NO;
    [_findTradePwdView.getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_findTradePwdView.getCodeBtn startCountDownWithSecond:60];
    
    [_findTradePwdView.getCodeBtn countDownChanging:^NSString *(RDCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"%zds 重新获取",second];
        return title;
    }];
    [_findTradePwdView.getCodeBtn  countDownFinished:^NSString *(RDCountDownButton *countDownButton, NSUInteger second) {
        countDownButton.enabled = YES;
        [countDownButton setTitleColor:[UIColor fyThemeColor] forState:UIControlStateNormal];
        return @"重新获取";
    }];
}

- (void)pushToResetPwd{
    FySetPsdViewCotroller *vc = [[FySetPsdViewCotroller alloc] init];
    vc.isForget = YES;
    vc.type = 1;
    vc.lastVC = self.lastVC;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)FindTradePhone:(NSString *)phone withRealName:(NSString *)realName withCardId:(NSString *)CardId withCode:(NSString *)code
{
    _findTradePwdView.resetBtn.enabled = NO;

    FyValidateUserRequset *task = [[FyValidateUserRequset alloc] init];
    task.iDCard = CardId;
    task.realName = realName;
    task.vcode = code;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
            BOOL pass = [[model objectForKey:@"pass"] boolValue];
            if (pass) {
                [self pushToResetPwd];
            }
            else
            {
                [self fy_toastMessages:error.errorMessage];
            }
        }else
        {
            [self fy_toastMessages:error.errorMessage];
        }
        _findTradePwdView.resetBtn.enabled = YES;

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        _findTradePwdView.resetBtn.enabled = YES;
    }];
    
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
