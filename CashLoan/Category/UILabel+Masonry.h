//
//  UILabel+Masonry.h
//  KDLC
//
//  Created by appleMac on 16/6/6.
//  Copyright © 2016年 llyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Masonry)

/**
 *  实例化一个UILabel，省去每次都要写很多重复的代码
 *
 *  @param size      fontsize，系统默认字体
 *  @param colorHex  颜色色值，16进制，前面要加#
 *  @param superView 父view
 *
 *  @return UILabel
 */
+(UILabel *)getLabelWithFontSize:(NSInteger)size textColor:(UIColor *)color superView:(UIView *)superView;
+(UILabel *)getLabelWithFont:(UIFont *)font textColor:(UIColor *)color superView:(UIView *)superView;
+(UILabel *)getLabelWithFontSize:(NSInteger)size textColorHex:(NSString *)colorHex superView:(UIView *)superView;

@end
