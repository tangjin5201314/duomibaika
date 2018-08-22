//
//  FyUpdateView.m
//  CashLoan
//
//  Created by lilianpeng on 2017/12/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUpdateView.h"

@interface FyUpdateView()

@property (nonatomic, weak) UIView *markView;

@end

@implementation FyUpdateView

- (IBAction)updateClick:(id)sender {
    //    [self hidenCompletion:^{
    if (self.updateBlock) {
        self.updateBlock();
    }
    //    }];
}



- (UIView *)loadMarkView{
    UIView *markView = [[UIView alloc] init];
    markView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    markView.alpha = 0;
    return markView;
}
- (void)show{
    UIView *view = [self loadMarkView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    self.markView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [view addSubview:self];
    
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(window.mas_centerX);
            make.centerY.mas_equalTo(window.mas_centerY).offset(-32);
            make.width.mas_equalTo(@280);
            make.height.mas_equalTo(@300);
        }];
    
    
    [view setNeedsLayout];
    [view layoutIfNeeded];
    //    [self setNeedsLayout];
    //    [self layoutIfNeeded];
    
    
    UIView *snapshotView = [self snapshotViewAfterScreenUpdates:YES];
    CGRect toFrame = self.frame;
    CGRect fromFrame = toFrame;
    fromFrame.origin.y += CGRectGetHeight(window.frame);
    snapshotView.frame = fromFrame;
    
    [view addSubview:snapshotView];
    self.hidden = YES;
    self.markView.alpha = 0;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        snapshotView.frame = toFrame;
        self.markView.alpha = 1;
    } completion:^(BOOL finished) {
        [snapshotView removeFromSuperview];
        self.hidden = NO;
    }];
}


@end
