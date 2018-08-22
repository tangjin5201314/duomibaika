//
//  UIButton+Masonry.m
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "UIButton+Masonry.h"

@implementation UIButton (Masonry)

+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor:(UIColor *)color radius:(CGFloat)radius superView:(UIView *)superView
{
    return [UIButton getButtonWithFontSize:size TextColorHex:colorHex backGroundColor2:color radius:radius superView:superView];
}

+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor2:(UIColor *)color radius:(CGFloat)radius superView:(UIView *)superView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn setTitleColor:colorHex forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    btn.layer.cornerRadius = radius;
    btn.clipsToBounds = YES;
    
    [superView addSubview:btn];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    return btn;
}



@end
