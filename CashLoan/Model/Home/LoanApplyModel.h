//
//  LoanApplyModel.h
//  CashLoan
//
//  Created by rdmacmini on 17/2/21.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanApplyModel : NSObject

//借款金额
@property (nonatomic , strong) NSString *amount;
//银行卡关联id

@property (nonatomic , strong) NSString *cardId;
//综合费用

@property (nonatomic , strong) NSString *fee;
//订单号

@property (nonatomic , strong) NSString *orderNo;
//实际到账金额
@property (nonatomic , strong) NSString *realAmount;
//借款期限

@property (nonatomic , strong) NSString *timeLimit;
//交易密码

@property (nonatomic , strong) NSString *tradePwd;

//是否设置交易密码

@property (nonatomic , assign) BOOL isPwd;


@property (nonatomic , strong) NSString *bankName;
@property (nonatomic , strong) NSString *bankNum;
@property (nonatomic , strong) NSString *indexBankNum;


@end
