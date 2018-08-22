//
//  FYGradientView.m
//  cashloan
//
//  Created by 陈浩 on 2017/9/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FYGradientView.h"
#import "UIColor+fyTheme.h"

@implementation FYGradientView

+ (FYGradientView *)defultGradientView{
    return [[FYGradientView alloc] initWithStartColor:[UIColor defaultGradientStartColor] endColor:[UIColor defaultGradientColor] startPoint:CGPointZero endPoint:CGPointMake(1, 1) locations:@[@0.3, @1.0]];
}

- (void)defultConfig{
    self.startColor = [UIColor defaultGradientStartColor];
    self.endColor = [UIColor defaultGradientColor];
    self.startPoint = CGPointZero;
    self.endPoint = CGPointMake(1, 1);
//    self.locations = @[@0.3, @1.0];
    
    [self setNeedsDisplay];
}

- (instancetype)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)locations{
    self = [super init];
    if (self) {
        self.startColor = startColor;
        self.endColor = endColor;
        self.startPoint = startPoint;
        self.endPoint = endPoint;
        self.locations = locations;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self defultConfig];
    }
    return self;
}

- (UIColor *)startColor{
    return _startColor ? _startColor : [UIColor whiteColor];
}

- (UIColor *)endColor{
    return _endColor ? _endColor : [UIColor whiteColor];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint startPoint = CGPointMake(self.startPoint.x * CGRectGetWidth(rect), self.startPoint.y * CGRectGetHeight(rect));
    CGPoint endPoint = CGPointMake(self.endPoint.x * CGRectGetWidth(rect), self.endPoint.y * CGRectGetHeight(rect));
    
    [self DrawGradientColor:context rect:rect point:startPoint point:endPoint];

}

/**
 画图形渐进色方法，此方法只支持双色值渐变
 @param context     图形上下文的CGContextRef
 @param clipRect    需要画颜色的rect
 @param startPoint  画颜色的起始点坐标
 */
- (void)DrawGradientColor:(CGContextRef)context
                     rect:(CGRect)clipRect
                    point:(CGPoint)startPoint
                    point:(CGPoint)endPoint{
    UIColor* colors [2] = {self.startColor,self.endColor};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    
    CGFloat colorComponents[8];
    
    for (int i = 0; i < 2; i++) {
        UIColor *color = colors[i];
        CGColorRef temcolorRef = color.CGColor;
        
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < 4; j++) {
            colorComponents[i * 4 + j] = components[j];
        }
    }
    
    CGGradientRef gradient;
    if (self.locations.count > 0) {
        
        CGFloat *l = malloc(self.locations.count*sizeof(CGFloat));

        for (int i = 0; i < self.locations.count; i++) {
            l[i] = [self.locations[i] floatValue];
        }
        
        gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, l, 2);
        free(l);

    }else{
        gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
    }
    
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}


@end
