//
//  FyApplyLoanModelV2.h
//  CashLoan
//
//  Created by fyhy on 2017/11/22.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyBankCardModelV2.h"

@interface FyApplyLoanModelV2 : NSObject

@property (nonatomic, copy) NSArray *dayList;
@property (nonatomic, copy) NSString *defaultDay;
@property (nonatomic, copy) NSString *maxCredit;
@property (nonatomic, copy) NSString *minCredit;
@property (nonatomic, copy) NSString *defaultCredit;
@property (nonatomic, strong) FyBankCardModelV2 *bank;

@end
