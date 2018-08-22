//
//  FyPayStyleSelectView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/25.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyPayStyleSelectView.h"
#import "UIView+fyShow.h"

@implementation FyPayStyleSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)leftBtnClick:(id)sender {
    _leftLabel.textColor =  [UIColor fyThemeColor];
    _rightLabel.textColor =  [UIColor textColor];
    if (self.selectBlock) {
        self.selectBlock(@"普通还款", 0);
    }
    [self fy_Hidden];
}
- (IBAction)rightBtnClick:(id)sender {
    _leftLabel.textColor =  [UIColor textColor];
    _rightLabel.textColor =  [UIColor fyThemeColor];
    if (self.selectBlock) {
        self.selectBlock(@"快速还款" ,1);
    }
    [self fy_Hidden];

}
- (IBAction)closeBtnClick:(id)sender {
    [self fy_Hidden];
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    if (selectIndex == 0) {
        _leftLabel.textColor =  [UIColor fyThemeColor];
        _rightLabel.textColor =  [UIColor textColor];
    }else{
        _leftLabel.textColor =  [UIColor textColor];
        _rightLabel.textColor =  [UIColor fyThemeColor];
    }
}


@end
