//
//  FyOrderDetailModel.m
//  CashLoan
//
//  Created by fyhy on 2017/12/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyOrderDetailModel.h"
#import "NSString+FormatNumber.h"

@implementation FyRepayPlanModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"repayPlanId": @"id"};
}

@end

@implementation FyOrderDetailModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"repayPlan":[FyRepayPlanModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"orderId": @"id"};
}


- (NSString *)displayLoanAmount{
    return [NSString stringWithFormat:@"%@元", [NSString stringNumberFormatterWithDouble:[self.principal doubleValue]]];
}

@end
