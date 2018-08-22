//
//  FyHomeViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeViewController.h"
#import "FyApproveStepUtil.h"
#import "TXScrollLabelView.h"
#import "FyHomeGetNewLoanMsgRequest.h"
#import "FyLoanMsgModel.h"
#import "FyHomePageStateRequest.h"
#import "FyHomeStatusModel.h"
#import "FyHomeLoanView.h"
#import "FyHomeWaitingForViewView.h"
#import "LPReviewFailView.h"
#import "FyHomeInitiativeRefundFailView.h"
#import "FyWaitingRefundView.h"
#import "HomeStatusBaseView.h"
#import "FyLoginUtil.h"
#import "FyUserCenter.h"
#import "FyUserCenterMotherViewController.h"
#import "EventHanlder.h"
#import "FyNoDataView.h"
#import "FyLoanDetailViewController.h"
#import "FYCustomerService.h"
#import "FyH5PageUtil.h"
#import "FyHelpViewController.h"
#import "HexColor.h"
#import "FyCalculateBorrowRequest.h"
#import "LoanApplyModel.h"
#import "FyConfrmLoanViewController.h"
#import "FYPopupManger.h"
#import "FyLoginStatRequest.h"
#import "FYCustomerService.h"
#import "FyPwdUtil.h"

@interface FySelectDayMoneyModel : NSObject

@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *day;

@end

@implementation FySelectDayMoneyModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.money = @"800";
        self.day = @"14";
    }
    return self;
}

@end

@interface FyHomeViewController ()<FYHomePagePickerDelegate, FYHomePagePickerDataSource>{
    NSURLSessionDataTask *_home_task;
    NSURLSessionDataTask *_calculate_task;

}
@property (nonatomic, strong) UIButton *meBtn; //导航右侧按钮， 个人中心

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (nonatomic, weak) IBOutlet UIView *conentView;
@property (nonatomic, weak) IBOutlet UIView *noticeBarConentView;

@property (nonatomic, weak) IBOutlet TXScrollLabelView *noticeBar;
@property (nonatomic, strong) FyHomeStatusModel *homeModel;
@property (nonatomic, strong) UIView *actionView; //当前主页试图
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) FySelectDayMoneyModel *selectModel;
@property (nonatomic, strong) CalculateBorrowDataModel *calculateModel; //计算利息model


@end

@interface FyHomeViewController(){
    BOOL hasLogout;
}
@end

@implementation FyHomeViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)logout{
    [EventHanlder login:nil];
    [[FYCustomerService defaultService] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[FyUserCenter sharedInstance] cleanUp];
    [FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self];
}

- (void)uploadStatistics {
    FyLoginStatRequest *t = [[FyLoginStatRequest alloc] init];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:nil failure:nil];
}


- (void)loginSuccess{
    [EventHanlder login:[FyUserCenter sharedInstance].userId];
    [self uploadStatistics];
    [self loadHomeTask];
    hasLogout = NO;
}

-(void)filterErrorType:(NSNotification*)notification{
    /*
    FyResponse *error = notification.userInfo[@"error"];
    if (error.errorCode == RDP2PAppErrorTypeTokenTimeOut) {
        if (hasLogout) return;
        hasLogout = YES;
         [self fy_toastMessages:error.errorMessage];
        //需要退出用户 跳转到登陆界面
        [self logout];
    }else
    if (error.errorCode == RDP2PAppErrorTypeRefreshTokenTimeOut ){
        if (hasLogout) return;
        hasLogout = YES;

         [self fy_toastMessages:error.errorMessage];
        //需要退出用户 跳转到登陆界面
        [self logout];
    }else
    if (error.errorCode == RDP2PAppErrorTypeUserLock){
        [SVProgressHUD dismiss];
    }else
    if (error.errorCode == RDP2PAppErrorTypeTokenNotOtherLogin || error.errorCode == RDP2PAppErrorTypeTokenNotUnique){
        [SVProgressHUD dismiss];
        [[FyUserCenter sharedInstance] cleanUp];
        if (hasLogout) return;
        hasLogout = YES;

        [self fyShowAletWithContent:@"你的账号已在其他设备登录，如非本人操作请及时修改密码" left:@"取消" right:@"重新登录" leftClick:^{
            [self logout];
        } rightClick:^{
            [self logout];
        }];
    }
    //功能冻结联系客服
    else if (error.errorCode == RDP2PAppErrorTypeUserFreezeRecharge || error.errorCode == RDP2PAppErrorTypeUserFreezeCash || error.errorCode == RDP2PAppErrorTypeUserFreezeInvest || error.errorCode == RDP2PAppErrorTypeUserFreezeRealize || error.errorCode == RDP2PAppErrorTypeUserFreezeBond || error.errorCode == RDP2PAppErrorTypeUserFreezeLoan || error.errorCode == 401){
        [SVProgressHUD dismiss];
        
    }
    else if (error.errorCode != RDP2PAppErrorTypeYYSuccess && error.errorCode != NSURLErrorCancelled){
        if (![error.errorMessage isEqualToString:@"手机号码或验证码错误"]) {
             [self fy_toastMessages:error.errorMessage];
            
        }
    }
    */
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"富卡";
    [self configNavigationBar];
    [self configNoticeBar];
    [self loadNewLoanMsg];
    
//    self.extendedLayoutIncludesOpaqueBars = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:FYNOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:FYNOTIFICATION_LOGINSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterErrorType:) name:NOTICE_AppErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBadge) name:NOTICE_NEWMESSAGE object:nil];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.contentViewHeightConstraint.constant = MAX(CGRectGetHeight(self.view.frame)-85, 450);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadHomeTask];
    [self reloadBadge];
    [[FYPopupManger sharedInstance] requestAnnouncements];
    [[FYPopupManger sharedInstance] requestCheckUpdate];

}

