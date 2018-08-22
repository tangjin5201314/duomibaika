//
//  FyHomeStatusModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/13.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanStatusItemModel.h"
#import "FyUserCenterModel.h"


@interface FyHomeStatusModel : NSObject

@property (nonatomic, strong) NSString *title; //标题

@property (nonatomic, assign) BOOL isPwd; //是否设置交易密码
@property (nonatomic, strong) Auth *auth;//认证map  qualified    是否可借款
//@property (nonatomic, strong) LoanHomePageBorrowDataModel *borrow;
@property (nonatomic, strong) NSString *borrowId; //借款id
@property (nonatomic, strong) NSString *cardId; //银行卡id
@property (nonatomic, strong) NSString *cardName; //银行名
@property (nonatomic, strong) NSString *cardNo; //银行卡号
@property (nonatomic, assign) NSInteger count; //借款次数

@property (nonatomic, assign) BOOL isBorrow; //是否有未完成借款
@property (nonatomic, strong) NSString *fee; //综合费率


@property (nonatomic, strong) NSArray *creditList; //额度数组
@property (nonatomic, strong) NSArray *dayList; //期限数组
@property (nonatomic, strong) NSString *maxCredit; //最大可用额度
@property (nonatomic, copy) NSString *maxAllowMoney; //最大借款金额
@property (nonatomic, strong) NSString *maxDays; //最大借款期限
@property (nonatomic, strong) NSString *minCredit; //最小可用额度
@property (nonatomic, strong) NSString *minDays; //最小借款期限
@property (nonatomic, strong) NSString *total; //信用额度

@property (nonatomic, strong) NSArray *interests; //主动还款
@property (nonatomic, strong) NSArray *list; //状态

@property (nonatomic, assign) BOOL isRepay; //是否需要还款

- (LoanStatusItemModel *)defaultLoanStautsItem;
- (NSString *)formatCardNO;

@end
