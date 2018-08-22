//
//  FyBillLoginView.m
//  CashLoan
//
//  Created by fyhy on 2017/11/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBillLoginView.h"

@interface FyBillLoginView ()

@end

@implementation FyBillLoginView

- (IBAction)login:(id)sender{
    if (self.loginBlock) {
        self.loginBlock();
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