- (FySelectDayMoneyModel *)selectModel{
    if (!_selectModel) {
        _selectModel = [[FySelectDayMoneyModel alloc] init];
    }
    return _selectModel;
}

- (void)reloadBadge{
    self.meBtn.selected = [[FYCustomerService defaultService] unreadCount] > 0 ? YES : NO;
}


//消息栏配置
- (void)configNoticeBar{
    self.noticeBar.scrollSpace = 5;
    self.noticeBar.font = [UIFont systemFontOfSize:14];
    self.noticeBar.backgroundColor = [UIColor clearColor];
    self.noticeBar.scrollType = TXScrollLabelViewTypeFlipRepeat;
    self.noticeBar.textAlignment = NSTextAlignmentLeft;
    self.noticeBar.scrollVelocity = 3;

}

//左右导航按钮
- (void)configNavigationBar {
    self.meBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.meBtn.frame = CGRectMake(0, 0, 30, 30);
    [self.meBtn addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    [self.meBtn setImage:[UIImage imageNamed:@"topbar-my"] forState:UIControlStateNormal];
    [self.meBtn setImage:[UIImage imageNamed:@"my_badge"] forState:UIControlStateSelected];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"topbar-help"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarClick)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.meBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)rightBarClick{
    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        FyUserCenterMotherViewController *vc = [FyUserCenterMotherViewController loadFromStoryboardName:@"FyMineStoryboard" identifier:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)leftBarClick{
    [self pushToHelp];
}

//帮助
- (void)pushToHelp{
    FyHelpViewController *vc = [[FyHelpViewController alloc] init];
    vc.url = [FyH5PageUtil urlPathWithType:FyH5PageTypeHelp];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}

//根据model判断当前该显示那个界面
- (void)layoutActionView{
    if (!self.homeModel.isBorrow) {
        self.contentViewHeightConstraint.constant = MAX(CGRectGetHeight(self.view.frame)-85, 400);
        [self loadLoanViewLayout];
    }else{
        self.contentViewHeightConstraint.constant = MAX(CGRectGetHeight(self.view.frame)-85, 450);
        LoanStatusItemModel *item = [self.homeModel defaultLoanStautsItem];
        if (item) {
            switch (item.type) {
                case LoanHomeTypeInView:
                case LoanHomeTypeHasLoan:
                case LoanHomeTypeInRefund:
                case LoanHomeTypeOverdueInRefund:
                    //待审核
                    [self loadWaitingForReviewLayout];
                    break;
                    
                case LoanHomeTypeNoPass:
                    [self loadReviewFailLayout];
                    break;
                    
                case LoanHomeTypeWaitingRefund:
                case LoanHomeTypeOverdue:
                case LoanHomeTypeBillBae:
                {
                    if (item.repayRecordModel) {
                        [self initiativeRefundFailLayout];
                    }else{
                        [self waitingRefundLayout];
                    }
                }
                    break;

                default:
                    break;
            }
        }else{
            //提示网络不好
        }
    }
}

//默认借款界面
- (void)loadLoanViewLayout{
    FyHomeLoanView *loanView;
    if (self.actionView && [self.actionView isKindOfClass:[FyHomeLoanView class]]) {
        loanView = (id)self.actionView;
    }else{
        if (self.actionView) {
            [self.actionView removeFromSuperview];
            self.actionView = nil;
        }
        
        loanView = [FyHomeLoanView loadNib];
        self.actionView = loanView;
        loanView.pickerView.delegate = self;
        loanView.pickerView.dataSource = self;
        [self.conentView addSubview:loanView];
        
        [loanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        WS(weakSelf)
        loanView.actionBlock = ^{
            [weakSelf applyLoanIfNeed];
        };
    }
    [loanView.pickerView reloadData];
    [loanView.pickerView selectValue:@"1000" inComponent:0 animated:NO];
    [loanView.pickerView selectValue:@"21" inComponent:1 animated:NO];


}

//等待审核界面
- (void)loadWaitingForReviewLayout{
    LoanStatusItemModel *item = [self.homeModel defaultLoanStautsItem];

    [self loadLayoutWithClass:[FyHomeWaitingForViewView class] action:^{
        if (item.type == LoanHomeTypeInRefund || item.type == LoanHomeTypeOverdueInRefund) {
            [self loadLoanDetailVC];
        }else{
            [self loadHomeTask];
        }
    }];
}

//审核失败界面
- (void)loadReviewFailLayout{
    [self loadLayoutWithClass:[LPReviewFailView class] action:nil];
}

//主动还款失败
- (void)initiativeRefundFailLayout{
    [self loadLayoutWithClass:[FyHomeInitiativeRefundFailView class] action:^{
        [self loadLoanDetailVC];
    }];
}

//待还款
- (void)waitingRefundLayout{
    [self loadLayoutWithClass:[FyWaitingRefundView class] action:^{
        [self loadLoanDetailVC];
    }];
}

//nodata
- (void)noDataLayout{
    [self loadLayoutWithClass:[FyNoDataView class] action:^{
        [self loadHomeTask];
    }];
    self.actionView.backgroundColor = [UIColor clearColor];
}

//根据class创建出不同界面的试图
- (void)loadLayoutWithClass:(Class)class action:(void(^)(void)) actionBlock{
    HomeStatusBaseView * view;
    if (self.actionView && [self.actionView isKindOfClass:class]) {
        view = (id)self.actionView;
    }else{
        if (self.actionView) {
            [self.actionView removeFromSuperview];
            self.actionView = nil;
        }
        
        view = [class loadNib];
        self.actionView = view;
        view.actionBlock = actionBlock;
        [view configWithHomeStatusModel:self.homeModel];
        view.backgroundColor = [UIColor whiteColor];
        [self.conentView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.conentView.left).offset(20);
            make.right.mas_equalTo(self.conentView.right).offset(-20);
            make.height.mas_equalTo(@450);
            make.top.mas_equalTo(@20);
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//借款详情
- (void)loadLoanDetailVC {
    //借款详情
    FyLoanDetailViewController *vc = [FyLoanDetailViewController loadFromStoryboardName:@"LoanStoryboard" identifier:nil];
    vc.borrowID = [self.homeModel defaultLoanStautsItem].borrowId;
    vc.borrowState = (LoanState)[self.homeModel defaultLoanStautsItem].type;
    [self.navigationController pushViewController:vc animated:YES];;
}


//请求最近几条借款消息展示
- (void)loadNewLoanMsg{
    FyHomeGetNewLoanMsgRequest *task = [[FyHomeGetNewLoanMsgRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        [self showLoanMsgWithLoanListModel:model];
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        
    }];

}

//请求首页数据
- (void)loadHomeTask{
    [_home_task cancel];
    FyHomePageStateRequest *task = [[FyHomePageStateRequest alloc] init];
    self.scrollView.hidden = YES;
    _home_task = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            self.homeModel = model;
            [self layoutActionView];
            self.noticeBarConentView.hidden = NO;
            [self loadNewLoanMsg];
        }else{
            self.noticeBarConentView.hidden = YES;
            [self noDataLayout];
        }
        self.scrollView.hidden = NO;

    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (error.errorCode != NSURLErrorCancelled) {
            self.noticeBarConentView.hidden = YES;
            [self noDataLayout];
            self.scrollView.hidden = NO;
        }
    }];
}

- (void)showLoanMsgWithLoanListModel:(FyLoanMsgListModel *)listModel{
    NSMutableArray *texts = [@[] mutableCopy];
    [listModel.list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [texts addObject:[(FyLoanMsgModel *)obj value]];
    }];
    
    self.noticeBar.scrollTexts = texts;
}

