//
//  UIColor+fyTheme.h
//  cashloan
//
//  Created by 陈浩 on 2017/9/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexColor.h"

@interface UIColor (fyTheme)

+ (UIColor *)fyThemeColor;
+ (UIColor *)whiteFontColor;
+ (UIColor *)yellowFontColor;

+ (UIColor *)defaultGradientColor;
+ (UIColor *)defaultGradientStartColor;

+ (UIColor *)waitingRepaymentColor; //代还款字体颜色
+ (UIColor *)outtimeColor; //逾期还款字体颜色

+ (UIColor *)tabBarColor;
+ (UIColor *)buttonColor;
+ (UIColor *)textLinkColor;
+ (UIColor *)statusColor; //状态色
+ (UIColor *)interspersedColor; //点缀色
+ (UIColor *)promptColor; //提示色
+ (UIColor *)textColor; //主文本颜色
+ (UIColor *)textColorV2; //主文本颜色

+ (UIColor *)subTextColor; //副文本颜色
+ (UIColor *)subTextColorV2; //副文本颜色
+ (UIColor *)weakTextColor; //弱文本颜色
+ (UIColor *)weakTextColorV2; //弱文本颜色
+ (UIColor *)bgColor; //背景色
+ (UIColor *)separatorColor; //分割线颜色
+ (UIColor *)defaultPlaceholderColor;
+ (UIColor *)timeDownBtnColor; //倒计时按钮
+ (UIColor *)approveSuccessBorderColor;

+ (UIColor *)unApproveBorderColor;
+ (UIColor *)viewBackgroundColor; //pickerview背景色
+ (UIColor *)buttonBackgroundColor; //pickerview
+ (UIColor *)webViewStepColor;
+ (UIColor *)disabledButtonTextColor;
+ (UIColor *)normalButtonTextColor;
+ (UIColor *)shadowColor; //投影色

+ (UIColor *)textGradientStartColor;
+ (UIColor *)textGradientEndColor;
+ (UIColor *)unableSelectColor;//button置灰颜色
+ (UIColor *)promptColorV2;
+ (UIColor *)lineColor;
@end
