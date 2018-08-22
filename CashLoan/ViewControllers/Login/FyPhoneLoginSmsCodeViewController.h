//
//  FyPhoneLoginSmsCodeViewController.h
//  CashLoan
//
//  Created by lilianpeng on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"
typedef NS_ENUM(NSInteger,SMSType){
    SMS_LoginOrRegister = 1,
    SMS_SetLoginPWD,
    SMS_ForgetLoginPWD,
    SMS_ForgetPayPWD
};
@interface FyPhoneLoginSmsCodeViewController : FyBaseStaticDataTableViewController

@property (nonatomic, weak) UIViewController * lastVC;

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) SMSType smsType;

@end
