//
//  LoanStatusItemModel.h
//  CashLoan
//
//  Created by hey on 2017/2/20.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanState.h"

@interface RemainTime :NSObject
@property (nonatomic , copy) NSString              * day;
@property (nonatomic , copy) NSString              * min;
@property (nonatomic , copy) NSString              * hour;

@end

@interface RepayRecordModel :NSObject

@property (nonatomic , copy) NSString              * content;
@property (nonatomic , copy) NSString              * repayTime;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * repayDate;
@end

@interface LoanStatusItemModel : NSObject

@property (nonatomic, strong) NSString *borrowId;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *loanTime;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *repayTime;

@property (nonatomic, copy) NSString * state; //状态描述...
@property (nonatomic, copy) NSString * stateStr;

@property (nonatomic, assign) LoanHomeType type; //首页状态判断使用（与state状态部分相同）

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *amount;

@property (nonatomic, strong) NSString *timeLimit;

@property (nonatomic, strong) NSString *overdue;

@property (nonatomic , strong) RepayRecordModel              * repayRecordModel;
@property (nonatomic , strong) RemainTime              * remainTime;


@end
