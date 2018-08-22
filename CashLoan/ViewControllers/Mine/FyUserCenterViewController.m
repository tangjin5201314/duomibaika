//
//  FyUserCenterViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUserCenterViewController.h"
#import "FyGetUserInfoRequest.h"
#import "FyUserCenterModel.h"
#import "FyH5PageUtil.h"
#import "FyHelpViewController.h"
#import "FyFeedBackViewController.h"
#import "FyApproveStepUtil.h"
#import "FySettingViewController.h"
#import "FyLoanHistoryViewController.h"
#import "FyAuthStateRequest.h"
#import "AuthStateModel.h"
#import "FyBindingBankViewController.h"
#import "FyBankCardInfoViewController.h"
#import "FySafeCenterMotherViewController.h"
#import "FYCustomerService.h"
#import "FyLoginUtil.h"
#import "FYPopupManger.h"
#import "FyShareAppRequest.h"
//#import "FYShareUtil.h"
#import "NSString+fyUrl.h"

@interface FyUserCenterViewController (){
    NSURLSessionTask *userInfoTask;
    NSURLSessionTask *bankTask;

}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *adLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountLabel;

@property (nonatomic, strong) FyUserInfoV2 *model;

@property (nonatomic, strong) IBOutlet UITableViewCell *headerCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *loginCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *helpCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *securityCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *onlineServiceCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *feedbackCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *aboutUsCell;

@end

@implementation FyUserCenterViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBadge) name:NOTICE_NEWMESSAGE object:nil];
    [self cell:self.feedbackCell setHidden:YES];
    [self reloadDataAnimated:NO];

    _unreadCountLabel.hidden = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [UIColor whiteColor];

//    [self reloadBadge];
    [[FYPopupManger sharedInstance] requestAnnouncements];
    [[FYPopupManger sharedInstance] requestCheckUpdate];
    [self loadUserInfoComplete:nil];
    
    [self cell:self.loginCell setHidden:[FyUserCenter sharedInstance].isLogin];
    [self reloadDataAnimated:NO];
//    [self refreshUserCenterInfo];


}

- (void)reloadBadge{
    NSInteger unreadCount = 0;
    if ([FyUserCenter sharedInstance].isLogin) {
        unreadCount = [[FYCustomerService defaultService] unreadCount];
    }
    self.unreadCountLabel.hidden = unreadCount > 0 ? NO : YES;
    self.unreadCountLabel.text = [NSString stringWithFormat:@"%ld", (long)unreadCount];
}


//加载用户信息
- (void)loadUserInfoComplete:(void(^)(void)) complete{
    FyGetUserInfoRequest *task = [[FyGetUserInfoRequest alloc] init];
    
    [userInfoTask cancel];
    userInfoTask = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyUserInfoV2 *model) {
        _model = model;
        _titleLabel.text = model.infoTitle;
        _tipLabel.text = model.infoDesc;
        _adLabel.text = model.infoSlogan;
//        _AMorPMLabel.text = _model.AMorPM;
        if (complete) {
            complete();
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (complete) {
            complete();
        }
        
        if ([FyUserCenter sharedInstance].isLogin) {
            [self cell:self.loginCell setHidden:YES];
            [self reloadDataAnimated:NO];
            self.titleLabel.text = @"Hi 老铁，差钱不~";
            self.tipLabel.text = @"按时还款，即可享受提额~";
        }else{
            self.titleLabel.text = @"富卡";
            self.tipLabel.text = @"满足您的微小心愿~";
        }
        
    }];
}

- (IBAction)loginBtnClick:(id)sender {
//    UIButton *btn = (UIButton *)sender;
    [FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self];

}

- (IBAction)threeBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
        switch (btn.tag) {
            case 1000:
                {
                //提额
                    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
                        [self approveBtnClick:sender];
                    }
                }
                break;
            case 2000:
            {
               //银行卡
                if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
                    if ([[FyUserCenter sharedInstance].userName isEqualToString:@"15668013026"]) {
                        [self LPShowAletWithContent:@"请先认证基本信息！"];
                        return;
                    }
                    [self myBankCardBtnClick:sender];
                }
            }
                break;
            case 3000:
            {
               //邀请好友
                [self share];
                
            }
                break;
                
            default:
                break;
        }
        
}

