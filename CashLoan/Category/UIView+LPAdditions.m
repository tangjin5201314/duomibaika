//
//  UIView+LPAdditions.m
//  5i5jAPP
//
//  Created by lilianpeng on 2017/3/13.
//  Copyright © 2017年 NiLaisong. All rights reserved.
//

#import "UIView+LPAdditions.h"
#import <YYCategories/YYCategories.h>

#define kLPGuideLineColor [UIColor colorWithHexString:@"#e9e9e9"]

@implementation UIView (LPAdditions)

- (void)addBottomLine:(CGRect)rect
{
    [self addBottomLine:[UIColor colorWithHexString:@"#e9e9e9"] inRect:rect];
}

- (void)addBottomLine:(UIColor *)color inRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
   	CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

- (void)addSubViews:(NSArray *)subViews {
    for (UIView *view in subViews) {
        if (view) {
            [self addSubview:view];
        }
    }
}

- (void)addTopGuidesLine {

    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = kLPGuideLineColor;
    [line setFrame:CGRectMake(0, 0, self.width, 0.5)];
    [self addSubview:line];
}

- (void)addBottomGuidesLine {
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = kLPGuideLineColor;
    [line setFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
    [self addSubview:line];
}

- (void)addBottomGuidesLineWithColor:(NSString *)hexString {
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:hexString];
    [line setFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
    [self addSubview:line];
}

- (void)addRightGuidesLine {
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = kLPGuideLineColor;
    [line setFrame:CGRectMake(self.width - 0.5, 0, 0.5, self.height)];
    [self addSubview:line];
}

@end
