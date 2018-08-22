//
//  FyLoanLogListModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanLogListModel.h"

@implementation FyLoanLogListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [FyLoanLogModel class]};
}

@end
