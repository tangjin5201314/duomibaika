//
//  FyCalculatePopView.m
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyCalculatePopView.h"

@interface FyCalculatePopView ()

@property (nonatomic, weak) IBOutlet UIButton *commitBtn;

@end

@implementation FyCalculatePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.commitBtn setTitle:@"确认计算" forState:UIControlStateNormal];
}

- (IBAction)cancel:(id)sender{
    [self fy_Hidden];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)commit:(id)sender{
    [self fy_Hidden];
    
    if (self.commitBlock) {
        self.commitBlock();
    }

}


@end
