//
//  YMMineNoLoginHeaderView.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMMineNoLoginHeaderView.h"

@implementation YMMineNoLoginHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (IBAction)loginAction:(id)sender {
    if (self.applyBlock) {
        self.applyBlock();
    }
}

@end
