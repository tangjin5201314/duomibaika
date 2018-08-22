//
//  FyLoanLogModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanState.h"

@interface FyLoanLogModel : NSObject

/**
 借款金额
 */
@property(nonatomic,strong)NSNumber *amount;
/**
 综合费用
 */
@property(nonatomic,strong)NSNumber *fee;
/**
 
 */
@property(nonatomic,strong)NSNumber *infoAuthFee;
/**
 收益
 */
@property(nonatomic,strong)NSNumber *interest;
/**
 实际放款金额
 */
@property(nonatomic,strong)NSNumber *realAmount;
/**
 服务费
 */
@property(nonatomic,strong)NSNumber *serviceFee;
/**
 10-审核中 20-待还款 30-已还款',
 */
@property(nonatomic,assign) LoanState state;
@property(nonatomic,copy) NSString *stateStr;
@property(nonatomic,copy) NSString *cardId;
@property(nonatomic,copy) NSString *client;
/**
 申请时间
 */
@property(nonatomic,copy) NSString *creditTimeStr;
/**
 还款时间
 */
@property(nonatomic,copy) NSString *repayTime;
/**
 还款时间(月-日)
 */
@property(nonatomic,copy) NSString *repayTimeStr;
@property(nonatomic,copy) NSString *id;
/**
 订单号
 */
@property(nonatomic,copy) NSString *orderNo;
/**
 借款期限
 */
@property(nonatomic,copy) NSString *timeLimit;
@property(nonatomic,copy) NSString *userId;
/**
 是否逾期
 */
@property(nonatomic,assign) BOOL isPunish;
/**
 逾期金额
 */
@property(nonatomic,copy) NSString *penaltyAmout;
/**
 借款信息
 */
@property(nonatomic,copy) NSString *msg;
/**
 借款id
 */
@property(nonatomic,copy) NSString *borrowId;

/**
 h5地址
 */
@property(nonatomic,copy) NSString *h5Link;

- (NSString *)displayLoanAmount;

@end
