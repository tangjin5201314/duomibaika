

//
//  YMHomeLeaseTipView.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMHomeLeaseTipView.h"
#import "YMHomeLeaseTipViewCell.h"
#import "FyFindIndexModelV2.h"

#define kBgTableViewHeight 350
#define kBgTableViewCellHeight 50
#define kTotalHeight 450

static NSString *const kHomeLeaseTipViewCell = @"YMHomeLeaseTipView_cell";

@interface YMHomeLeaseTipView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTableViewConstraint;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *contentArr;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
@implementation YMHomeLeaseTipView
- (IBAction)leaseAction:(id)sender {
    if (self.leaseBtnBlock) {
        self.leaseBtnBlock(self.selectedIndex);
    }
    [self closeView];
}

- (IBAction)closeAction:(id)sender {
    [self closeView];
}

- (void)show:(NSArray *)dataArr {
    self.selectedIndex = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.blackView = [[UIView alloc] initWithFrame:window.frame];
    self.blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [window addSubview:self.blackView];
//    更新自己的frame
    [self updateSelfFrame:dataArr.count];
    self.center = window.center;
    [window addSubview:self];

    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.masksToBounds = YES;
    
    self.contentArr = dataArr;
//   更新约束
    [self upUIConstraints:dataArr.count];
    
//    添加动画
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)updateSelfFrame:(NSInteger)count {
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - 30, kTotalHeight);
    if (count < 3) {
        CGFloat h = kTotalHeight - (3 - count) * kBgTableViewCellHeight;
        rect = CGRectMake(0, 0, SCREEN_WIDTH - 30, h);
    }
    self.frame = rect;
}

- (void)upUIConstraints:(NSInteger)count {
    if (count >= 3) {
        self.bgHeightConstraint.constant = kBgTableViewHeight;
        self.bgTableViewConstraint.constant = kBgTableViewCellHeight * 3;
    } else {
        self.bgTableViewConstraint.constant = kBgTableViewCellHeight * count;
        self.bgHeightConstraint.constant = kBgTableViewHeight - (3 - count) * kBgTableViewCellHeight;
    }
    [self.bgTableView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}

- (void)closeView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.blackView.alpha = 0.0;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.blackView removeFromSuperview];
        [self removeFromSuperview];
    }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YMHomeLeaseTipViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeLeaseTipViewCell];
    [cell displayWithModel:self.contentArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    只能单选
    for (FyFindIndexModelV2 *tmp in self.contentArr) {
        tmp.mobile.isSelected = false;
    }
    FyFindIndexModelV2 *model = self.contentArr[indexPath.row];
    model.mobile.isSelected = !model.mobile.isSelected;
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        [_tableView registerNib:[UINib nibWithNibName:@"YMHomeLeaseTipViewCell" bundle:nil] forCellReuseIdentifier:kHomeLeaseTipViewCell];
    }
    return  _tableView;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
@end
