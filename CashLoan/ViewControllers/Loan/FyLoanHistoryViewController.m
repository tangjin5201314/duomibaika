//
//  FyLoanHistoryViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanHistoryViewController.h"
#import "FyLoanHistoryRequestV2.h"
#import "FyLoanLogListModelV2.h"
#import "FyLoanLogCell.h"
#import "FyH5PageUtil.h"
#import "RDWebViewController.h"
#import "FyLoanDetailViewController.h"
#import "FyBillInProgressCell.h"
#import "FyBillNoProgressCell.h"
#import "FyHistoryBillHeaderCell.h"
#import "FyHistoryBillCell.h"
#import "FyHistoryBillNoDataCell.h"
#import "FyHistoryBillEmptyCell.h"
#import "FyBillProgressNoLoginCell.h"
#import "FyHistoryBillNoLoginCell.h"
#import "FyBillLoginView.h"
#import "FyLoginUtil.h"
#import "FyLoanDetailViewControllerV2.h"
#import "FyLoanUtil.h"

@interface FyLoanHistoryViewController (){
    FyBillLoginView *loginView;
    NSURLSessionDataTask *_task;
}

@property (nonatomic, strong) FyLoanLogListModelV2 *listModel;

@end

@implementation FyLoanHistoryViewController

#define maxPullDownDistance 150

static NSString *cellIdentifier_inProgress = @"cellIdentifier_inProgress";
static NSString *cellIdentifier_noProgress = @"cellIdentifier_noProgress";
static NSString *cellIdentifier_historyHeader = @"cellIdentifier_historyHeader";
static NSString *cellIdentifier_history = @"cellIdentifier_history";
static NSString *cellIdentifier_nohistory = @"cellIdentifier_nohistory";
static NSString *cellIdentifier_empty = @"cellIdentifier_empty";
static NSString *cellIdentifier_progressnotlogin = @"cellIdentifier_progressnotlogin";
static NSString *cellIdentifier_historynotlogin = @"cellIdentifier_historynotlogin";

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < -maxPullDownDistance) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -maxPullDownDistance);
    }
}

- (FyLoanLogListModelV2 *)listModel{
    if(!_listModel){
        _listModel = [[FyLoanLogListModelV2 alloc] init];
    }
    return _listModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.extendedLayoutIncludesOpaqueBars = YES;

    self.title = @"账单";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"FyBillInProgressCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_inProgress];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyBillNoProgressCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_noProgress];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyHistoryBillHeaderCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_historyHeader];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyHistoryBillCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_history];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyHistoryBillNoDataCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_nohistory];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyHistoryBillEmptyCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_empty];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FyBillProgressNoLoginCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_progressnotlogin];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyHistoryBillNoLoginCell" bundle:nil] forCellReuseIdentifier:cellIdentifier_historynotlogin];


    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    if ([FyUserCenter sharedInstance].isLogin) {
        [self removeLoginView];
    }else{
        [self layoutLoginView];
    }
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([FyUserCenter sharedInstance].isLogin) {
        [self fy_headerBeginRefreshing];
    }
}

- (UITableViewStyle)fy_tableViewStyle{
    return UITableViewStylePlain;
}

- (void)layoutLoginView{
    if (!loginView) {
        loginView = [FyBillLoginView loadNib];
        WS(weakSelf)
        loginView.loginBlock = ^{
            [FyLoginUtil showLoginViewControllerFromViewConrollerInNeeded:weakSelf];
        };
        loginView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        [self.view addSubview:loginView];
        
        [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
}

- (void)removeLoginView{
    if (loginView) {
        [loginView removeFromSuperview];
        loginView = nil;
    }
}

- (CGFloat)fy_refreshHeader_start_y{
    return 20;
}

- (BOOL)fy_allowPullUp{
    return YES;
}

- (BOOL)fy_allowPullDown{
    return YES;
}

- (BOOL)fy_showEmptyImage{
    return YES;
}

- (NSString *)fy_emptyImageName{
    return @"result_none";
}

- (NSString *)fy_emptyTitle{
    return @"暂时还没有生成记录，请稍后再试！";
}

- (NSString *)fy_noMoreTitle{
    return @"没有其他账单了哦";
}

- (void)fy_handlePullDownToLoadNew{
    if ([[FyUserCenter sharedInstance].userId integerValue] == 1) {
        self.pageIdex = 2;
        [self fy_loadServerData];
    }else{
        [super fy_handlePullDownToLoadNew];
    }
}

- (void)applyLoanIfNeed{
    [FyLoanUtil applyIfNeededWithModel:nil fromViewController:self];
}

//请求数据
- (void)fy_loadServerData{
    [super fy_loadServerData];
    FyLoanHistoryRequestV2 *task = [[FyLoanHistoryRequestV2 alloc] init];
    task.current = self.pageIdex;
    task.pageSize = self.pageStep;
    
    WS(weakSelf)
    [_task cancel];
    _task = [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyLoanLogListModelV2 * model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            BOOL hasMore = model.historyOrder.count == weakSelf.pageStep;;
            if (weakSelf.pageIdex != 1) {
                NSMutableArray *tempArr = [@[] mutableCopy];
                if (weakSelf.listModel.historyOrder.count > 0) {
                    [tempArr addObjectsFromArray:weakSelf.listModel.historyOrder];
                }
                if (model.historyOrder.count > 0) {
                    [tempArr addObjectsFromArray:model.historyOrder];
                }
                
                model.historyOrder = [tempArr copy];
                model.curOrder = weakSelf.listModel.curOrder;
            }
            
            weakSelf.listModel = model;
//            weakSelf.listModel.historyList = @[@"",@"",@"",@""];
//            weakSelf.listModel.currentLoanLog = @"";
            weakSelf.listModel.fromApi = YES;
            if (!hasMore) {//没有更多数据
                [weakSelf fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusNoMoreData];
            }else{
                [weakSelf fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusDefault];
            }

        }else{
            [weakSelf fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusFailed];
        }
        
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (error.errorCode == NSURLErrorCancelled) {
            [weakSelf fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusCancelled];
        }else{
            [weakSelf fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusFailed];
        }
    }];
}

