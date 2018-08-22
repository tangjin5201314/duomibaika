//
//  FyBaseStaticDataTableViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "LPGifHeader.h"

@interface FyBaseStaticDataTableViewController (){
    BOOL _showBgColor;
    UIView *headerBgView;
}

@end

@implementation FyBaseStaticDataTableViewController

- (void)dealloc{
//    NSLog(@"%@ %s", NSStringFromClass([self class]), __func__);
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self addRefreshHeaderIfNeed];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;

    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.tableView.backgroundColor = [UIColor bgColor];
    self.tableView.backgroundColor = [UIColor whiteColor];

    
    // Do any additional setup after loading the view.
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (!_showBgColor) return;
    CGRect bgViewFrame = self.tableView.bounds;
    bgViewFrame.origin.y = self.tableView.contentOffset.y;
    bgViewFrame.size.height = MAX(0,  -self.tableView.contentOffset.y);
    headerBgView.frame = bgViewFrame;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Private Methods -

- (void)addRefreshHeaderIfNeed{
    if ([self fy_allowPullDown]) {
        __weak typeof(self) wSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        LPGifHeader *header = [LPGifHeader headerWithRefreshingBlock:^{
            __strong typeof(wSelf) strongSelf = wSelf;
            [strongSelf fy_handlePullDownToLoadNew];
        }];
        header.stateLabel.hidden = YES;
        header.automaticallyChangeAlpha = YES;
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        self.tableView.mj_header = header;
    }
}

#pragma mark - Public Methods -


- (BOOL)fy_allowPullDown{
    return NO;
}

- (void)fy_headerBeginRefreshing{
    [self.tableView.mj_header beginRefreshing];
}

- (void)fy_headerEndRefreshing{
    [self.tableView.mj_header endRefreshing];
}


- (void)fy_handlePullDownToLoadNew{
    [self fy_loadServerData];
}


-(void)fy_loadServerDataCompleteStatus:(FyDataLoadCompleteStatus) status{
    
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (status == kDataLoadCompleteStatusFailed) {
        [self loadServerDataNetworkFaild];
    }
    [self.tableView reloadData];
    
}
- (void)fy_loadServerData{
}

- (void)loadServerDataNetworkFaild{
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
