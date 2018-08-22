//
//  FyHomeStatusModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomeStatusModel.h"
#import "NSString+FormatNumber.h"

@implementation FyHomeStatusModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"list":[LoanStatusItemModel class]};
}

- (LoanStatusItemModel *)defaultLoanStautsItem{
    if (self.list.count > 0) {
        return self.list[0];
    }
    return nil;
}

- (NSString *)formatCardNO{
    if (self.cardNo) {
        if ([self.cardNo containsString:@"*"]) {
            return self.cardNo;
        }
        
        NSString *str =  self.cardNo;
        NSMutableString *strcopy = [NSMutableString stringWithFormat:@"%@", str];
        
        return [NSString formatNumberWithString:strcopy startIndex:0];
    }
    
    return @"";

}


@end
