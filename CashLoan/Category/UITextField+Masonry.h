//
//  UITextField+Masonry.h
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Masonry)

+(UITextField *)getTextFieldWithFontSize:(NSInteger)size textColorHex:(UIColor *)colorHex placeHolder:(NSString *)placeHolder superView:(UIView *)superView;

@end
