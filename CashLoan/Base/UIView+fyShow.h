//
//  UIView+fyShow.h
//  CashLoan
//
//  Created by fyhy on 2017/10/25.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FyViewShowStyleBottom = 0,
    FyViewShowStyleCenter = 1,
} FyViewShowStyle;

@interface UIView (fyShow)

@property (nonatomic, assign) IBInspectable FyViewShowStyle fyShowStyle;
@property (nonatomic, weak) UIView *fyMarkView;
@property (nonatomic, assign) BOOL fyTouchDismiss;
@property (nonatomic, assign) IBInspectable CGFloat fy_width;
@property (nonatomic, assign) IBInspectable CGFloat fy_height;

@property (nonatomic, copy) void (^willShowBlock)();
@property (nonatomic, copy) void (^willHiddenBlock)();

- (void)fy_Show;
- (void)fy_Hidden;

@end
