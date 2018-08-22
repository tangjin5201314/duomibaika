//
//  FYRadiusView.h
//  SATEST
//
//  Created by 陈浩 on 2017/9/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYRadiusView : UIView

@property (nonatomic, assign) IBInspectable NSInteger corners;
@property (nonatomic, assign) IBInspectable CGFloat radius;
@property (nonatomic, assign) IBInspectable CGFloat shadow;
@property (nonatomic, strong) UIColor * shadowColor;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, strong) UIColor * backgroundColor;

@end
