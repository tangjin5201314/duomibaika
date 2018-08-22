//
//  UILabel+Masonry.m
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "UILabel+Masonry.h"
#import "HexColor.h"

@implementation UILabel (Masonry)

+(UILabel *)getLabelWithFontSize:(NSInteger)size textColor:(UIColor *)color superView:(UIView *)superView
{
    return [UILabel getLabelWithFont:[UIFont systemFontOfSize:size] textColor:color superView:superView];
}

+(UILabel *)getLabelWithFontSize:(NSInteger)size textColorHex:(NSString *)colorHex superView:(UIView *)superView
{
    return [UILabel getLabelWithFont:[UIFont systemFontOfSize:size] textColor:[UIColor colorWithHexString:colorHex] superView:superView ];
}

+(UILabel *)getLabelWithFont:(UIFont *)font textColor:(UIColor *)color superView:(UIView *)superView{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:label];
    return label;
}

@end
