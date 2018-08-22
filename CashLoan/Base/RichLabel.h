//
//  RichLabel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <YYText/YYText.h>
typedef void(^FyTextAction)(NSString *text, NSRange range);

@interface RichLabel : YYLabel

@property (nonatomic, copy) NSString *orignText;
@property (nonatomic, strong) UIFont *fy_font;
@property (nonatomic, strong) UIColor *fy_color;

- (void)fy_setHighlightText:(NSString *)text
                           color:(UIColor *)color
                 backgroundColor:(UIColor *)backgroundColor
                       tapAction:(FyTextAction)tapAction;

@end
