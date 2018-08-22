//
//  UITextField+Masonry.m
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import "UITextField+Masonry.h"

@implementation UITextField (Masonry)

+ (UITextField *)getTextFieldWithFontSize:(NSInteger)size textColorHex:(UIColor *)colorHex placeHolder:(NSString *)placeHolder superView:(UIView *)superView
{
    UITextField *textfield = [[UITextField alloc] init];
    textfield.font = [UIFont systemFontOfSize:size];
    textfield.textColor = colorHex;
    textfield.placeholder = placeHolder;
    textfield.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:textfield];
    
    return textfield;
}

@end
