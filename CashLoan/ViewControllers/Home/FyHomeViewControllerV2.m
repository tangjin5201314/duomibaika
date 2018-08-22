//
//  FyHomeViewControllerV2.m
//  CashLoan
//
//  Created by fyhy on 2017/11/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeViewControllerV2.h"
#import "FyHomeLoanHeaderView.h"
#import "FyHomeActionView.h"
#import "FyHomeGetNewLoanMsgRequest.h"
//#import "FyLoanMsgModel.h"
#import "FyHomeBannerCell.h"
#import "FyHomePromiseCell.h"
#import "FyConfrmLoanViewControllerV2.h"
#import "FyLoginUtil.h"
#import "FyApproveStepUtil.h"
#import "FyH5PageUtil.h"
#import "FyHelpViewController.h"
#import "FyHomePageStateRequestV2.h"
#import "FyFindIndexModelV2.h"
#import "FyH5PageUtil.h"
#import "FyRootTabBarViewController.h"
#import "NSString+FormatNumber.h"
#import "FyLoanDetailViewControllerV2.h"
#import "FyLoanUtil.h"
#import "FYPopupManger.h"
#import "YMTool.h"
#import "YMProgressViewController.h"
#import "YMHomeHeaderView.h"
#import "YMHomeLeaseFlowCell.h"
#import "LPGifHeader.h"
#import "YMHomeShowAlertManager.h"
#import "YMLeaseDetailViewController.h"
#import "YMHistoryOrderRequest.h"
#import "YMLeaseTimeLimitViewController.h"
#import "FyBankModelRequest.h"
#import "BankCardModel.h"

#define maxPullDownDistance 200
#define kHeaderHeight 570

@interface FyHomeViewControllerV2 ()<UITableViewDelegate, UITableViewDataSource> {
    FyHomeLoanHeaderView *_loanHeaderView;
    FyHomeActionView *_actionView;
    NSURLSessionDataTask *_task;
    
    UILabel *_leftNavBarLabel;
    UIButton *_rightNavBarBtn;
    
    UIView *_navBgView;
    UIImageView *_navBottomLine;
}

@property (nonatomic, strong) FyFindIndexModelV2 *homePageModel;
@property (nonatomic, strong) FyHomeCardModel *headerCard;
@property (nonatomic, strong) YMHomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *historyOrderMArr;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) BankCardModel *bankCardModel;

@end

@implementation FyHomeViewControllerV2
static NSString *const reuseaIdentifier_cell = @"reuseaIdentifier_cell";
static NSString *const reuseaIdentifier_footer = @"reuseaIdentifier_footer";

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGuideView) name:kGuideViewNotification object:nil];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
}

