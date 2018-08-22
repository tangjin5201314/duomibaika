//
//  FyRepayHistoryViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRepayHistoryViewController.h"
#import "FyRepayHistoryRequest.h"
#import "FyRepayHistoryCell.h"

@interface FyRepayHistoryViewController ()

@property (nonatomic, strong) FyRepayListModel *listModel;

@end

@implementation FyRepayHistoryViewController
static NSString *cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"还款记录";
    [self.tableView registerNib:[UINib nibWithNibName:@"FyRepayHistoryCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self fy_headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)fy_handlePullDownToLoadNew{
    if ([[FyUserCenter sharedInstance].userId integerValue] == 1) {
        self.pageIdex = 2;
        [self fy_loadServerData];
    }else{
        [super fy_handlePullDownToLoadNew];
    }
}


//请求数据
- (void)fy_loadServerData{
    [super fy_loadServerData];
    FyRepayHistoryRequest *task = [[FyRepayHistoryRequest alloc] init];
    task.current = self.pageIdex;
    task.pageSize = self.pageStep;
    task.borrowID = self.borrowID;
    
    WS(weakSelf)
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, FyRepayListModel * model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            model.page = [FyPageModel mj_objectWithKeyValues:error.pageData];
            
            if (weakSelf.pageIdex != 1) {
                NSMutableArray *tempArr = [@[] mutableCopy];
                if (weakSelf.listModel.list.count > 0) {
                    [tempArr addObjectsFromArray:weakSelf.listModel.list];
                }
                if (model.list.count > 0) {
                    [tempArr addObjectsFromArray:model.list];
                }
                
                model.list = [tempArr copy];
            }
            
            weakSelf.listModel = model;
            
            if (model.page.pages <= weakSelf.pageIdex) {//没有更多数据
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
             [self fy_toastMessages:error.errorMessage];
            [weakSelf fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusFailed];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FyRepayModel *model = self.listModel.list[indexPath.row];
    FyRepayHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//cell中的分割线顶到头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
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
