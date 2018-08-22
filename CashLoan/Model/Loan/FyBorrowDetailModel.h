//
//  FyBorrowDetailModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyRepayModel.h"
#import "FyPenaltyState.h"

@interface FyBorrowDetailModel : NSObject

/**
 借款金额
 */
@property(nonatomic,strong) NSString *amount;
/**
 服务费
 */
@property(nonatomic,strong) NSString *infoAuthFee;
/**
 账户管理费
 */
@property (nonatomic , copy) NSString * serviceFee;

/**
 应还金额
 */
@property(nonatomic,strong) NSString *overdueAmount;
/**
 逾期金额
 */
@property(nonatomic,strong) NSString *penaltyAmount;
/**
 逾期状态
 */
@property(nonatomic,assign) FyPenaltyState penalty;
/**
 收款银行
 */
@property(nonatomic,copy) NSString *bank;
/**
 银行卡
 */
@property(nonatomic,copy) NSString *cardNo;
/**
 申请时间
 */
@property(nonatomic,copy) NSString *createTime;
/**
 申请时间（删除时分秒）
 */
@property(nonatomic,copy) NSString *creditTimeStr;
/**
 综合费用
 */
@property(nonatomic,strong) NSString *fee;
/**
 实际放款金额
 */
@property(nonatomic,strong) NSString *realAmount;
/**
 借款期限
 */
@property(nonatomic,copy) NSString *timeLimit;

/**
 借款状态
 */
@property(nonatomic,copy) NSString *state;

/**
 利息
 */
@property(nonatomic,copy) NSString *interest;
/**
 逾期天数
 */

/**
 h5link
 */
@property(nonatomic,copy) NSString *h5Link;

@property(nonatomic,copy) NSString *penaltyDay;

@property (nonatomic , strong) FyRepayModel * repayRecordModel;


- (NSString *)displayTimeLimit; //期限
- (NSString *)displayCreateTime; //申请日期
- (NSString *)displayAuthFee; //服务费
- (NSString *)displayOverdueAmount; //
- (NSString *)displayInterest; //利息
- (NSString *)displayLoanAmount;
- (NSString *)displayServiceFee;
- (NSString *)displayRealAmount;
- (NSString *)displayBankCardNameAndNo;
- (NSString *)displayAmountNoYuan;
- (NSString *)displayRealAmountNoYuan;
- (NSString *)displayPenaltyAmountNoYuan;
- (NSString *)displayPenaltyAmount;

@end
