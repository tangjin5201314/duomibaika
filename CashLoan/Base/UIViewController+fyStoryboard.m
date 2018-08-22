//
//  UIViewController+fyStoryboard.m
//  CashLoan
//
//  Created by fyhy on 2017/10/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "UIViewController+fyStoryboard.h"

@implementation UIViewController (fyStoryboard)

+ (instancetype)loadFromStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier{
    identifier = identifier ? : NSStringFromClass(self);
    
    return [[UIStoryboard storyboardWithName:storyboardName bundle:nil]instantiateViewControllerWithIdentifier:identifier];
}

@end
