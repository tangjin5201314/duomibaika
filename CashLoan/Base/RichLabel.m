//
//  RichLabel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "RichLabel.h"

@implementation RichLabel

- (void)setOrignText:(NSString *)orignText{
    if (_orignText != orignText) {
        _orignText = orignText;
        [self configOrignText];
    }
}


- (void)configOrignText{
    self.textVerticalAlignment = YYTextVerticalAlignmentTop;
    self.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
    self.numberOfLines = 1;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.orignText];
    text.yy_font = self.fy_font ? : [UIFont systemFontOfSize:15];
    text.yy_color = self.fy_color ? : [UIColor weakTextColorV2];
    text.yy_lineSpacing = 10;
    
    self.attributedText = text;
}

- (void)fy_setHighlightText:(NSString *)text
                      color:(UIColor *)color
            backgroundColor:(UIColor *)backgroundColor
                  tapAction:(FyTextAction)tapAction{
    if (self.orignText.length == 0) return;
    
    NSRange range = [self.orignText rangeOfString:text];
    if (range.location == NSNotFound) return;
    
    color = color ? : [UIColor tabBarColor];
    backgroundColor = backgroundColor ? : [UIColor whiteColor];
    
    NSMutableAttributedString *str = [self.attributedText mutableCopy];
    
    [str yy_setTextHighlightRange:range color:color backgroundColor:backgroundColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull t, NSRange range, CGRect rect) {
        if (tapAction) {
            tapAction(text, range);
        }
    }];
    
    self.attributedText = str;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
