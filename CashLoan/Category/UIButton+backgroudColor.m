//
//  UIButton+backgroudColor.m
//  HSY
//
//  Created by 陈浩 on 2017/5/8.
//  Copyright © 2017年 金开门. All rights reserved.
//

#import "UIButton+backgroudColor.h"
#import "UIImage+Tools.h"

@implementation UIButton (backgroudColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    UIImage *image = [UIImage imageWithColor:backgroundColor size:CGSizeMake(2, 2)];
    
    [self setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forState:state];
}

@end
