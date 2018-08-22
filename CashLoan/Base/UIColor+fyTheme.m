//
//  UIColor+fyTheme.m
//  cashloan
//
//  Created by 陈浩 on 2017/9/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "UIColor+fyTheme.h"

@implementation UIColor (fyTheme)

+ (UIColor *)whiteFontColor{
    return [UIColor fy_colorWithHexString:@"#ffffff"];

}

+ (UIColor *)yellowFontColor{
    return [UIColor fy_colorWithHexString:@"#d5ca7d"];
}

+ (UIColor *)defaultGradientColor{
    return [UIColor fy_colorWithHexString:@"#3d8cfe"];
//    return [UIColor fy_colorWithHexString:@"#005bea"];
}

+ (UIColor *)defaultGradientStartColor{
//    return [UIColor fy_colorWithHexString:@"#009ef5"];
    return [UIColor fy_colorWithHexString:@"#6876ff"];

}

+ (UIColor *)fyThemeColor{
//    return [UIColor fy_colorWithHexString:@"#009ef5"];
    return [UIColor fy_colorWithHexString:@"#5584f5"];

}

+ (UIColor *)waitingRepaymentColor{ //代还款字体颜色
    return [UIColor fy_colorWithHexString:@"#f8610a"];
}
+ (UIColor *)outtimeColor{ //逾期还款字体颜色
    return [UIColor fy_colorWithHexString:@"#fb2205"];
}

+ (UIColor *)tabBarColor{
    return [UIColor fy_colorWithHexString:@"#0080f0"];
}

+ (UIColor *)buttonColor{
    return [UIColor fy_colorWithHexString:@"#0080f0"];
}

+ (UIColor *)textLinkColor{
    return [UIColor fy_colorWithHexString:@"#0080f0"];
}

+ (UIColor *)statusColor{ //状态色
    return [UIColor fy_colorWithHexString:@"#0080f0"];
}

+ (UIColor *)interspersedColor{ //点缀色
    return [UIColor fy_colorWithHexString:@"#f6d654"];
}

+ (UIColor *)promptColor{ //提示色
    return [UIColor fy_colorWithHexString:@"#fb2205"];
}

+ (UIColor *)promptColorV2{ //提示色
    return [UIColor fy_colorWithHexString:@"#fe5a74"];
}


+ (UIColor *)textColor{ //主文本颜色
    return [UIColor fy_colorWithHexString:@"#333333"];
}

+ (UIColor *)textColorV2{ //主文本颜色
    return [UIColor fy_colorWithHexString:@"#333848"];
}


+ (UIColor *)subTextColor{ //副文本颜色
    return [UIColor fy_colorWithHexString:@"#666666"];
}

+ (UIColor *)subTextColorV2{ //副文本颜色
    return [UIColor fy_colorWithHexString:@"#666667"];
}

+ (UIColor *)weakTextColor{ //弱文本颜色
    return [UIColor fy_colorWithHexString:@"#999999"];
}

+ (UIColor *)weakTextColorV2{ //弱文本颜色
    return [UIColor fy_colorWithHexString:@"#979899"];
}


+ (UIColor *)bgColor{ //背景色
    return [UIColor fy_colorWithHexString:@"#f7f8fa"];
}

+ (UIColor *)separatorColor{ //分割线颜色
    return [UIColor fy_colorWithHexString:@"#ebf0f3"];
}

+ (UIColor *)defaultPlaceholderColor{ //textfield placeholder
    return [UIColor fy_colorWithHexString:@"#b8d9f3"];
}

+ (UIColor *)timeDownBtnColor{ //倒计时按钮
    return [UIColor fy_colorWithHexString:@"#b8d6fa"];
}

+ (UIColor *)approveSuccessBorderColor{
    return [UIColor fy_colorWithHexString:@"#21d081"];
}

+ (UIColor *)unApproveBorderColor{
    return [UIColor fy_colorWithHexString:@"#c9d3e0"];
}

+ (UIColor *)viewBackgroundColor{
    return [UIColor fy_colorWithHexString:@"#f3f4f8"];
}

+ (UIColor *)buttonBackgroundColor{
    return [UIColor fy_colorWithHexString:@"#1e88de"];
}

+ (UIColor *)webViewStepColor{
    return [UIColor fy_colorWithHexString:@"#1f68ee"];
}

+ (UIColor *)disabledButtonTextColor{
    return [UIColor fy_colorWithHexString:@"#cccccc"];
}

+ (UIColor *)normalButtonTextColor{
    return [UIColor fy_colorWithHexString:@"#f95a28"];
}

+ (UIColor *)shadowColor{
    return [UIColor fy_colorWithHexString:@"#d0d9e2"];
}

+ (UIColor *)textGradientStartColor{
    return [UIColor fy_colorWithHexString:@"#8767ff"];
}
+ (UIColor *)textGradientEndColor{
    return [UIColor fy_colorWithHexString:@"#358efe"];
}
+ (UIColor *)unableSelectColor{
    return [UIColor fy_colorWithHexString:@"#bcbcbc"];
}

+ (UIColor *)lineColor{
    return [UIColor fy_colorWithHexString:@"#eeeeee"];
}
@end
