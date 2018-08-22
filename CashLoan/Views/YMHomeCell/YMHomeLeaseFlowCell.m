//
//  YMHomeLeaseFlowCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMHomeLeaseFlowCell.h"
@interface YMHomeLeaseFlowCell ()

@end
@implementation YMHomeLeaseFlowCell
- (IBAction)leaseBtnAction:(id)sender {
    if (self.applyBlock) {
        self.applyBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentView.backgroundColor = [UIColor bgColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
