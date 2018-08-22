
//
//  YMLeaseDeatailHeaderCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/24.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMLeaseDeatailHeaderCell.h"
@interface YMLeaseDeatailHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *order;
@property (weak, nonatomic) IBOutlet UILabel *phoneType;

@end
@implementation YMLeaseDeatailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayWithModel:(YMHomeUnfishedOrderModel *)model {
    self.title.text = [NSString stringWithFormat:@"租赁%@，%@G，%ld天",model.modelName,model.phoneMemory,model.period];
    if (model.status == 1) {
        self.iconImg.image = [UIImage imageNamed:@"ym_bqshz"];
    } else if (model.status == 2) {
        self.iconImg.image = [UIImage imageNamed:@"ym_bqfkz"];
    } else if (model.status == 4) {
        self.iconImg.image = [UIImage imageNamed:@"ym_bqyq"];
    } else if (model.status == 5) {
        self.iconImg.image = [UIImage imageNamed:@"ym_bqywc"];
    } else if (model.status == 6){
        self.iconImg.image = [UIImage imageNamed:@"ym_bqshsb"];
    } else if (model.status == 7){
        self.iconImg.image = [UIImage imageNamed:@"ym_bqwjz"];
    }
    
    self.order.text = [NSString stringWithFormat:@"订单号：%@",CHECKNULL(model.orderNo)];
    self.phoneType.text = CHECKNULL(model.modelName);
}
@end
