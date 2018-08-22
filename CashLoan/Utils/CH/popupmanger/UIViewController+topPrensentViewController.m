//
//  UIViewController+topPrensentViewController.m
//  HSY
//
//  Created by 陈浩 on 2017/5/19.
//  Copyright © 2017年 金开门. All rights reserved.
//

#import "UIViewController+topPrensentViewController.h"

@implementation UIViewController (topPrensentViewController)

- (UIViewController *)fy_topPrensentViewController{
    UIViewController *vc = self.presentedViewController;
    if (!vc && [self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabvc = (id)self;
        vc = [tabvc.selectedViewController fy_topPrensentViewController];
    }
    
    if (!vc) {
        return self;
    }else{
        return [vc fy_topPrensentViewController];
    }
}

@end
