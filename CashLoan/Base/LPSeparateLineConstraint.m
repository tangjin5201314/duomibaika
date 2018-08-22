//
//  LPSeparateLineConstraint.m
//  CashLoan
//
//  Created by lilianpeng on 2017/7/22.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "LPSeparateLineConstraint.h"

@implementation LPSeparateLineConstraint

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.constant ==1) {
        self.constant=1/[UIScreen mainScreen].scale;
    }
}

@end
