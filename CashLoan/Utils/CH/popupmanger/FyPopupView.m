//
//  FyPopupView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import "FyPopupView.h"
#import <Masonry/Masonry.h>

@interface FyPopupView()

@property (nonatomic, weak) UIView *markView;

@end

@implementation FyPopupView

- (IBAction)readDetail:(id)sender {
    [self hidenCompletion:^{
        if (self.readDetailBlock) {
            self.readDetailBlock();
        }
    }];
}


- (IBAction)closeBtnClick:(id)sender {
    [self hidenCompletion:^ {
        if (self.closeBlock) {
            self.closeBlock();
        }
    }];
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
        make.width.mas_equalTo(@280);
        make.height.mas_equalTo(@450);
        make.centerY.mas_equalTo(window.mas_centerY).offset(-32);

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


- (void)hidenCompletion:(void (^)(void))completion{
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.markView removeFromSuperview];
        self.markView = nil;
        if (completion) {
            completion();
        }

    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
