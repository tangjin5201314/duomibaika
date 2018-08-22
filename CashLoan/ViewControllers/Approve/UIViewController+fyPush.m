//
//  UIViewController+fyPush.m
//  CashLoan
//
//  Created by fyhy on 2017/9/29.
//  Copyright © 2017年 com.fuyin.lmyq. All rights reserved.
//

#import "UIViewController+fyPush.h"

@implementation UIViewController (fyPush)

- (void)removeSelfWhenPushToNext{
        NSMutableArray *tempArray = [self.navigationController.viewControllers mutableCopy];
        [tempArray removeObject:self];
        self.navigationController.viewControllers = tempArray;
}
- (void)removeSelfAndParentWhenPushToNext{
    NSMutableArray *tempArray = [self.navigationController.viewControllers mutableCopy];
    [tempArray removeObject:self];
    if (tempArray.count > 2) {
        [tempArray removeObjectAtIndex:tempArray.count-2];
    }
    self.navigationController.viewControllers = tempArray;
}


@end
