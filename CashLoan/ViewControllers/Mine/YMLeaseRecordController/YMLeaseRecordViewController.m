
//
//  YMLeaseRecordViewController.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseRecordViewController.h"
#import "YMLeaseRecordCell.h"
#import "YMLeaseDetailViewController.h"
#import "YMLeaseBuyOutViewController.h"
#import "LPGifHeader.h"
#import "YMBlankView.h"
#import "YMRecordListRequest.h"
#import "FyFindIndexModelV2.h"
#import "FyBankModelRequest.h"
#import "BankCardModel.h"

@interface YMLeaseRecordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YMBlankView *blankView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) YMRecordListRequest *request;
@property (nonatomic, strong) BankCardModel *bankCardModel;

@end

static NSString *const kLeaseRecordCell = @"kLeaseRecord_cell";

@implementation YMLeaseRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)requestData {
    if (self.request.current == 1) {
        [self requestBankInfo];
    }
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:self.request success:nil failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [weakSelf endRefresh];
    } ymSuccess:^(id data) {
        if (weakSelf.request.current == 1) {
            [weakSelf.dataArr removeAllObjects];
        }
        NSMutableArray *arr = [YMHomeUnfishedOrderModel mj_keyValuesArrayWithObjectArray:data];
        for (NSDictionary *dic in arr) {
            YMHomeUnfishedOrderModel *model = [YMHomeUnfishedOrderModel mj_objectWithKeyValues:dic];
            [weakSelf.dataArr addObject:model];
        }
        if (arr.count == 0 && weakSelf.request.current == 1) {
            [weakSelf showBlanview];
        } else {
            [weakSelf hiddneBlanView];
        }
        
        if (arr.count >= 20 && weakSelf.request.current == 1) {
            [weakSelf addRefreshFooterIfNeed];
        }
        
        [weakSelf endRefresh];
        if (arr.count < 20) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor bgColor];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMHomeUnfishedOrderModel *model = self.dataArr[indexPath.section];
    YMLeaseRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeaseRecordCell];
    [cell displayWithModel:model];
    WS(weakSelf)
    cell.applyBlock = ^(YMHomeUnfishedOrderModel *model) {
        [weakSelf pushBuyOutVC:model];
    };
    return cell;
}

- (void)pushBuyOutVC:(YMHomeUnfishedOrderModel *)model {
    YMLeaseBuyOutViewController *vc = [[YMLeaseBuyOutViewController alloc] init];
    vc.model = model;
    vc.cardModel = self.bankCardModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YMHomeUnfishedOrderModel *model = self.dataArr[indexPath.section];
    YMLeaseDetailViewController *vc = [[YMLeaseDetailViewController alloc] init];
    vc.orderModel = model;
    vc.cardModel = self.bankCardModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor bgColor];
        [_tableView registerNib:[UINib nibWithNibName:@"YMLeaseRecordCell" bundle:nil] forCellReuseIdentifier:kLeaseRecordCell];        
        [self addRefreshHeaderIfNeed];
    }
    return  _tableView;
}

- (YMBlankView *)blankView {
    if (!_blankView) {
        _blankView = [YMBlankView loadNib];
        WS(weakSelf)
        _blankView.refreshBlock = ^{
            [weakSelf hiddneBlanView];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
   return _blankView;
}

- (void)setupUI {
    self.title = @"租赁记录";
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];
    [self addBlankView];
}

//添加展位图
- (void)addBlankView {
    [self.view addSubview:self.blankView];
    [self.blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view).offset(0);
        make.top.equalTo(self.view.mas_top).offset(64);
    }];
    [self hiddneBlanView];
}

- (void)showBlanview {
    self.blankView.hidden = NO;
    [self.view bringSubviewToFront:self.blankView];
}

- (void)hiddneBlanView {
    self.blankView.hidden = YES;
    [self.view bringSubviewToFront:self.tableView];
}

- (void)addRefreshHeaderIfNeed{
    WS(weakSelf)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    LPGifHeader *header = [LPGifHeader headerWithRefreshingBlock:^{
        weakSelf.request.current = 1;
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf requestData];
    }];
    header.stateLabel.hidden = YES;
    header.automaticallyChangeAlpha = YES;
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = header;
}

- (void)addRefreshFooterIfNeed{
    WS(weakSelf)
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.request.current++;
        [weakSelf requestData];
    }];
    
    [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多" forState:MJRefreshStateRefreshing];
    [footer setTitle:[self fy_noMoreTitle] forState:MJRefreshStateNoMoreData];
    
    self.tableView.mj_footer = footer;
}

- (NSString *)fy_noMoreTitle{
    return @"已加载全部数据";
}

// 结束刷新
- (void)endRefresh{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    [_tableView reloadData];
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (YMRecordListRequest *)request {
    if (!_request) {
        _request = [[YMRecordListRequest alloc] init];
        _request.current = 1;
    }
    return _request;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}


@end
