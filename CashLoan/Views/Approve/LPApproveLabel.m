//
//  LPApproveLabel.m
//  CashLoan
//
//  Created by lilianpeng on 2017/7/22.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "LPApproveLabel.h"
#import <YYCategories/YYCategories.h>

@implementation LPApproveLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self configLabel];
    }
    return self;
}

- (void)configLabel {
    
    self.textColor = [UIColor unApproveBorderColor];
    self.layer.borderColor = [UIColor unApproveBorderColor].CGColor;
    self.text = @" 未认证 ";
    self.font = [UIFont systemFontOfSize:12];
    self.layer.cornerRadius = 9;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void)setSuccess:(BOOL)Success {
    _Success = Success;
    if (_Success) {
        self.text = @" 认证成功 ";
        self.layer.borderColor = [UIColor approveSuccessBorderColor].CGColor;
        self.textColor = [UIColor approveSuccessBorderColor];
    }
}

@end
