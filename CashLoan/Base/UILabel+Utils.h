//
//  UILabel+Utils.h
//  CashLoan
//
//  Created by lilianpeng on 2018/3/31.
//  Copyright © 2018年 多米. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)

- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing;

@end