- (void)showGuideView {
    [YMHomeShowAlertManager showGuideViewWithcloseBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self refreshNavigationLayout];
    [[FYPopupManger sharedInstance] requestAnnouncements];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //默认状态栏颜色为白色
    WS(weakSelf)
    [self loadDataComplete:^{
        if (!weakSelf.isFirstLoad) {
            weakSelf.isFirstLoad = YES;
            [weakSelf isShowUnfishedOrder];
        }
    }];
    [[FyUserCenter sharedInstance] loadUserInfoData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)loginStatusChange{
    [self.tableView.mj_header beginRefreshing];
}

- (void)pushLeaseDetailVC {
    YMLeaseDetailViewController *vc = [[YMLeaseDetailViewController alloc] init];
    vc.orderModel = self.homePageModel.UnfishedOrder;
    if (self.bankCardModel == nil) {
        [self requestBankInfo];
        return;
    }
    vc.cardModel = self.bankCardModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applyLoanIfNeed:(BOOL)ret {

//    是否需要登录
    if (ret) {
//        先判断登录
        if (![FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
            return;
        }
    }
    //未加载首页数据，不能进行操作
    if (!self.homePageModel.mobile) {
        [self fy_toastMessages:@"数据加载异常，请重新刷新首页!" hidenDelay:-1];
        return;
    }

    if (self.homePageModel.IsUnfished == 1 || self.homePageModel.IsUnfished == 2) {
        [self fy_toastMessages:@"您有未完成订单，不能租赁" hidenDelay:-1];
        return;
    }
    
    if (self.homePageModel.IsUnfished == 3) {
        //    请求银行信息
        [self requestBankInfo];
#pragma mark -- show 待交租金额
        MJWeakSelf
        [YMHomeShowAlertManager showUnfinishedOrderTipView:self.homePageModel leaseBlock:^{
            [weakSelf pushLeaseDetailVC];
        }];
        return;
    }
    
#pragma mark -- show 租赁历史提示框
    //如果历史订单大于0，弹出显示框
    if ([self isShowHistoryOrder]) {
        return;
    }
    
    //如果本机估值为0，不能接下去的操作
    if (self.homePageModel.mobile.assessment_value <= 0) {
        [self fy_toastMessages:@"亲，不支持此机型租赁！" hidenDelay:-1];
        return;
    }
    

    
    if ([self isShowUnfishedOrder]) {
        return;
    }
    
    if (self.homePageModel.IsUnfished == 0) {
        [self pushProgressVC];
        return;
    }
    
    [self fy_toastMessages:@"您有未完成订单，不能租赁" hidenDelay:-1];
}

- (BOOL)isShowUnfishedOrder {
    
    if (self.homePageModel.IsUnfished == 3) {
#pragma mark -- show 待交租金额
        MJWeakSelf
        [YMHomeShowAlertManager showUnfinishedOrderTipView:self.homePageModel leaseBlock:^{
            [weakSelf pushLeaseDetailVC];
        }];
        return YES;
    }
    return NO;
}

- (BOOL)isShowHistoryOrder {
    //未登录不判断
    if (![FyUserCenter sharedInstance].isLogin) {
        return NO;
    }
    //历史订单数量为0 ，不显示
    if (self.historyOrderMArr.count == 0) {
        return NO;
    }
   
    //默认第一个选项选中
    FyFindIndexModelV2 *model = [self.historyOrderMArr firstObject];
    model.mobile.isSelected = YES;
    
    //判断是否已经添加本机
    FyFindIndexModelV2 *lastModel = [self.historyOrderMArr lastObject];
    if (lastModel.mobile.udid.length > 0) {
        //如果本机估值大于0，将本机加入进去。
        if (self.homePageModel.mobile.assessment_value > 0) {
            [self.historyOrderMArr addObject:self.homePageModel];
        }
    }
    MJWeakSelf
    [YMHomeShowAlertManager showLeaseTipView:self.historyOrderMArr leaseBlock:^(NSInteger index) {
        [weakSelf pushLeaseTimeLimitVC:index];
    }];
    
    return YES;
}

- (void)pushProgressVC {
    YMProgressViewController *progressVC= [[YMProgressViewController alloc] init];
    progressVC.model = self.homePageModel;
    [self.navigationController pushViewController:progressVC animated:YES];
}

//跳转租赁界面
- (void)pushLeaseTimeLimitVC:(NSInteger)index {
    FyFindIndexModelV2 *model = nil;
    if (index >= self.historyOrderMArr.count) {
        model = [self.historyOrderMArr lastObject];
    }
    model = self.historyOrderMArr[index];
    
    if (model.mobile.udid.length > 0) {
        //  先判断登录
        if ([FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:self]) {
            YMLeaseTimeLimitViewController *vc = [[YMLeaseTimeLimitViewController alloc] init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        //租赁本机先评估
        [self pushProgressVC];
    }
}

- (void)showLoanMsgWithLoanList {
    NSMutableArray *texts = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i= 0; i < 3; i++) {
        [texts addObject:[NSString stringWithFormat:@"%@刚刚租赁本机获得%ld元",[YMTool getRandomMobileNumber],[YMTool getRandomMobilePrice]]];
    }

    [self.headerView setScrollLabTexts:texts];
    [self.headerView hiddenNoticeView: texts.count == 0];
    [self.headerView displayWithModel:self.headerCard];
}

- (UITableViewStyle)fy_tableViewStyle{
    return UITableViewStyleGrouped;
}

- (void)requestBankInfo {
    FyBankModelRequest *t = [[FyBankModelRequest alloc] init];
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            self.bankCardModel = model;
            return ;
        }
        self.bankCardModel = nil;
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (error.errorCode != NSURLErrorCancelled) {
            [self fy_toastMessages:error.errorMessage];
        }
    }];
}

- (void)loadDataComplete:(void(^)())complete{
//    加载历史订单
    [self loadHistoryOrder];

    
    self.homePageModel.auth = nil;

    FyHomePageStateRequestV2 *t = [[FyHomePageStateRequestV2 alloc] init];
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        weakSelf.homePageModel = model;
        [weakSelf.headerView displayWithPrice:weakSelf.homePageModel.mobile.total_value imgUrl:weakSelf.homePageModel.mobile.phone_img];
        [weakSelf.tableView reloadData];
        [weakSelf endRefresh];
        if (complete) {
            complete();
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (error.errorCode == NSURLErrorCancelled) {
        }else{
        }
        [weakSelf endRefresh];
        if (complete) {
            complete();
        }
    }];
}

