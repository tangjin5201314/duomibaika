//
//  UIViewController+fyStoryboard.h
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (fyStoryboard)

+ (instancetype)loadFromStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier;

@end
