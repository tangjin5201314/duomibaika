//
//  FyNoDataView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyNoDataView.h"

@interface FyNoDataView ()

@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;

@end

@implementation FyNoDataView

- (void)awakeFromNib {
    [super awakeFromNib];
    _refreshBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (IBAction)refreshBtnClick:(id)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}


@end
