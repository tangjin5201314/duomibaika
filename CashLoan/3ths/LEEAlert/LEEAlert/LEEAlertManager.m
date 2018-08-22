

//
//  LEEAlertManager.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/23.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "LEEAlertManager.h"
#import "UIView+Toast.h"

@implementation LEEAlertManager
static LEEAlertManager * _share = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _share = [[self alloc] init];
    }) ;
    
    return _share;
}

- (void)showTostWithTitle:(NSString *)tittle {
    [CSToastManager sharedStyle].backgroundColor = [UIColor colorWithWhite:0 alpha:0xa0/255.0];
    [CSToastManager sharedStyle].horizontalPadding = 20;
    [CSToastManager sharedStyle].verticalPadding = 20;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window fy_hideAllToasts];
    NSInteger delay = -1;
    if (delay < 0) {
        [window fy_makeToast:tittle duration:[CSToastManager defaultDuration] position:CSToastPositionCenter];
        
    }else{
        [window fy_makeToast:tittle duration:delay position:CSToastPositionCenter];
    }
}

@end
