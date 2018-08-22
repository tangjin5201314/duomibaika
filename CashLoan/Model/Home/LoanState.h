//
//  LoanState.h
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#ifndef LoanState_h
#define LoanState_h

typedef enum : NSUInteger {
    LoanStateInView = 10, //审核中
    LoanStatePass = 20, //审核通过
    LoanStateNoPass = 21, //审核不通过
    LoanStateWaitingRecheck = 22, //自动审核不通过等人工复审
    LoanStateRecheckPass = 26, //人工复审通过
    LoanStateRecheckNoPass = 27, //人工复审不通过
    LoanStateInLoan = 29, //放款中
    LoanStateWaitingRefund = 30, //pdl：待还款 分期：分期中
    LoanStateLoanFail = 31, //放款失败
    LoanStateInRefund = 35, // 还款中
    LoanStateOverdueInRefund = 36, //逾期还款中
    LoanStateHasRepay = 40,  //已还款
    LoanStateDerateRepay = 41,  //减免还款
    LoanStateOverdue = 50,  //逾期
    LoanStateBillBae = 90,  //坏账

} LoanState;

typedef enum : NSUInteger {
    LoanHomeTypeInView = LoanStateInView, //10审核中
    LoanHomeTypeNoPass = 20, //审核拒绝
    LoanHomeTypeHasLoan = 26, //已放款
    LoanHomeTypeWaitingRefund = LoanStateWaitingRefund, //30待还款
    LoanHomeTypeInRefund = 35, // 还款中
    LoanHomeTypeOverdueInRefund = 36, //逾期还款中
    LoanHomeTypeOverdue = LoanStateOverdue, //50逾期
    LoanHomeTypeBillBae = 90, //坏账
} LoanHomeType;


#endif /* LoanState_h */
