//
//  UIView+LPAdditions.h
//  5i5jAPP
//
//  Created by lilianpeng on 2017/3/13.
//  Copyright © 2017年 NiLaisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LPAdditions)

- (void)addBottomLine:(CGRect)rect;

- (void)addBottomLine:(UIColor *)color inRect:(CGRect)rect;

- (void)addSubViews:(NSArray *)subViews;

- (void)addTopGuidesLine;
- (void)addRightGuidesLine;
- (void)addBottomGuidesLine;
- (void)addBottomGuidesLineWithColor:(NSString *)hexString ;


@end
