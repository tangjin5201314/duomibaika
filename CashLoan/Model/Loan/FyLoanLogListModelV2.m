//
//  FyLoanLogListModelV2.m
//  CashLoan
//
//  Created by fyhy on 2017/11/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoanLogListModelV2.h"

@implementation FyLoanLogListModelV2

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"historyOrder": [FyOrderDetailModel class]};
}

- (NSString *)title{
    if(!_title){
        _title = @"我的账单";
    }
    return _title;
}

- (NSString *)describe{
    if(!_describe){
        _describe = @"您还没有可操作订单，快去首页借款吧";
    }
    return _describe;
}

- (NSString *)rightStatusTx{
    if (!_rightStatusTx){
        _rightStatusTx = @"还款";
    }
    return _rightStatusTx;
}

@end
