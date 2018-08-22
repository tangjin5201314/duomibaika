//
//  FyLoginUtil.h
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FyLoginUtil : NSObject

+ (BOOL)showLoginViewControllerFromViewConrollerInNeeded:(UIViewController *)vc; //返回yes如果不需要登录

@end
