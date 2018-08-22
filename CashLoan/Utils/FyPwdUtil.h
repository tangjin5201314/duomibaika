//
//  FyPwdUtil.h
//  CashLoan
//
//  Created by fyhy on 2017/10/31.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyTradePwdView.h"

@interface FyPwdUtil : NSObject

+ (FyTradePwdView *)checkPwdWithShowTitle:(NSString *)title Complete:(void (^)(NSString *pwd))complete forgetPwd:(void (^)(void))forgetPassword;
+ (FyTradePwdView *)configPwdWithComplete:(void (^)(NSString *pwd1, NSString *pwd2))complete;


+ (FyTradePwdView *)checkPwdWithShowTitle:(NSString *)title netBeginBlock:(void (^)(void))netBegin complete:(void (^)(NSString *pwd, BOOL success, NSString *message))complete forgetPwd:(void (^)(void))forgetPassword;
+ (FyTradePwdView *)configPwdWithnetBeginBlock:(void (^)(void))netBegin complete:(void (^)(NSString *pwd1, NSString *pwd2, BOOL success, NSString *message))complete;


@end
