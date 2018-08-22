//
//  YMBuyOutNotifyRequest.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/2/26.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBuyOutNotifyRequest : FyBaseRequest
//订单id
@property (nonatomic, copy) NSString *orderId;
//交易结果
@property (nonatomic, copy) NSString *resultPay;
//连连返回参数
@property (nonatomic, copy) NSString *returnParams;
//交易订单号
@property (nonatomic, copy) NSString *orderNo;

@end
