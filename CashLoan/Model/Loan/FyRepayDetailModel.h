//
//  FyRepayDetailModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FyRepayDetailModel : NSObject

/**
 还款金额
 */
@property(nonatomic,strong) NSNumber *amount;
/**
 还款时间
 */
@property(nonatomic,copy) NSString *repayTime;
/**
 还款时间(删除时分秒)
 */
@property(nonatomic,copy) NSString *repayTimeStr;
/**
 实际还款金额
 */
@property(nonatomic,copy) NSString *realRepayAmount;
/**
 实际还款时间
 */
@property(nonatomic,copy) NSString *realRepayTime;


@end