//点击认证中心
- (void)approveBtnClick:(id)sender {

    FyApproveCenterViewController *approveCenter = [FyApproveCenterViewController loadFromStoryboardName:@"FyApproveCenterStoryboard" identifier:nil];
    [self.navigationController pushViewController:approveCenter animated:YES];
}


//点击我的银行卡
- (void)myBankCardBtnClick:(id)sender {
    if (_model.idState) {
        //可以绑卡
        if (_model.bankCardState) {
            //重新绑卡
            FyBankCardInfoViewController *vc = [FyBankCardInfoViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //开始绑卡
            FyBindingBankViewController *vc = [FyBindingBankViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self approveBtnClick:nil];
    }
}

//重新绑卡
- (void)bankCardInfo{
    FyBankCardInfoViewController *vc = [FyBankCardInfoViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)bandingCard{
    //绑卡
    FyBindingBankViewController *vc = [FyBindingBankViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoApproveCenter {
    //认证中心
    UIViewController *vc = [FyApproveStepUtil approveCenterViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickTrueName:(BOOL)autoNext{
    UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyApproveStepTureName autoNext:autoNext];
    [self.navigationController pushViewController:vc animated:YES];
}

    
//帮助
- (void)pushToHelp{
    FyHelpViewController *vc = [[FyHelpViewController alloc] init];
    vc.url = _model.helpCenter;
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}

//客服
- (void)pushToInLineHelp{
//    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
//        [[FYCustomerService defaultService] openCustomerServicePageFromViewController:self];
//    }
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = @"在线客服";
    vc.url = [_model.custom fy_UrlString];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}

//意见反馈
- (void)pushToFeedback{
    FyFeedBackViewController *vc = [FyFeedBackViewController loadFromStoryboardName:@"FyFeedbackStoryboard" identifier:nil];

    [self.navigationController pushViewController:vc animated:YES];
}

//关于我们
- (void)pushToAboutUs{
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = @"关于我们";
    vc.url = _model.aboutUS;
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}


//安全中心
- (void)pushToSecurityCenter{
    FySafeCenterMotherViewController *vc = [FySafeCenterMotherViewController loadFromStoryboardName:@"FyLoginStoryboard" identifier:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (!self.model) return;//没数据时不做响应
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.helpCell]) {
        [self pushToHelp];
        return;
    }
    if ([cell isEqual:self.aboutUsCell]) {
        [self pushToAboutUs];
        return;
    }
    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        
        if ([cell isEqual:self.onlineServiceCell]) {
            [self pushToInLineHelp];
        }
    
        if ([cell isEqual:self.feedbackCell]) {
            [self pushToFeedback];
        }
    

        
        if ([cell isEqual:self.securityCell]) {
            [self pushToSecurityCenter];
        }
        
    }

    
}

- (void)share{
//    if (![FYShareUtil  hasSuportPlatforms]){
//        [self fy_toastMessages:@"暂无支持分享的平台！"];
//        return;
//    }
//    [self showGif];
//    FyShareAppRequest *t = [[FyShareAppRequest alloc] init];
//    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
//        [self hideGif];
//        if (error.errorCode == RDP2PAppErrorTypeYYSuccess && model){
//            [FYShareUtil shareWithShareObjectModel:model];
//        }else{
//            if (error.errorCode != NSURLErrorCancelled) {
//                [self fy_toastMessages:error.errorMessage];
//            }
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
//        [self hideGif];
//        if (error.errorCode != NSURLErrorCancelled ) {
//            if (error.errorCode != NSURLErrorCancelled) {
//                [self fy_toastMessages:error.errorMessage];
//            }
//        }
//    }];
    
}

@end