- (NSInteger)fyNumberOfComponent{
    return 2;
}
- (NSString *_Nonnull)titleInComponent:(NSInteger)component{
    if (component == 0) {
        return @"元";
    }
    return @"天";
}
- (NSString *)withFitTitleInComponent:(NSInteger)component{
    if (component == 0) {
        return self.homeModel.maxCredit.length > 0 ? self.homeModel.maxCredit : @"3000";
    }
    return self.homeModel.maxDays.length > 0 ? self.homeModel.maxDays : @"30";
    
}

- (NSInteger)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView numberOfRowInComponent:(NSInteger)component{
    if (component == 0) {
        return self.homeModel.creditList.count;
    }
    return self.homeModel.dayList.count;
}
- (nullable NSString *)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.homeModel.creditList[row];
    }
    return self.homeModel.dayList[row];
    
}

- (void)fyPickerView:(FyHomePagePickerView *_Nonnull)fyPickerView didSelectRow:(NSInteger)row forComponent:(NSInteger)component{
    NSLog(@"select row %ld in component %ld", (long)row, (long)component);
    
    if (component == 0) {
        row = MIN(self.homeModel.creditList.count-1, row);
    }else{
        row = MIN(self.homeModel.dayList.count-1, row);
    }
    row = MAX(0, row);

    if (self.homeModel.creditList.count > 0 && self.homeModel.dayList.count > 0){
        if (component == 0) {
            self.selectModel.money = self.homeModel.creditList[row];
        }else{
            self.selectModel.day = self.homeModel.dayList[row];
        }
        
        if (self.homeModel.auth.qualified) {
            if (self.selectModel.money.intValue > self.homeModel.maxAllowMoney.intValue) {
//                [SVProgressHUD setImageViewSize:CGSizeMake(45, 39)];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD setCornerRadius:5];
                [SVProgressHUD setBackgroundColor:[UIColor fy_colorWithHexString:@"#000000" alpha:0xa0/255.0]];
                [SVProgressHUD showImage:[UIImage imageNamed:@"toast_icon_heart"] status:@"保持良好信用，即可提额"];
                [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
                [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
                
                [fyPickerView selectValue:self.homeModel.maxAllowMoney inComponent:0 animated:YES];
            }else{
                [self calculateBorrowComplete:nil];
            }

        }
    }
    
}

- (NSTextAlignment)textAlignmentInComponent:(NSInteger)component{
    if (component == 0) {
        return NSTextAlignmentLeft;
    }
    return NSTextAlignmentRight;
}


- (void)applyLoanIfNeed{
    if (![FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) return;
    if (self.homeModel.auth.result == 0) {
        [self pushToTrueNameApprove];
        return;
    }
    
    if (self.homeModel.auth.qualified == 0) {
        [self pushToApproveCenter];
        return;
    }

    [self applyLoan];
}

- (void)pushToTrueNameApprove{
    UIViewController *vc = [FyApproveStepUtil approveStepViewControllerWithStep:FyApproveStepTureName autoNext:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToApproveCenter{
    UIViewController *vc = [FyApproveStepUtil approveCenterViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)calculateBorrowComplete:(void(^)(void))complete{
    self.calculateModel = nil;
    [_calculate_task cancel];
    
    FyCalculateBorrowRequest *t = [[FyCalculateBorrowRequest alloc] init];
    t.day = self.selectModel.day;
    t.money = self.selectModel.money;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        self.calculateModel = model;
        if (complete) {
            complete();
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (complete) {
            complete();
        }
    }];
}

- (void)applyLoan{
    if (!self.homeModel) return;
    if (!self.calculateModel) {
        [self showGif];
        [self calculateBorrowComplete:^{
            [self hideGif];
            if (self.calculateModel) {
                [self applyLoan];
            }
        }];
        return;
    }
    
    if (!self.calculateModel.fee || !self.calculateModel.realAmount) return;
    
    [EventHanlder trackApplyLoanEventWithProductName:nil amount:[self.selectModel.money toFloat] dayLimit:[self.selectModel.day integerValue]];
    
    LoanApplyModel *applyModel = [[LoanApplyModel alloc] init];
    applyModel.timeLimit = self.selectModel.day;
    applyModel.amount = self.selectModel.money;
    applyModel.bankNum = self.homeModel.cardNo ? : @"";
    applyModel.bankName = self.homeModel.cardName ? : @"";
    applyModel.fee = self.calculateModel.fee;
    applyModel.realAmount = self.calculateModel.realAmount;
    applyModel.cardId = self.homeModel.cardId ? : @"";
    applyModel.isPwd = self.homeModel.isPwd;
    applyModel.indexBankNum = [self.homeModel formatCardNO];
    
    if (applyModel.realAmount.integerValue > applyModel.amount.integerValue) {
        [self LPShowAletWithContent:@"请重新选择借款天数跟金额"];
        return;
    }
    
    FyConfrmLoanViewController *vc = [FyConfrmLoanViewController loadFromStoryboardName:@"LoanStoryboard" identifier:nil];
    vc.model = applyModel;
    vc.calculateModel = self.calculateModel;
    [self.navigationController pushViewController:vc animated:YES];
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
