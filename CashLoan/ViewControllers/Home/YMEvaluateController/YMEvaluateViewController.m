//
//  YMEvaluateViewController.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/22.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMEvaluateViewController.h"
#import "YMEvaluateHeaderView.h"
#import "YMEvaluateTableViewCell.h"
#import "LEEAlertManager.h"
#import "YMLeaseTimeLimitViewController.h"
#import "YMTool.h"
#import "FyLoginUtil.h"
#import "FyApproveCenterViewController.h"
#import "FyBindingBankViewController.h"
#import "YMApproveManager.h"

static NSString *const YMEvaluateViewController_cell = @"YMEvaluateViewController_cell";

@interface YMEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMEvaluateHeaderView *headerView;
@property (nonatomic, strong) UIButton *leaseBtn;
@property (nonatomic, strong) NSArray *iconArr;
@property (nonatomic, strong) NSArray *contentArr;
@property (nonatomic, strong) YMApproveManager *approveManager;

@end

@implementation YMEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

//重写父类方法
- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    禁止右滑手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //默认状态栏颜色为白色
    [[FyUserCenter sharedInstance] loadUserInfoData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YMEvaluateViewController_cell];
    [cell displayWithDic:self.iconArr[indexPath.row] content:self.contentArr[indexPath.row]];
    return cell;
}

- (void)setupUI {

    self.view.backgroundColor = [UIColor whiteColor];
    self.nav.backgroundColor = [UIColor clearColor];
    [self.nav setNavLeftItemImage:[UIImage imageNamed:@"topbar-back"] title:nil];
    self.iconArr = @[
                     @{@"title":@"回收流程",@"icon":@"ym_hslc_icon"},
                     @{@"title":@"租赁流程",@"icon":@"ym_zllc_icon"},
                     @{@"title":@"回购流程",@"icon":@"ym_hglc_icon"}
                    ];
    
    self.contentArr = @[@"平台根据用户手机实际情况检测评估，根据平台提供的报价决定是否进行回收。若用户决定回收，平台即刻向用户支付回收金额，平台获取该手机持有权。",
                        @"用户在手机回收后，申请租赁手机一段时间，避免暂时无手机使用。",
                        @"用户在手机租赁到期后，只需要缴纳平台支付的回收金额和租金，即可重新回购本手机，用户又可以获得自己手机的持有权。"
                        ];
    
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.leaseBtn];
    [self.leaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(70);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.equalTo(self.leaseBtn.mas_top).offset(-5);
        make.left.right.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = self.headerView;
    [self.view bringSubviewToFront:self.nav];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"YMEvaluateTableViewCell" bundle:nil] forCellReuseIdentifier:YMEvaluateViewController_cell];
    }
    return  _tableView;
}

- (YMEvaluateHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YMEvaluateHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH + 5, 200)];
        [_headerView displayWithTitle:[YMTool getDeviceName] price:self.model.mobile.assessment_value];
        WS(weakSelf)
        _headerView.applyBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _headerView;
}

- (UIButton *)leaseBtn {
    if (!_leaseBtn) {
        _leaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_leaseBtn setTitle:@"租赁本机" forState:UIControlStateNormal];
        _leaseBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        [_leaseBtn addTarget:self action:@selector(leaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_leaseBtn setBackgroundImage:[UIImage imageNamed:@"btn_signin-1"] forState:UIControlStateNormal];
    }
    return _leaseBtn;
}

- (void)leaseBtnAction {
    
    WS(weakSelf)
    if (![FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        return;
    }

    if (![FyUserCenter sharedInstance].userInfoModel.idState) {
        [self LPShowAletWithContent:@"您还没有完成认证，是否前往认证？" left:@"取消" right:@"确认" rightClick:^{
            [weakSelf approveVC];
        }];
        return;
    }

    [self nextStep];
}

- (void)nextStep {

    WS(weakSelf)
    if (![FyUserCenter sharedInstance].userInfoModel.bankCardState) {
        //可以绑卡
        [self LPShowAletWithContent:@"您还没有绑定银行卡，是否前往绑定？" left:@"取消" right:@"确认" rightClick:^{
            [weakSelf bindBankCard];
        }];
        return;
    }
    
    [self showPactAlert];
}

- (void)bindBankCard {
    //开始绑卡
    FyBindingBankViewController *vc = [FyBindingBankViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//点击认证中心
- (void)approveVC {
//    上传同盾token
    [[FyUserCenter sharedInstance] submitTokenkeyIfNeed];
    
    self.approveManager =  [[YMApproveManager alloc] init];
    WS(weakSelf)
    [self.approveManager loadAprroveData:self block:nil];
    [LEEAlertManager sharedManager].successBlock = ^{
        [weakSelf nextStep];
        [[FyUserCenter sharedInstance] loadUserInfoData];
    };
}

- (void)showPactAlert {
    WS(weakSelf)
    [self YMLeasePactAlertWithTitle:@"开始租赁" Content:@"您在使用多米白卡产品回收租赁手机服务前，请确认已经理解并同意《多米白卡手机融资租赁合同》和《多米白卡居间服务协议》。" left:@"取消" right:@"确认" leftClick:^{
        [LEEAlertManager sharedManager].isPactShow = NO;
    } rightClick:^{
        [LEEAlertManager sharedManager].isPactShow = NO;
        [weakSelf toPushLeaseTimeLimitVC];

    }];
    [LEEAlertManager sharedManager].clickBlock = ^{
        [[LEEAlertManager sharedManager] showTostWithTitle:@"请先阅读并同意《租赁相关协议》"];
    };
}

- (void)toPushLeaseTimeLimitVC {
    //  先判断登录
    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        YMLeaseTimeLimitViewController *vc = [[YMLeaseTimeLimitViewController alloc] init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
