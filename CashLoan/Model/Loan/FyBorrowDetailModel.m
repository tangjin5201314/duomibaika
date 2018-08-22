//
//  FyBorrowDetailModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBorrowDetailModel.h"
#import "NSString+FormatNumber.h"

@implementation FyBorrowDetailModel

- (NSString *)displayTimeLimit{
    return [NSString stringWithFormat:@"%@天",self.timeLimit];
}
- (NSString *)displayCreateTime{
    return [NSString stringWithFormat:@"申请日期：%@",self.creditTimeStr];
}
- (NSString *)displayAuthFee{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.infoAuthFee doubleValue]]];
}
- (NSString *)displayOverdueAmount{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.overdueAmount doubleValue]]];
}
- (NSString *)displayInterest{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.interest doubleValue]]];
}
- (NSString *)displayLoanAmount{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[[NSString stringWithFormat:@"%ld",(long)[self.amount integerValue]] doubleValue]]];
}

- (NSString *)displayServiceFee{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.serviceFee doubleValue]]];
}

- (NSString *)displayRealAmount{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.realAmount doubleValue]]];
}

- (NSString *)displayRealAmountNoYuan{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.realAmount doubleValue]]];
}


- (NSString *)displayBankCardNameAndNo{
    return  [NSString stringWithFormat:@"%@(%@)",self.bank,[self.cardNo substringFromIndex:self.cardNo.length - 4]];
}

- (NSString *)displayAmountNoYuan{
    return [NSString stringWithFormat:@"%@",[NSString stringNumberFormatterWithDouble:[self.amount doubleValue]]];
}

- (NSString *)displayPenaltyAmountNoYuan{
    return [NSString stringWithFormat:@"%@",[NSString stringNumberFormatterWithDouble:[self.penaltyAmount doubleValue]]];
}

- (NSString *)displayPenaltyAmount{
    return [NSString stringWithFormat:@"%@元",[NSString stringNumberFormatterWithDouble:[self.penaltyAmount doubleValue]]];
}

@end
