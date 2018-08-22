//
//  FyCreditInfoV2.h
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CreditStautsNot = 1,
    CreditStautsUnderWay,
    CreditStautsSuccess,
} CreditStauts;

@interface FyCreditInfoV2 : NSObject

@property (nonatomic, assign) CreditStauts isHasCredit; //是否已计算金额
@property (nonatomic, copy) NSString * credit; //可用借款金额
@property (nonatomic, copy) NSString * maxCredit; //最大借款金额

@end
