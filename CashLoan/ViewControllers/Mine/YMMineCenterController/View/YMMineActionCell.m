//
//  YMMineActionCell.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMMineActionCell.h"

@implementation YMMineActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)identificationAction:(id)sender {
    
    if (self.applyBlock) {
        self.applyBlock(YMMineActionIdentification);
    }
}

- (IBAction)leaseRecordAction:(id)sender {
    if (self.applyBlock) {
        self.applyBlock(YMMineActionLeaseRecord);
    }
}

- (IBAction)bankCardAction:(id)sender {
    if (self.applyBlock) {
        self.applyBlock(YMMineActionBankCard);
    }
}


@end
