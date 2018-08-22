//
//  UIView+Masonry.m
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "UIView+Masonry.h"
#import "HexColor.h"
@implementation UIView (Masonry)

+(UIView *)getViewWithColor:(UIColor *)color superView:(UIView *)superView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:view];
    
    return view;
}

+(UIView *)getViewWithColorHex:(UIColor *)colorHex superView:(UIView *)superView
{
    return [UIView getViewWithColor:colorHex superView:superView ];
}

@end
