//
//  BankCardModel.m
//  CashLoan
//
//  Created by Mr_zhaohy on 2017/2/22.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import "BankCardModel.h"

@implementation BankCardModel
MJLogAllIvars

- (NSString *)userNameDidsplay {
    if (self.userName.length != 0) {
        return [self.userName stringByReplacingCharactersInRange:NSMakeRange(0, self.userName.length - 1) withString:@"*"];
    }
    return self.userName;
}

@end
