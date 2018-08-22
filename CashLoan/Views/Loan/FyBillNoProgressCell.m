//
//  FyBillNoProgressCell.m
//  CashLoan
//
//  Created by fyhy on 2017/11/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBillNoProgressCell.h"

@implementation FyBillNoProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)loan:(id)sender{
    if (self.loanBlock) {
        self.loanBlock();
    }
}

@end
