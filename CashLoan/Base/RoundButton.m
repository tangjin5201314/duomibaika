//
//  RoundButton.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton
@synthesize backgroundColor;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    RoundButton *btn = [super buttonWithType:buttonType];
    [btn defaultConfigs];
    return btn;
}

- (void)defaultConfigs{
//    [self setTitleColor:[UIColor buttonColor] forState:UIControlStateNormal];
//    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.corners = UIRectCornerAllCorners;
    self.radius = 3;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.opaque = NO;
        [self defaultConfigs];
    }
    return self;
}

- (void)setCorners:(UIRectCorner)corners{
    if (_corners != corners) {
        _corners = corners;
        [self setNeedsDisplay];
    }
}

- (void)setRadius:(CGFloat)radius{
    if (_radius != radius) {
        _radius = radius;
        [self setNeedsDisplay];
    }
}

- (void)setBorderColor:(UIColor *)borderColor{
    if (_borderColor != borderColor) {
        _borderColor = borderColor;
        [self setNeedsDisplay];
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    if (_borderWidth != borderWidth) {
        _borderWidth = borderWidth;
        [self setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect bubbleRect = rect;
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    UIColor *strokeColor = self.borderColor ? self.borderColor :[UIColor whiteColor];
    UIColor *borderColor = self.borderColor ? self.borderColor :[UIColor whiteColor];
    
    CGFloat borderWidth = self.borderWidth > 0 ? self.borderWidth : 0;
    CGFloat radius = MAX(self.radius, 0);
//    radius = radius*2 < CGRectGetHeight(bubbleRect) ? radius : 0;
    
    CGContextSetStrokeColorWithColor(c, strokeColor.CGColor);
    CGContextSetLineWidth(c, borderWidth);
    
//    CGPathRef bubblePath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft cornerRadii:CGSizeMake(radius, radius)].CGPath;
    
    CGMutablePathRef bubblePath = CGPathCreateMutable();

    CGPathMoveToPoint(bubblePath, NULL, CGRectGetMinX(bubbleRect), CGRectGetMinY(bubbleRect));

    if (self.corners & UIRectCornerTopRight) {
        CGPathAddArcToPoint(bubblePath, NULL,
                            CGRectGetMaxX(bubbleRect),CGRectGetMinY(bubbleRect),
                            CGRectGetMaxX(bubbleRect),CGRectGetMinY(bubbleRect) + radius,
                            radius);
    }else{
        CGPathAddLineToPoint(bubblePath, NULL, CGRectGetMaxX(bubbleRect), CGRectGetMinY(bubbleRect));
    }

    if (self.corners & UIRectCornerBottomRight) {
        CGPathAddArcToPoint(bubblePath, NULL,
                            CGRectGetMaxX(bubbleRect), CGRectGetMaxY(bubbleRect),
                            CGRectGetMaxX(bubbleRect) - radius,CGRectGetMaxY(bubbleRect),
                            radius);
    }else{
        CGPathAddLineToPoint(bubblePath, NULL, CGRectGetMaxX(bubbleRect), CGRectGetMaxY(bubbleRect));
    }

    if (self.corners & UIRectCornerBottomLeft) {
        CGPathAddArcToPoint(bubblePath, NULL,
                            CGRectGetMinX(bubbleRect), CGRectGetMaxY(bubbleRect),
                            CGRectGetMinX(bubbleRect),CGRectGetMaxY(bubbleRect) - radius,
                            radius);
    }else{
        CGPathAddLineToPoint(bubblePath, NULL, CGRectGetMinX(bubbleRect), CGRectGetMaxY(bubbleRect));
    }

    if (self.corners & UIRectCornerTopLeft) {
        CGPathAddArcToPoint(bubblePath, NULL,
                            CGRectGetMinX(bubbleRect), CGRectGetMinY(bubbleRect),
                            CGRectGetMinX(bubbleRect) + radius, CGRectGetMinY(bubbleRect),
                            radius);
    }else{
        CGPathAddLineToPoint(bubblePath, NULL, CGRectGetMinX(bubbleRect), CGRectGetMinY(bubbleRect));
    }
//
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    UIColor *bgColor = backgroundColor ? : [UIColor clearColor];
    
    int numComponents = (int)CGColorGetNumberOfComponents([bgColor CGColor]);
    const CGFloat *components = CGColorGetComponents([bgColor CGColor]);
    if (numComponents == 2) {
        red = components[0];
        green = components[0];
        blue = components[0];
        alpha = components[1];
    }
    else {
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
    
    
//    CGPathCloseSubpath(bubblePath);
    
    // Draw shadow
    CGContextAddPath(c, bubblePath);
    CGContextSaveGState(c);
    CGContextSetRGBFillColor(c, red, green, blue, alpha);
    CGContextFillPath(c);
    CGContextRestoreGState(c);
    
    
    // Draw clipped background gradient
    CGContextAddPath(c, bubblePath);
    CGContextClip(c);
    
    //Draw Border
    int numBorderComponents = (int)CGColorGetNumberOfComponents([borderColor CGColor]);
    const CGFloat *borderComponents = CGColorGetComponents(borderColor.CGColor);
    CGFloat r, g, b, a;
    if (numBorderComponents == 2) {
        r = borderComponents[0];
        g = borderComponents[0];
        b = borderComponents[0];
        a = borderComponents[1];
    }
    else {
        r = borderComponents[0];
        g = borderComponents[1];
        b = borderComponents[2];
        a = borderComponents[3];
    }
    
    CGContextSetRGBStrokeColor(c, r, g, b, a);
    CGContextAddPath(c, bubblePath);
    CGContextDrawPath(c, kCGPathStroke);
    
    CGPathRelease(bubblePath);
}

@end
