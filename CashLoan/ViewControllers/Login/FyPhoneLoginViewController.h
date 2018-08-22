//
//  FyPhoneLoginViewController.h
//  CashLoan
//
//  Created by lilianpeng on 2017/11/17.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseStaticDataTableViewController.h"
typedef NS_ENUM(NSInteger,PhoneType){
    PhoneTypeLogin = 1,
    PhoneTypeFindLoginPwd
};

@interface FyPhoneLoginViewController : FyBaseStaticDataTableViewController
@property (nonatomic) PhoneType phoneType;
@end
