//
//  FyHomeLoanView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeLoanView.h"

@implementation FyHomeLoanView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.commitBtn setTitleColor:[UIColor buttonColor] forState:UIControlStateNormal];

}

- (IBAction)loan:(id)sender{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
