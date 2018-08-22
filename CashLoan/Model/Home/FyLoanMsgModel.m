//
//  FyLoanMsgModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanMsgModel.h"

@implementation FyLoanMsgModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"mID": @"id"};
}

@end


@implementation FyLoanMsgListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [FyLoanMsgModel class]};
}

@end
