//
//  YMLeaseTimeLimitCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseTimeLimitCell.h"
#import "YMTool.h"
@interface YMLeaseTimeLimitCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recyclingPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *Day15Btn;
@property (weak, nonatomic) IBOutlet UIButton *day7Btn;
@property (weak, nonatomic) IBOutlet UILabel *dayPrice;
@property (weak, nonatomic) IBOutlet UILabel *monthPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (weak, nonatomic) IBOutlet UIView *segmentLineA;
@property (weak, nonatomic) IBOutlet UIView *segmentLineB;
@property (weak, nonatomic) IBOutlet UIButton *leaseBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *day15BtnConstraint;

@end
@implementation YMLeaseTimeLimitCell
- (IBAction)leaseBtnAction:(id)sender {
    if (self.applyBlock) {
        self.applyBlock(YMLeaseTimeLimitLease);
    }
}

- (IBAction)day15Action:(id)sender {
    if (self.applyBlock) {
        self.applyBlock(YMLeaseTimeLimitDay15);
    }
}

- (IBAction)day7Action:(id)sender {
    if (self.applyBlock) {
        self.applyBlock(YMLeaseTimeLimitDay7);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor bgColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.segmentLineA.backgroundColor = [UIColor separatorColor];
    self.segmentLineB.backgroundColor = [UIColor separatorColor];

    [self.day7Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.day7Btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.day7Btn setBackgroundImage:[UIImage imageNamed:@"jk_btn_biankuang_gray"] forState:UIControlStateNormal];
    [self.day7Btn setBackgroundImage:[UIImage imageNamed:@"jk_btn_biankuang"] forState:UIControlStateSelected];

    [self.Day15Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.Day15Btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.Day15Btn setBackgroundImage:[UIImage imageNamed:@"jk_btn_biankuang_gray"] forState:UIControlStateNormal];
    [self.Day15Btn setBackgroundImage:[UIImage imageNamed:@"jk_btn_biankuang"] forState:UIControlStateSelected];
    
    self.title.text = [NSString stringWithFormat:@"%@，%@",[YMTool getDeviceName],[YMTool getDivceSize]];
}

- (void)displayWithModel:(YMLeaseLimitModel *)model homeModel:(FyFindIndexModelV2 *)homeModel {
    if (model.dayType == 1) {
        self.Day15Btn.selected = YES;
        self.day7Btn.selected = false;
    } else {
        self.day7Btn.selected = YES;
        self.Day15Btn.selected = false;
    }
    
    self.title.text = [NSString stringWithFormat:@"%@，%@",[YMTool getDeviceName],[YMTool getDivceSize]];
    self.price.text = [NSString stringWithFormat:@"%ld元",(NSInteger)homeModel.mobile.assessment_value];

    if (homeModel.mobile.udid.length > 0) {
        self.title.text = [NSString stringWithFormat:@"%@，%@G",homeModel.mobile.phone_model,homeModel.mobile.phone_memory];
    }
    
    if (homeModel.periodList.count == 1) {
        self.day15BtnConstraint.constant = 0.1;
        self.Day15Btn.hidden = YES;
        
        YMHomePeriodListModel *listModel = homeModel.periodList[model.dayType];
        [self.day7Btn setTitle:listModel.name forState:UIControlStateNormal];
        
    } else if (homeModel.periodList.count >= 2) {
        self.day15BtnConstraint.constant = 86;
        self.Day15Btn.hidden = NO;
        
        YMHomePeriodListModel *listModel = homeModel.periodList[1];
        [self.Day15Btn setTitle:listModel.name forState:UIControlStateNormal];
    }
    
    self.dayPrice.text = [NSString stringWithFormat:@"%@元",homeModel.daily_rents];
    NSString *total = @"";
    CGFloat dayPrice = [homeModel.daily_rents floatValue];
    if (homeModel.UnfishedOrder.dayRentFee > 0) {
        self.dayPrice.text = [NSString stringWithFormat:@"%.2f元",homeModel.UnfishedOrder.dayRentFee];
        dayPrice = homeModel.UnfishedOrder.dayRentFee;
    }
    NSInteger value;
    if (model.dayType == 0) {
        YMHomePeriodListModel *listModel = homeModel.periodList[model.dayType];
        [self.day7Btn setTitle:listModel.name forState:UIControlStateNormal];
         value = listModel.value;
        total = [NSString stringWithFormat:@"%.2f*%ld=%.2f元",dayPrice,value,dayPrice * value];
    } else {
        YMHomePeriodListModel *listModel = homeModel.periodList[model.dayType];
        [self.Day15Btn setTitle:listModel.name forState:UIControlStateNormal];
         value = listModel.value;
        total = [NSString stringWithFormat:@"%.2f*%ld=%.2f元",dayPrice,value,dayPrice * value];
    }
    //平台服务费 = 日服务费 * 天数
    self.serviceFeeLabel.text = [NSString stringWithFormat:@"%ld元",(NSInteger)homeModel.audit_fee * value];
    //回收到账总额
    self.recyclingPriceLabel.text = [NSString stringWithFormat:@"%ld元",(NSInteger)homeModel.mobile.assessment_value - (NSInteger)homeModel.audit_fee * value];

    self.monthPrice.text = total;
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f元",value * dayPrice + homeModel.mobile.assessment_value];

}
@end
