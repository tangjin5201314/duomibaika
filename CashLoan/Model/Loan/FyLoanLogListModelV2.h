//
//  FyLoanLogListModelV2.h
//  CashLoan
//
//  Created by fyhy on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyPageModel.h"
#import "FyOrderDetailModel.h"


@interface FyLoanLogListModelV2 : NSObject

@property (nonatomic, copy) NSString *title; //默认为 我的账单
@property (nonatomic, copy) NSString *describe; //默认为 您还没有可操作订单，快去首页借款吧
@property (nonatomic, copy) NSString *rightStatusTx; // 默认为 还款

@property (nonatomic, strong) FyOrderDetailModel *curOrder;
@property (nonatomic, strong) NSArray *historyOrder;
@property (nonatomic, assign) BOOL fromApi;

@end
