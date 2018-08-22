//
//  FyLoanLogModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanLogModel.h"
#import "NSString+FormatNumber.h"

@implementation FyLoanLogModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"borrowId":@"id"};
}

- (NSString *)displayLoanAmount{
    return [NSString stringWithFormat:@"%@元", [NSString stringNumberFormatterWithDouble:[self.amount doubleValue]]];
}


@end
