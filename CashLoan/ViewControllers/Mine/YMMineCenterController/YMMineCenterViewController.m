//
//  YMMineCenterViewController.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMMineCenterViewController.h"
#import "FYCustomerService.h"
#import "FYPopupManger.h"
#import "FyGetUserInfoRequest.h"
#import "YMMineNoLoginHeaderView.h"
#import "FyLoginUtil.h"
#import "YMMineLoginHeaderView.h"
#import "YMMineActionCell.h"
#import "FyApproveCenterViewController.h"
#import "FyBankCardInfoViewController.h"
#import "FyBindingBankViewController.h"
#import "YMHomeNormalCell.h"
#import "FySafeCenterMotherViewController.h"
#import "FyHelpViewController.h"
#import "FyFeedBackViewController.h"
#import "YMLeaseRecordViewController.h"

static NSString *const kMinNormolCell = @"kMinNormolCell_cell";
static NSString *const kMineActionCell = @"YMMineAction_cell";

@interface YMMineCenterViewController ()<UITableViewDelegate, UITableViewDataSource> {
//    NSURLSessionTask *userInfoTask;
}

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) FyUserInfoV2 *model;
@property (nonatomic, strong) YMMineNoLoginHeaderView *noLoginHeaderView;
@property (nonatomic, strong) YMMineLoginHeaderView *loginHeaderView;
@property (nonatomic, strong) NSArray *contentArr;


@end

@implementation YMMineCenterViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBadge) name:NOTICE_NEWMESSAGE object:nil];

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [[FYPopupManger sharedInstance] requestAnnouncements];
    [[FYPopupManger sharedInstance] requestCheckUpdate];
    [self loadUserInfoComplete:nil];
}

//加载用户信息
- (void)loadUserInfoComplete:(void(^)(void)) complete{
    if ([FyUserCenter sharedInstance].isLogin) {
        self.tableView.tableHeaderView = self.loginHeaderView;
    } else {
        self.tableView.tableHeaderView = self.noLoginHeaderView;
    }
    [[FyUserCenter sharedInstance] loadUserInfoData];
}

- (void)gotoLogin {
    [FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self];
}

- (void)setupUI {
    
    self.contentArr = @[
                        @{@"title":@"帮助中心",@"img":@"icon_help"},
                        @{@"title":@"密码管理",@"img":@"icon_security"},
                        @{@"title":@"意见反馈",@"img":@"icon_feedback"},
                        @{@"title":@"关于我们",@"img":@"icon_us"}
                        ];
    
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.left.bottom.mas_equalTo(0);
    }];
    
#pragma mark -- 加载table头部视图
    if ([FyUserCenter sharedInstance].isLogin) {
        self.tableView.tableHeaderView = self.loginHeaderView;
    } else {
        self.tableView.tableHeaderView = self.noLoginHeaderView;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor bgColor];
        return bgView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 107;
    }
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        YMMineActionCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineActionCell];
        WS(weakSelf)
        cell.applyBlock = ^(YMMineActionCellType type) {
            [weakSelf actionCellMethod:type];
        };
        return cell;
    }
    
    YMHomeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:kMinNormolCell];
    [cell displayContent:self.contentArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.row == 0) {
        [self pushToHelp];
        return;
    }
    
    if (indexPath.row == 1) {
        [self pushToSecurityCenter];
        return;
    }
    
    if (indexPath.row == 2) {
        [self pushToFeedback];
        return;
    }
    
    if (indexPath.row == 3) {
        [self pushToAboutUs];
        return;
    }
}

//关于我们
- (void)pushToAboutUs{
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = @"关于我们";
    vc.url = [NSString stringWithFormat:@"%@%@",APP_H5_PRO,YMABOUTUS];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}


//意见反馈
- (void)pushToFeedback {
    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        FyFeedBackViewController *vc = [FyFeedBackViewController loadFromStoryboardName:@"FyFeedbackStoryboard" identifier:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//安全中心
- (void)pushToSecurityCenter{
    if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
        FySafeCenterMotherViewController *vc = [FySafeCenterMotherViewController loadFromStoryboardName:@"FyLoginStoryboard" identifier:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//帮助
- (void)pushToHelp{
    FyHelpViewController *vc = [[FyHelpViewController alloc] init];
//    vc.url = [FyUserCenter sharedInstance].userInfoModel.helpCenter;
    vc.url = [NSString stringWithFormat:@"%@%@",APP_H5_PRO,YMHELPCENTER];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)actionCellMethod:(YMMineActionCellType)type {
//    认证中心
    if (type == YMMineActionIdentification) {
        if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
            [self approveBtnClick];
        }
        return;
    }
//    租赁记录
    if (type == YMMineActionLeaseRecord) {
//        先判断登录
        if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
            YMLeaseRecordViewController *vc = [[YMLeaseRecordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
//    银行卡
    if (type == YMMineActionBankCard) {
        //银行卡
        if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
            if ([[FyUserCenter sharedInstance].userName isEqualToString:@"15668013026"]) {
                [self LPShowAletWithContent:@"请先认证基本信息！"];
                return;
            }
            [self myBankCardBtnClick];
        }
    }
}

//点击我的银行卡
- (void)myBankCardBtnClick {
    //开始绑卡
    if ([FyUserCenter sharedInstance].userInfoModel.idState) {
        //可以绑卡
        if ([FyUserCenter sharedInstance].userInfoModel.bankCardState) {
            //重新绑卡
            FyBankCardInfoViewController *vc = [FyBankCardInfoViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //开始绑卡
            FyBindingBankViewController *vc = [FyBindingBankViewController loadFromStoryboardName:@"FyBankCardStoryboard" identifier:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self approveBtnClick];
    }
}

//点击认证中心
- (void)approveBtnClick {
    FyApproveCenterViewController *approveCenter = [FyApproveCenterViewController loadFromStoryboardName:@"FyApproveCenterStoryboard" identifier:nil];
    [self.navigationController pushViewController:approveCenter animated:YES];
}

#pragma mark -- lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor separatorColor];
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.estimatedRowHeight = 100;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"YMMineActionCell" bundle:nil] forCellReuseIdentifier:kMineActionCell];
        [_tableView registerNib:[UINib nibWithNibName:@"YMHomeNormalCell" bundle:nil] forCellReuseIdentifier:kMinNormolCell];

    }
    return  _tableView;
}

- (void)reloadBadge{
    NSInteger unreadCount = 0;
    if ([FyUserCenter sharedInstance].isLogin) {
        unreadCount = [[FYCustomerService defaultService] unreadCount];
    }
}

- (YMMineNoLoginHeaderView *)noLoginHeaderView {
    if (!_noLoginHeaderView) {
        _noLoginHeaderView = [YMMineNoLoginHeaderView loadNib];
        WS(weakSelf)
        _noLoginHeaderView.applyBlock = ^{
            [weakSelf gotoLogin];
        };
    }
    return _noLoginHeaderView;
}

- (YMMineLoginHeaderView *)loginHeaderView {
    if (!_loginHeaderView) {
        _loginHeaderView = [YMMineLoginHeaderView loadNib];
    }
    return _loginHeaderView;
}

@end
