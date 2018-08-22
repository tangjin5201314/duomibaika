//
//  FyBaseTableViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "GzwTableViewLoading.h"
#import "LPGifHeader.h"

@interface FyBaseTableViewController ()<DZNEmptyDataSetSource>{
    BOOL _showBgColor;
    UIView *headerBgView;
}

@end

@implementation FyBaseTableViewController

- (void)dealloc{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageIdex = 0;
    self.pageStep = 10;
//    self.extendedLayoutIncludesOpaqueBars = YES;

    self.tableView.separatorColor = [UIColor separatorColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self fy_showEmptyImage]) {
        [self setupEmptyImage];
    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([self fy_tableViewEdgeInsets]);
    }];
    
//    [self addRefreshFooterIfNeed];
    [self addRefreshHeaderIfNeed];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self.tableView bringSubviewToFront:self.tableView.mj_header];
    [self layoutHeaderBgViewIfNeed];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutHeaderBgViewIfNeed];
}



- (void)layoutHeaderBgViewIfNeed{
//    if (!_showBgColor) return;
//    [self.tableView sendSubviewToBack:headerBgView];
//    CGRect bgViewFrame = self.tableView.bounds;
//    bgViewFrame.origin.y = self.tableView.contentOffset.y - self.tableView.contentInset.top;
//    bgViewFrame.size.height = MAX(0,  -self.tableView.contentOffset.y) + self.tableView.contentInset.top;
//    headerBgView.frame = bgViewFrame;

}

- (void)addColorBackgroundView {
    _showBgColor = YES;
    [self addHeaderBgVew];
}

- (void)addHeaderBgVew{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor fyThemeColor];
    headerBgView = view;
    
    [self.tableView addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEmptyImage{
    [self.tableView setupMessage:[self fy_emptyTitle] imageName:[self fy_emptyImageName]];
//    self.tableView.gzw_contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 40;
}

- (UITableViewStyle)fy_tableViewStyle{
    return UITableViewStylePlain;
}

#pragma mark - 加载tableview -

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self fy_tableViewStyle]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - Private Methods -
- (void)addRefreshFooterIfNeed{
    if ([self fy_allowPullUp] && (self.tableView.mj_footer.superview != self.tableView)) {
        __weak typeof(self) wSelf = self;
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            __strong typeof(wSelf) strongSelf = wSelf;
            [strongSelf fy_handlePullUpToLoadMore];
        }];
        
        MJRefreshAutoNormalFooter *footer = (id)self.tableView.mj_footer;
        [footer setTitle:@"加载更多" forState:MJRefreshStateIdle];
        [footer setTitle:@"加载更多" forState:MJRefreshStateRefreshing];
        [footer setTitle:[self fy_noMoreTitle] forState:MJRefreshStateNoMoreData];
        
//        footer.stateLabel.textColor = [UIColor textColor];
        self.tableView.mj_footer.automaticallyHidden = YES;
    }
}

- (NSString *)fy_noMoreTitle{
    return @"已加载全部数据";
}

- (void)addRefreshHeaderIfNeed{
    if ([self fy_allowPullDown]) {
        __weak typeof(self) wSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        LPGifHeader *header = [LPGifHeader headerWithRefreshingBlock:^{
            __strong typeof(wSelf) strongSelf = wSelf;
            [strongSelf fy_handlePullDownToLoadNew];
        }];
        header.stateLabel.hidden = YES;
//        header.fy_start_y = [self fy_refreshHeader_start_y];
        header.automaticallyChangeAlpha = YES;
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        self.tableView.mj_header = header;
    }
}

#pragma mark - Public Methods -

- (CGFloat) fy_refreshHeader_start_y{
    return 0;
}

- (BOOL)fy_showEmptyImage{
    return NO;
}
- (NSString *)fy_emptyImageName{
    return @"result_none";
}
- (NSString *)fy_emptyTitle{
    return @"暂无相关数据";
}

- (UIEdgeInsets)fy_tableViewEdgeInsets{
    return UIEdgeInsetsZero;
}

- (BOOL)fy_allowPullUp{
    return YES;
}

- (BOOL)fy_allowPullDown{
    return YES;
}

- (void)fy_headerBeginRefreshing{
    [self.tableView.mj_header beginRefreshing];
}

- (void)fy_headerEndRefreshing{
    [self.tableView.mj_header endRefreshing];
}

- (void)fy_footerBeginRefreshing{
    [self.tableView.mj_footer beginRefreshing];
}

- (void)fy_footerEndRefreshing{
    [self.tableView.mj_footer endRefreshing];
}

- (void)fy_footerEndRefreshingWithNoMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
- (BOOL)fy_hiddenFooterIfNoMoreData{
    return NO;
}

- (void)fy_handlePullDownToLoadNew{
    self.pageIdex = 0;
    [self fy_loadServerData];
}

- (void)fy_handlePullUpToLoadMore{
    self.pageIdex ++;
    [self fy_loadServerData];
}

-(void)fy_loadServerDataCompleteStatus:(FyDataLoadCompleteStatus) status{
    
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_header endRefreshing];
        
        if (status != kDataLoadCompleteStatusDefault) {
            if (self.pageIdex == 1) {
                [self.tableView.mj_footer removeFromSuperview];
            }
        }else{
            [self addRefreshFooterIfNeed];
            [self.tableView.mj_footer endRefreshing];
        }
    }
    
    if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
        if (status == kDataLoadCompleteStatusNoMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }else if (status == kDataLoadCompleteStatusNoMoreData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        if (self.pageIdex == 1) {
            [self.tableView.mj_footer removeFromSuperview];
        }
        
    }
    
    if (status == kDataLoadCompleteStatusFailed) {
        if (self.pageIdex == 1) {
            [self.tableView.mj_footer removeFromSuperview];
        }
        [self loadServerDataNetworkFaild];
    }
    if ([self fy_showEmptyImage]) {
        self.tableView.loading = NO;
    }
    [self.tableView reloadData];
    
    
}
- (void)fy_loadServerData{
    if ([self fy_showEmptyImage]) {
        self.tableView.loading = YES;
    }
    
    if (self.pageIdex == 0) {
        self.pageIdex = 1;
    }
}

- (void)loadServerDataNetworkFaild{
    self.pageIdex -= 1;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
