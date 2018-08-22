//
//  UIButton+Masonry.h
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Masonry)


/**
 *  获取一个button
 *
 *  @param size             title的fontsize
 *  @param colorHex         title的色值，16进制，前面加#
 *  @param backGroundColor  背景色
 *  @param superView        父view
 *  @param radius           圆角
 *
 *  @return UIButton
 */
+(UIButton *)getButtonWithFontSize:(NSInteger)size TextColorHex:(UIColor *)colorHex backGroundColor:(UIColor *)color radius:(CGFloat)radius superView:(UIView *)superView;
@end
