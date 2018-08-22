
//
//  YMLeaseDetailViewController.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseDetailViewController.h"
#import "YMLeaseDeatailHeaderCell.h"
#import "YMLeaseDeatailNormalCell.h"
#import "YMLeaseDeatailBottomView.h"
#import "YMLeaseBuyOutViewController.h"

static NSString *const kLeaseDetailHeaderCell = @"kLeaseDetailHeader_cell";
static NSString *const kLeaseDetailNormalCell = @"kLeaseDetailNormal_cell";

@interface YMLeaseDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) YMLeaseDeatailBottomView *bottomView;

@end

@implementation YMLeaseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor bgColor];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.titleArr.count -1) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 125;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.titleArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = self.titleArr[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        YMLeaseDeatailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeaseDetailHeaderCell];
        [cell displayWithModel:self.orderModel];
        return cell;
    }

    YMLeaseDeatailNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeaseDetailNormalCell];
    [self setCellParamseWithTitle:title tableView:tableView cell:cell indexPath:indexPath];
    return cell;
}

- (void)setCellParamseWithTitle:(NSString *)title tableView:(UITableView *)tableView cell:(YMLeaseDeatailNormalCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *content = @"";
    if (indexPath.section == 0 && indexPath.row == 1) {
        content = [NSString stringWithFormat:@"%@G",self.orderModel.phoneMemory];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        content = [NSString stringWithFormat:@"%@",CHECKNULL(self.orderModel.udid)];
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        content = [NSString stringWithFormat:@"%ld元",(long)self.orderModel.principal];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
         content = [NSString stringWithFormat:@"%@",CHECKNULL(self.orderModel.loanTime)];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        content = [NSString stringWithFormat:@"%@",CHECKNULL(self.orderModel.rentEndTime)];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        content = [NSString stringWithFormat:@"%ld元",(NSInteger)self.orderModel.overdueFee];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        content = [NSString stringWithFormat:@"%ld元",(long)self.orderModel.depreciationFee];
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        content = [NSString stringWithFormat:@"%.2f元",self.orderModel.dayRentFee];
    } else if (indexPath.section == 2 && indexPath.row == 3) {
        CGFloat total = self.orderModel.dayRentFee * self.orderModel.period;
        content = [NSString stringWithFormat:@"%.2f*%ld=%.2f元",self.orderModel.dayRentFee,self.orderModel.period,total];
    }
    [cell displayWithTitle:title content:content];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        //        _tableView.estimatedRowHeight = 100;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor bgColor];
//                [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLeaseDetailNormalCell];
        [_tableView registerNib:[UINib nibWithNibName:@"YMLeaseDeatailHeaderCell" bundle:nil] forCellReuseIdentifier:kLeaseDetailHeaderCell];
        [_tableView registerNib:[UINib nibWithNibName:@"YMLeaseDeatailNormalCell" bundle:nil] forCellReuseIdentifier:kLeaseDetailNormalCell];
        
    }
    return  _tableView;
}

- (void)setupUI {
    self.title = @"租赁详情";
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.titleArr = @[
                        @[@"手机型号",@"内存",@"识别码",@"手机估值"],
                        @[@"回收时间",@"到期时间"],
                        @[@"逾期管理费",@"折旧费",@"日租金",@"总租金"]
                    ];
    
    if (self.orderModel.status == 4 || self.orderModel.status == 7) {
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(70);
        }];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(64);
            make.bottom.mas_equalTo(-70);
        }];
    } else {
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(64);
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (void)pushBuyOutVC {
    YMLeaseBuyOutViewController *vc = [[YMLeaseBuyOutViewController alloc] init];
    vc.model = self.orderModel;
    vc.cardModel = self.cardModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (YMLeaseDeatailBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [YMLeaseDeatailBottomView loadNib];
//        CGFloat total = self.orderModel.principal + self.orderModel.rentFee + self.orderModel.depreciationFee + self.orderModel.overdueFee;
        [_bottomView setPriceLabText:[NSString stringWithFormat:@"%.1f元",self.orderModel.allFee]];
        WS(weakSelf)
        _bottomView.applyBlock = ^{
            [weakSelf pushBuyOutVC];
        };
    }
    return _bottomView;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}


@end
