//
//  UIView+fyShow.m
//  CashLoan
//
//  Created by fyhy on 2017/10/25.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "UIView+fyShow.h"
#import <objc/runtime.h>

static char *kStyle = "kStyle";
static char *kMark = "kMark";
static char *kTouch = "kTouch";
static char *kShowBlock = "kShowBlock";
static char *kHiddenBlock = "kHiddenBlock";
static char *kH = "kH";
static char *kW = "kW";

@implementation UIView (fyShow)

- (UIView *)fy_loadMarkView{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(fy_touchDismiss) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    button.alpha = 0;
    return button;
}

- (void)setWillShowBlock:(void (^)())willShowBlock{
    objc_setAssociatedObject(self, kShowBlock, willShowBlock, OBJC_ASSOCIATION_COPY);
}

- (void)setWillHiddenBlock:(void (^)())willHiddenBlock{
    objc_setAssociatedObject(self, kHiddenBlock, willHiddenBlock, OBJC_ASSOCIATION_COPY);
}

- (void)setFy_width:(CGFloat)fy_width{
    objc_setAssociatedObject(self, kW, @(fy_width), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setFy_height:(CGFloat)fy_height{
    objc_setAssociatedObject(self, kH, @(fy_height), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setFyTouchDismiss:(BOOL)fyTouchDismiss{
    objc_setAssociatedObject(self, kTouch, @(fyTouchDismiss), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)fyTouchDismiss{
    return [objc_getAssociatedObject(self, kTouch) boolValue];
}

- (void)setFyShowStyle:(FyViewShowStyle)fyShowStyle{
    objc_setAssociatedObject(self, kStyle, @(fyShowStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)())willShowBlock{
    return objc_getAssociatedObject(self, kShowBlock);
}

- (void (^)())willHiddenBlock{
    return objc_getAssociatedObject(self, kHiddenBlock);
}

- (CGFloat)fy_width{
    return [objc_getAssociatedObject(self, kW) floatValue];
}

- (CGFloat)fy_height{
    return [objc_getAssociatedObject(self, kH) floatValue];
}

- (FyViewShowStyle)fyShowStyle{
    return [objc_getAssociatedObject(self, kStyle) integerValue];
}

- (void)setFyMarkView:(UIView *)fyMarkView{
    objc_setAssociatedObject(self, kMark, fyMarkView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)fyMarkView{
    return objc_getAssociatedObject(self, kMark);
}

- (void)fy_Show{
    if (!self.fyMarkView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *view = [self fy_loadMarkView];
        [window addSubview:view];
        self.fyMarkView = view;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [view addSubview:self];
        
        CGFloat h = self.fy_height ? : CGRectGetHeight(self.frame);
        
        if (self.fyShowStyle == FyViewShowStyleBottom) {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(@0);
                if (self.fy_width) {
                    make.width.mas_equalTo(@(self.fy_width));
                    make.centerX.mas_equalTo(@0);
                }else{
                    make.right.left.mas_equalTo(@0);
                }
                make.height.mas_equalTo(@(h));
            }];
        }else{
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.fy_width) {
                    make.width.mas_equalTo(@(self.fy_width));
                    make.centerX.mas_equalTo(@0);
                }else{
                    make.right.left.mas_equalTo(@0);
                }
                make.height.mas_equalTo(@(h));
                make.centerY.mas_equalTo(@0);
            }];
            
        }
        
        [view setNeedsLayout];
        [view layoutIfNeeded];
    }

    [self fyShow:YES];
}

- (void)fy_Hidden{
    if (!self.superview) return;
    [self fyShow:NO];
}

- (void)fyShow:(BOOL)isShow{
    
    if (isShow)
    {
        if(self.willShowBlock) self.willShowBlock();
    }
    else
    {
        if(self.willHiddenBlock) self.willHiddenBlock();
    }
    
    UIView *snapshotView = [self snapshotViewAfterScreenUpdates:YES];
    
    CGRect toFrame, fromFrame;
    CGAffineTransform toSale, fromSale;

    toSale = isShow ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.6f , 0.6f);
    fromSale = isShow ? CGAffineTransformMakeScale(0.6f , 0.6f) : CGAffineTransformIdentity;

    CGFloat toAlpha = isShow ? 1 : 0;
    CGFloat fromAlpha = isShow ? 0 : 1;
    
    CGRect toF = self.frame;
    CGRect fromF = toF;
    fromF.origin.y = CGRectGetHeight(self.frame) + kScreenHeight;
    
    toFrame = isShow ? toF : fromF;
    fromFrame = isShow ? fromF : toF;
    
    snapshotView.frame = fromFrame;

    if (self.fyShowStyle == FyViewShowStyleCenter) {
        self.transform = fromSale;
//        snapshotView.center = self.center;
    }else{
        [self.fyMarkView addSubview:snapshotView];
        self.hidden = YES;
    }
    
    self.fyMarkView.alpha = fromAlpha;
    
    CGFloat duration = isShow ? 0.25 : 0.1;
    
    [UIView animateWithDuration:duration animations:^{
        if (self.fyShowStyle == FyViewShowStyleCenter) {
            self.transform = toSale;
        }else{
            snapshotView.frame = toFrame;
        }
        self.fyMarkView.alpha = toAlpha;
    } completion:^(BOOL finished) {
        [snapshotView removeFromSuperview];
        self.hidden = NO;
        if (!isShow) {
            [self removeFromSuperview];
            [self.fyMarkView removeFromSuperview];
            self.fyMarkView = nil;
        }
    }];
}

- (void)fy_touchDismiss{
    if (self.fyTouchDismiss) {
        [self fy_Hidden];
    }
}

@end
