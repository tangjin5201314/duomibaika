//
//  UIViewController+fyPush.h
//  CashLoan
//
//  Created by fyhy on 2017/9/29.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (fyPush)

- (void)removeSelfWhenPushToNext;
- (void)removeSelfAndParentWhenPushToNext;

@end
