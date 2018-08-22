//
//  FyLoanDetailBorrowListModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanDetailBorrowListModel.h"

@implementation FyLoanDetailBorrowListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"borrow" :[FyBorrowDetailModel class], @"repay":[FyRepayDetailModel
 class]};
}

- (FyBorrowDetailModel *)defaultBorrowDetailModel{
    if (self.borrow.count > 0) {
        return self.borrow[0];
    }
    return nil;
}

- (FyRepayDetailModel *)defaultRepayModel{
    if (self.repay.count > 0) {
        return self.repay[0];
    }
    return nil;
}

@end
