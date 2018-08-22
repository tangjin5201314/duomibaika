//
//  FyBaseNavigationBar.m
//  CashLoan
//
//  Created by fyhy on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseNavigationBar.h"

@implementation FyBaseNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)backgroundView{
    UIView *backgroundView = [self valueForKey:@"_backgroundView"];
    return backgroundView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.translucent = NO;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
