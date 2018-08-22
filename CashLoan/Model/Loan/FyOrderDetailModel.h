//
//  FyOrderDetailModel.h
//  CashLoan
//
//  Created by fyhy on 2017/12/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyPeriodModel.h"
#import "FyBankCardModelV2.h"

/**
 1 结清
 2 当期待还
 3 未到期
 4 已逾期
 */

typedef enum : NSUInteger {
    FyRepayPlanStatusFinish = 1,
    FyRepayPlanStatusNow,
    FyRepayPlanStatusFuture,
    FyRepayPlanStatusUnOverDue,
} FyRepayPlanStatus;

/**
 1 审核中
 2 放款中
 3 分期中
 4 已逾期
 5 已结清
 6 审核失败
 7 还款中
 */
typedef enum : NSUInteger {
    FyOrderStatusInReview = 1,
    FyOrderStatusPaying,
    FyOrderStatusPaySuccess,
    FyOrderStatusOverDue,
    FyOrderStatusRepaySuccess,
    FyOrderStatusReviewNoPass,
    FyOrderStatusRepaying,
} FyOrderStatus;


@interface FyRepayPlanModel : NSObject

@property (nonatomic, copy) NSString *repayPlanId;
@property (nonatomic, assign) FyRepayPlanStatus status; //状态
@property (nonatomic, assign) NSInteger shedule_no; //第几期
@property (nonatomic, copy) NSString *money; //总金额
@property (nonatomic, copy) NSString *principalInterest; //应还本息
@property (nonatomic, copy) NSString *service_fee; //账户管理费
@property (nonatomic, copy) NSString *penalty; //罚息（必返 没有罚息 会传0）
@property (nonatomic, copy) NSString *statusStr; //状态文案
@property (nonatomic, copy) NSString *dueTime; //还款日
@property (nonatomic, assign) BOOL open; //是否展开详情
@end

@interface FyOrderDetailModel : NSObject

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) BOOL isUnsupportBank; //是否支持银行

@property (nonatomic, copy) NSString *principal; //借款本金
@property (nonatomic, strong) FyPeriodModel *peroid; //借款期限
@property (nonatomic, copy) NSString *ps; //借款订单页文案说明
@property (nonatomic, copy) NSString *boldPs; //加粗部分
@property (nonatomic, copy) NSString *calculateMode; //还款方式描述
@property (nonatomic, copy) NSString *loanUsage; //借款用途
@property (nonatomic, strong) FyBankCardModelV2 *bank; //银行信息
@property (nonatomic, copy) NSString *createTime; //借款日期
@property (nonatomic, assign) FyOrderStatus status; //状态
@property (nonatomic, copy) NSString *statusStr; //状态文案
@property (nonatomic, copy) NSString *icon; //状态图标url
@property (nonatomic, copy) NSString * h5Link; //协议链接
@property (nonatomic, copy) NSArray *repayPlan; //还款计划

- (NSString *)displayLoanAmount;

@end
