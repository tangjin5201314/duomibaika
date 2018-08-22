//
//  FySetLoginPwdViewController.h
//  CashLoan
//
//  Created by lilianpeng on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"
typedef NS_ENUM(NSInteger,PwdType){
    Pwd_ResetPay = 1,//修改交易密码
    Pwd_SetLogin,//设置登录密码
    Pwd_ForgetLogin,//忘记登录密码
    Pwd_ResetLogin,//修改登录密码
    Pwd_ForgetPay//忘记交易密码

};
@interface FySetLoginPwdViewController : FyBaseStaticDataTableViewController

@property (nonatomic, copy) NSString *vCode;
@property (nonatomic, copy) NSString *vCodeBusinessType;
@property (nonatomic, copy) NSString *oldPwd;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic) PwdType pwdType;
@property (nonatomic, weak) UIViewController * lastVC;

@end
