//
//  FyAffirmAlertView.m
//  CashLoan
//
//  Created by fyhy on 2017/11/6.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyAffirmAlertView.h"

@implementation FyAffirmAlertView

- (IBAction)affirm:(id)sender{
    [self fy_Hidden];
}

- (IBAction)modify:(id)sender{
    if (self.modifyBlock) {
        self.modifyBlock();
    }
    [self fy_Hidden];
}

@end
