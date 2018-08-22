//
//  FyLackOfCreditPopView.m
//  CashLoan
//
//  Created by fyhy on 2017/12/21.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLackOfCreditPopView.h"

@interface FyLackOfCreditPopView()

@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation FyLackOfCreditPopView


- (IBAction)closeBtnClick:(id)sender {
    [self fy_Hidden];
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        NSLog(@"%@", [NSValue valueWithCGRect:self.button.frame]);
        CGPoint pointInBtn = [self.button convertPoint:point fromView:self];
        NSLog(@"%@", [NSValue valueWithCGPoint:pointInBtn]);

        if (pointInBtn.x > 0 & pointInBtn.y > 0 & pointInBtn.x < CGRectGetWidth(self.button.frame) && pointInBtn.y < CGRectGetHeight(self.button.frame)) {
            view = self.button;
        }
    }
    return view;
    
}

@end

