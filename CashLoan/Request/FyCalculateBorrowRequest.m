//
//  FyCalculateBorrowRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyCalculateBorrowRequest.h"

@implementation FyCalculateBorrowRequest

- (NSDictionary *)params{
    return @{@"amount": self.money, @"timeLimit":self.day};
}

- (NSString *)urlPath{
    return URL_CALCULATEBORROW;
}

- (Class)objectClass{
    return [CalculateBorrowDataModel class];
}


@end