- (void)loadHistoryOrder {
    
    YMHistoryOrderRequest *t = [[YMHistoryOrderRequest alloc] init];
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:nil failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        
    } ymSuccess:^(id data) {
        [weakSelf.historyOrderMArr removeAllObjects];
        NSMutableArray *arr = [NSDictionary mj_keyValuesArrayWithObjectArray:data];
        for (NSDictionary *dic in arr) {
            //拼接数据格式
            FyFindIndexModelV2 *indexModel = [[FyFindIndexModelV2 alloc] init];
        
            YMHomeMobileModel *model = [[YMHomeMobileModel alloc] init];
            model.udid = dic[@"udid"];
            model.assessment_value = [dic[@"principal"] floatValue];
            model.phone_model = dic[@"phoneModel"];
            model.phone_memory = dic[@"phoneMemory"];
            model.num = [dic[@"num"] integerValue];
            YMHomeUnfishedOrderModel *orderModel = [[YMHomeUnfishedOrderModel alloc] init];
            orderModel.dayRentFee = [dic[@"dayRentFee"] floatValue];
            orderModel.dayAuthFee = [dic[@"dayAuthFee"] floatValue];

            indexModel.UnfishedOrder = orderModel;
            indexModel.mobile = model;
            indexModel.periodList = weakSelf.homePageModel.periodList;
            [weakSelf.historyOrderMArr addObject:indexModel];
        }
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self showLoanMsgWithLoanList];
    return  self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YMHomeLeaseFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseaIdentifier_cell];
    WS(weakSelf)
    cell.applyBlock = ^{
        [weakSelf applyLoanIfNeed:YES];
    };
    return cell;
}

- (FyFindIndexModelV2 *)homePageModel{
    if (!_homePageModel) {
        _homePageModel = [[FyFindIndexModelV2 alloc] init];;
    }
    return _homePageModel;
}

- (FyHomeCardModel *)headerCard {
    if (!_headerCard) {
        _headerCard = [[FyHomeCardModel alloc] init];
        _headerCard.brand = [YMTool getBrandName];
        _headerCard.memory = [YMTool getDivceSize];
        _headerCard.type = [YMTool getDeviceName];
    }
    return _headerCard;
}

- (YMHomeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YMHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderHeight)];
        [_headerView hiddenNoticeView:YES];
        WS(weakSelf)
        _headerView.applyBlock = ^{
            [weakSelf applyLoanIfNeed:NO];
        };
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 150;
        _tableView.backgroundColor = [UIColor bgColor];
        [_tableView registerNib:[UINib nibWithNibName:@"YMHomeLeaseFlowCell" bundle:nil] forCellReuseIdentifier:reuseaIdentifier_cell];
        [self addRefreshHeaderIfNeed];
    }
    return  _tableView;
}

- (NSMutableArray *)historyOrderMArr {
    if (!_historyOrderMArr) {
        _historyOrderMArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _historyOrderMArr;
}

- (void)setupUI {

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.nav.hidden = YES;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
   
//    [self layoutNavigationItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange) name:FYNOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChange) name:FYNOTIFICATION_LOGINSUCCESS object:nil];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
//    [self loadDataComplete:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self.tableView bringSubviewToFront:self.tableView.mj_header];
}

- (void)addRefreshHeaderIfNeed{
    WS(weakSelf)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    LPGifHeader *header = [LPGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataComplete:nil];
    }];
    header.stateLabel.hidden = YES;
    header.automaticallyChangeAlpha = YES;
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = header;
}

// 结束刷新
- (void)endRefresh{
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
}


@end
