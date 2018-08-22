//
//  FyPwdUtil.m
//  CashLoan
//
//  Created by fyhy on 2017/10/31.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyPwdUtil.h"
#import "RDPayPasswordView.h"
#import "FyCheckOldPayPwdRequest.h"
#import "FySetLoanPwdRequest.h"
#import "UIView+fyShow.h"

@implementation FyPwdUtil

+ (FyTradePwdView *)checkPwdWithShowTitle:(NSString *)title Complete:(void (^)(NSString *pwd))complete forgetPwd:(void (^)(void))forgetPassword{
    
    FyTradePwdView *view = [FyTradePwdView loadNib];
    view.tradeType = TradeTypeInput;
    view.allPasswordPut = ^(NSString *password)
    {
        NSLog(@"密码3是：%@",password);
        if (complete) {
            complete(password);
        }
    };
    view.frogetPassword = forgetPassword;
    [view fy_Show];
    return view;
//    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
//    RDPayPasswordView *pay = [[RDPayPasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds type:borrow];
//    pay.payMoneyNum = title;
//    [pay refreshUI];
//    [window addSubview:pay];
//    pay.allPasswordPut = ^(NSString *password)
//    {
//        NSLog(@"密码3是：%@",password);
//        if (complete) {
//            complete(password);
//        }
//    };
//
//    pay.frogetPassword = forgetPassword;

}


+ (FyTradePwdView *)configPwdWithComplete:(void (^)(NSString *pwd1, NSString *pwd2))complete{
    
    FyTradePwdView *view = [FyTradePwdView loadNib];
    view.tradeType = TradeTypeSet;
    view.allPasswordPut = ^(NSString *password)
    {
        NSLog(@"密码3是：%@",password);
        if (complete) {
            complete(password, password);
        }
    };
    [view fy_Show];
    return view;

    
//    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
//    RDPayPasswordView *pay = [[RDPayPasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds type:setTradPwd];
//    [pay refreshUI];
//    [window addSubview:pay];
//
//    pay.allPasswordPut = ^(NSString *password)
//    {
//        NSLog(@"密码是：%@",password);
//        RDPayPasswordView *pay = [[RDPayPasswordView alloc]initWithFrame:[UIScreen mainScreen].bounds type:setTradPwdAgain];
//        [pay refreshUI];
//        [window addSubview:pay];
//        pay.allPasswordPut = ^(NSString *password2)
//        {
//            if (complete) {
//                complete(password, password2);
//            }
//        };
//    };
}

+ (FyTradePwdView *)checkPwdWithShowTitle:(NSString *)title netBeginBlock:(void (^)(void))netBegin complete:(void (^)(NSString *pwd, BOOL success, NSString *message))complete forgetPwd:(void (^)(void))forgetPassword{
    FyTradePwdView *view = [FyTradePwdView loadNib];
    view.tradeType = TradeTypeInput;
    view.allPasswordPut = ^(NSString *password)
    {
        if (netBegin)  netBegin();
        [self validateTradePwdWithPwd:password complete:^(BOOL success, NSString *message) {
            if (complete) {
                complete(password, success, message);
            }
            
        }];
    };
    view.frogetPassword = forgetPassword;
    [view fy_Show];

    return view;

}
+ (FyTradePwdView *)configPwdWithnetBeginBlock:(void (^)(void))netBegin complete:(void (^)(NSString *pwd1, NSString *pwd2, BOOL success, NSString *message))complete{
    FyTradePwdView *view = [FyTradePwdView loadNib];
    view.tradeType = TradeTypeSet;
    WS(weakSelf)
    view.allPasswordPut = ^(NSString *password) {
        NSLog(@"密码3是：%@",password);
        if (netBegin)  netBegin();
        
        [weakSelf setPassword:password complete:^(BOOL success, NSString *message) {
            if (complete) {
                complete(password, password, success, message);
            }
        }];

    };
    [view fy_Show];
    return view;

}

+ (void)validateTradePwdWithPwd:(NSString *)password complete:(void (^)(BOOL success, NSString *message))complete{
    FyCheckOldPayPwdRequest *task = [[FyCheckOldPayPwdRequest alloc] init];
    task.pwd = password;
    
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess)
        {
            if ([[error.resData objectForKey:@"pass"] integerValue] == 1) {
                if (complete) {
                    complete(YES, @"密码验证通过");
                }
            }else{
                if (complete) {
                    complete(NO, @"交易密码错误");
                }
            }
        }else
        {
            if (complete) {
                complete(NO, error.errorMessage);
            }
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (complete) {
            complete(NO, nil);
        }
    }];
}


+ (void)setPassword:(NSString *)pwd complete:(void (^)(BOOL success, NSString *message))complete{
    
    FySetLoanPwdRequest *task = [[FySetLoanPwdRequest alloc] init];
    task.payType = PayTypeSet;
    task.nPwd = pwd;
    [[FyNetworkManger sharedInstance] dataTaskWithRequestModel:task success:^(NSURLSessionDataTask *task, FyResponse *error, id model) {
        if (error.errorCode == RDP2PAppErrorTypeYYSuccess){
            if (complete) {
                [FyUserCenter sharedInstance].payPwd = YES;
                [[FyUserCenter sharedInstance] save];
                complete(YES, @"密码设置成功");
            }
        }else{
            if (error.errorCode != NSURLErrorCancelled) {
                if (complete) {
                    complete(NO, error.errorMessage);
                }
            }else{
                if (complete) {
                    complete(NO, @"操作取消");
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, FyResponse *error) {
        if (complete) {
            complete(NO, error.errorMessage);
        }
    }];
}



@end
