//
//  FyBankSelectViewController.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBankSelectViewController.h"
#import "FyBankSelectCell.h"
#import "FyBankSelectHeaderView.h"
#import "FySupportBanksRequest.h"

@interface FyBankSelectViewController ()

@property (nonatomic, strong) FySupportBankListModel *listModel;

@end

@implementation FyBankSelectViewController

static NSString *const cellIdentifier = @"bankCell";
static NSString *const cellIdentifier_header = @"cellIdentifier_header";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支持银行卡";
    self.tableView .backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FyBankSelectCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"FyBankSelectHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:cellIdentifier_header];
    
    [self fy_headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)fy_allowPullUp{
    return NO;
}

- (BOOL)fy_allowPullDown{
    return YES;
}

- (BOOL)fy_showEmptyImage{
    return YES;
}

- (UITableViewStyle)fy_tableViewStyle{
    return UITableViewStyleGrouped;
}


- (void)fy_loadServerData{
    [super fy_loadServerData];
    FySupportBanksRequest *t = [[FySupportBanksRequest alloc] init];
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:t success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess) {
            self.listModel = model;
            [self fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusDefault];
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        [self fy_loadServerDataCompleteStatus:kDataLoadCompleteStatusFailed];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"bankCell";
    
    FySupportBankModel *bank = self.listModel.list[indexPath.row];
    
    FyBankSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.fyIconView sd_setImageWithURL:[NSURL URLWithString:bank.imgUrl] placeholderImage:[UIImage imageNamed:@"bk_logo_none"]];
    cell.fyTitleLabel.text = bank.bank;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FyBankSelectHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier_header];
    view.contentView.backgroundColor = [UIColor whiteColor];
    return view;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBankBlock) {
        FySupportBankModel *bank = self.listModel.list[indexPath.row];
        self.selectBankBlock(bank.bank);
        [self.navigationController popViewControllerAnimated:YES];

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