- (void)pushToProtocolWithModel:(FyLoanLogModel *)model{
    
    if (!model) return;
    RDWebViewController *vc = [[RDWebViewController alloc] init];
    vc.title = @"富卡借款协议";
    vc.url = [FyH5PageUtil loanProcotolWithBorrowH5Link:model.h5Link];
    vc.method = RDWebViewSendMethodGET;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToLoanDetailWithModel:(FyOrderDetailModel *)model{
    
    FyLoanDetailViewControllerV2 *vv = [[FyLoanDetailViewControllerV2 alloc] init];
    vv.orderModel = model;
    [self.navigationController pushViewController:vv animated:YES];
}

- (BOOL)hasInProgressBill{
    return self.listModel.curOrder != nil;
}

- (BOOL)showHistoryHeaderTitle{
    return self.listModel.curOrder && self.listModel.historyOrder.count > 0;
}

- (NSAttributedString *)amountAttributedStringWithString:(NSString *)string {
    if (!string) {
        return nil;
    }
    
    NSArray *arr = [string componentsSeparatedByString:@"."];
    if (arr.count <= 1 || arr.count > 2) {
        return [[NSAttributedString alloc] initWithString:string];
    }
    
    UIFont *font1 = [UIFont systemFontOfSize:25];
    UIFont *font2 = [UIFont systemFontOfSize:18];

    NSString *str1 = arr[0];
    NSString *str2 = arr[1];
    str2 = [@"." stringByAppendingString:str2];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName : font1}];
    [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName : font2}]];
    
    return mutableAttributedString;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![FyUserCenter sharedInstance].isLogin || !self.listModel.fromApi) {
        return 1;
    }
    
    if(self.listModel.historyOrder.count == 0){
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1){
        return 1;
    }
    
    if (![FyUserCenter sharedInstance].isLogin || !self.listModel.fromApi) {
        return 2;
    }
    return self.listModel.historyOrder.count + [self showHistoryHeaderTitle];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 0;
    }
    
    if (![FyUserCenter sharedInstance].isLogin || !self.listModel.fromApi) {
        return 180;
    }else{
        if ([self hasInProgressBill]) {
            return 180;
        }else{
            return 160;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1) return nil;
    
    if (![FyUserCenter sharedInstance].isLogin || !self.listModel.fromApi) {
        FyBillProgressNoLoginCell *cell = [FyBillProgressNoLoginCell loadNib];
        cell.contentView.clipsToBounds = NO;
        cell.titleLabel.text = self.listModel.title;
        cell.backgroundColor = [UIColor whiteColor];

        return cell;
    }else{
        WS(weakSelf)
        if ([self hasInProgressBill]) {
            FyBillInProgressCell *cell = [FyBillInProgressCell loadNib];
            cell.contentView.clipsToBounds = NO;
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.text = self.listModel.title;
            cell.loanLog = self.listModel.curOrder;
            cell.showDetailBlock = ^{
                [weakSelf pushToLoanDetailWithModel:weakSelf.listModel.curOrder];
            };
            cell.amountLabel.attributedText = [self amountAttributedStringWithString:[self.listModel.curOrder displayLoanAmount]];
            return cell;
        }else{
            FyBillNoProgressCell *cell = [FyBillNoProgressCell loadNib];
            cell.contentView.clipsToBounds = NO;
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.text = self.listModel.title;
//            cell.descLabel.text = self.listModel.describe;
            cell.loanBlock = ^{
                [weakSelf applyLoanIfNeed];
            };
            return cell;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1){
        if ([self hasInProgressBill]) {
            FyHistoryBillNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_nohistory];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            FyHistoryBillEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_empty];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    if (![FyUserCenter sharedInstance].isLogin || !self.listModel.fromApi) {
        FyHistoryBillNoLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_historynotlogin forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if ([self showHistoryHeaderTitle] && indexPath.row == 0) {
        FyHistoryBillHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_historyHeader];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    //历史记录账单
    {
        FyOrderDetailModel *loanLog = self.listModel.historyOrder[indexPath.row-[self showHistoryHeaderTitle]];

        FyHistoryBillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_history];
        cell.statusLabel.text = loanLog.statusStr;
//        cell.amountLabel.text = [loanLog displayLoanAmount];
        cell.amountLabel.attributedText = [self amountAttributedStringWithString:[loanLog displayLoanAmount]];
        cell.dateLabel.text = loanLog.createTime;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![FyUserCenter sharedInstance].isLogin  || !self.listModel.fromApi) {
        return UITableViewAutomaticDimension;
    }
    if (!self.listModel.curOrder && self.listModel.historyOrder.count == 0) {
        return CGRectGetHeight(tableView.frame)-160-20-49-40;//依次为头的高度、状态栏高度、tabbar高度， 最后的40为额外减的
    }
    
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![FyUserCenter sharedInstance].isLogin || !self.listModel.fromApi) return;
    
    if (self.listModel.historyOrder.count <= indexPath.row-[self showHistoryHeaderTitle]) return;
    FyOrderDetailModel *loanLog = self.listModel.historyOrder[indexPath.row-[self showHistoryHeaderTitle]];
    [self pushToLoanDetailWithModel:loanLog];

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
