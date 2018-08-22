//
//  FyInStagesRateModel.m
//  CashLoan
//
//  Created by fyhy on 2017/12/8.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyInStagesRateModel.h"
#import "NSString+FormatNumber.h"

@implementation FyInStagesAmountModel

- (NSString *)displayPrice{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.price doubleValue]]];
}

@end

@implementation FyInStagesRepayModel

- (NSString *)displayPrice{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.allPrice doubleValue]]];
}


@end


@implementation FyInStagesRateModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"arrivalDetails":[FyInStagesAmountModel class], @"avgAmountDetails":[FyInStagesAmountModel class], @"repaySchedule":[FyInStagesRepayModel class]};
}

- (NSString *)displayArrival{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.arrival doubleValue]]];
}
- (NSString *)displayAvgAmount{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.avgAmount doubleValue]]];
}


@end
