//
//  YMLeaseRecordCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseRecordCell.h"
@interface YMLeaseRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *dayPrice;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *buyOutBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation YMLeaseRecordCell

- (IBAction)butBtnAction:(id)sender {
    if (self.applyBlock) {
        self.applyBlock(self.model);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.borderColor = [UIColor lineColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor bgColor];
}

- (void)displayWithModel:(YMHomeUnfishedOrderModel *)model {
    _model = model;
    self.title.text = [NSString stringWithFormat:@"租赁%@，%@G，%ld天",model.modelName,model.phoneMemory,(long)model.period];
    //状态 1:审核中 6:审核失败 2:放款中 5:已完成 4:已逾期 7:待交租
    if (model.status == 1) {
        self.iconImage.image = [UIImage imageNamed:@"ym_bqshz"];
    } else if (model.status == 2) {
        self.iconImage.image = [UIImage imageNamed:@"ym_bqfkz"];
    } else if (model.status == 4) {
        self.iconImage.image = [UIImage imageNamed:@"ym_bqyq"];
    } else if (model.status == 5) {
        self.iconImage.image = [UIImage imageNamed:@"ym_bqywc"];
    } else if (model.status == 6){
        self.iconImage.image = [UIImage imageNamed:@"ym_bqshsb"];
    } else if (model.status == 7){
        self.iconImage.image = [UIImage imageNamed:@"ym_bqwjz"];
    }
    
    if (model.status == 4 || model.status == 7) {
        self.buyOutBtn.hidden = NO;
    } else {
        self.buyOutBtn.hidden = YES;
    }
    CGFloat totalRentPrice = model.dayRentFee * (long)model.period;
    self.price.text = [NSString stringWithFormat:@"%.2f元",(long)model.principal + totalRentPrice];
    self.dayPrice.text = [NSString stringWithFormat:@"%.2f元",totalRentPrice];
    self.time.text = [NSString stringWithFormat:@"%@",CHECKNULL(model.rentEndTime)];
}

@end
