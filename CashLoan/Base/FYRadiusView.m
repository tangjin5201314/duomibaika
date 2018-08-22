//
//  FYRadiusView.m
//  SATEST
//
//  Created by 陈浩 on 2017/9/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FYRadiusView.h"



@implementation FYRadiusView

@synthesize backgroundColor;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;

    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.opaque = NO;

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.opaque = NO;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
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

    
    CGPathCloseSubpath(bubblePath);
    
    // Draw shadow
    CGContextAddPath(c, bubblePath);
    CGContextSaveGState(c);
    CGContextSetRGBFillColor(c, red, green, blue, alpha);
    CGContextFillPath(c);
    CGContextRestoreGState(c);
    
    
    // Draw clipped background gradient
    CGContextAddPath(c, bubblePath);
    CGContextClip(c);
    
    /*
     *渐变背景
    CGFloat bubbleMiddle = (bubbleRect.origin.y+(bubbleRect.size.height/2)) / self.bounds.size.height;
    
    CGGradientRef myGradient;
    CGColorSpaceRef myColorSpace;
    size_t locationCount = 5;
    CGFloat locationList[] = {0.0, bubbleMiddle-0.03, bubbleMiddle, bubbleMiddle+0.03, 1.0};
    
    CGFloat colourHL = 0.0;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    int numComponents = (int)CGColorGetNumberOfComponents([backgroundColor CGColor]);
    const CGFloat *components = CGColorGetComponents([backgroundColor CGColor]);
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
    CGFloat colorList[] = {
        //red, green, blue, alpha
        red*1.16+colourHL, green*1.16+colourHL, blue*1.16+colourHL, alpha,
        red*1.16+colourHL, green*1.16+colourHL, blue*1.16+colourHL, alpha,
        red*1.08+colourHL, green*1.08+colourHL, blue*1.08+colourHL, alpha,
        red     +colourHL, green     +colourHL, blue     +colourHL, alpha,
        red     +colourHL, green     +colourHL, blue     +colourHL, alpha
    };
    myColorSpace = CGColorSpaceCreateDeviceRGB();
    myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
    CGPoint startPoint, endPoint;
    startPoint.x = 0;
    startPoint.y = 0;
    endPoint.x = 0;
    endPoint.y = CGRectGetMaxY(self.bounds);
    
    CGContextDrawLinearGradient(c, myGradient, startPoint, endPoint,0);
    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorSpace);
    */
    
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
