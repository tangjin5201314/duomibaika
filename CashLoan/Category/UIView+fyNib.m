//
//  UIView+fyNib.m
//  cashloan
//
//  Created by 陈浩 on 2017/9/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "UIView+fyNib.h"

@implementation UIView (fyNib)

+ (instancetype)loadNib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end

