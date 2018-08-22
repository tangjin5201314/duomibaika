//
//  FyAutoDismissResultView.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyAutoDismissResultView.h"

static int const showtime = 3;

@interface FyAutoDismissResultView()

@property (nonatomic, strong) NSTimer *countTimer;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (nonatomic, assign) int count;

@end

@implementation FyAutoDismissResultView

- (void)show {
    [self startTimer];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)countDown {
    _count --;
    self.bottomLabel.text = [NSString stringWithFormat:@"%ld秒后跳转回首页",(long)_count];
    if (_count == 0) {
        [self removeView];
    }
}

// 页面显示的时间
- (NSTimer *)countTimer {
    
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

// 定时器倒计时
- (void)startTimer {
    _count = self.showTime > 0 ? self.showTime : showtime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

// 移除页面
- (void)removeView {
    // 停掉定时器
    [self.countTimer invalidate];
    self.countTimer = nil;
    if (self.dismissBlock) {
        self.dismissBlock();
    }

    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
