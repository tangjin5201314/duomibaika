//
//  RDCountDownButton.m
//  baianlicai
//
//  Created by Liang Shen on 16/5/19.
//  Copyright © 2016年 Yosef Lin. All rights reserved.
//

#import "RDCountDownButton.h"

@implementation RDCountDownButton

#pragma -mark touche action
-(void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler{
    _touchedCountDownButtonHandler = [touchedCountDownButtonHandler copy];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)touched:(RDCountDownButton*)sender{
    if (_touchedCountDownButtonHandler) {
        _touchedCountDownButtonHandler(sender,sender.tag);
    }
}
#pragma -mark count down method
-(void)startCountDownWithSecond:(NSUInteger)totalSecond
{
    _totalSecond = totalSecond;
    _second = totalSecond;
    UIColor *btnColor = [UIColor colorWithHexString:@"333848"];
    self.tintColor = btnColor;
    [self setTitleColor:btnColor forState:UIControlStateNormal];
    [self setTitleColor:btnColor forState:UIControlStateDisabled];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    _startDate = [NSDate date];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)timerStart:(NSTimer *)theTimer {

    double deltaTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    
    _second = _totalSecond - (NSInteger)(deltaTime+0.5) ;
    
    
    if (_second< 1.0)
    {
        [self stopCountDown];
    }
    else
    {
        if (_countDownChanging)
        {
            self.titleLabel.text = _countDownChanging(self,_second);
            [self setTitle:_countDownChanging(self,_second) forState:UIControlStateNormal];
            [self setTitle:_countDownChanging(self,_second) forState:UIControlStateDisabled];

        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"%zd秒",_second];
            self.titleLabel.text = title;
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];
            
        }
    }
}

- (void)stopCountDown{
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)])
        {
            if ([_timer isValid])
            {
                [_timer invalidate];
                _second = _totalSecond;
                if (_countDownFinished)
                {
                    self.titleLabel.text = _countDownFinished(self,_second);
                    [self setTitle:_countDownFinished(self,_totalSecond)forState:UIControlStateNormal];
                    [self setTitle:_countDownFinished(self,_totalSecond)forState:UIControlStateDisabled];

                }
                else
                {
                    self.titleLabel.text = @"重新获取";
                    [self setTitle:@"重新获取" forState:UIControlStateNormal];
                    [self setTitle:@"重新获取" forState:UIControlStateDisabled];

                }
            }
        }
    }else{
        if (_countDownFinished)
        {
            self.titleLabel.text = _countDownFinished(self,_second);
            [self setTitle:_countDownFinished(self,_totalSecond)forState:UIControlStateNormal];
            [self setTitle:_countDownFinished(self,_totalSecond)forState:UIControlStateDisabled];
            
        }
        else
        {
            self.titleLabel.text = @"重新获取";
            [self setTitle:@"重新获取" forState:UIControlStateNormal];
            [self setTitle:@"重新获取" forState:UIControlStateDisabled];
            
        }
    }
}
#pragma -mark block
-(void)countDownChanging:(CountDownChanging)countDownChanging{
    _countDownChanging = [countDownChanging copy];
}
-(void)countDownFinished:(CountDownFinished)countDownFinished{
    _countDownFinished = [countDownFinished copy];
}
@end
