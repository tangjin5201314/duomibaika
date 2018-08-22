//
//  FyInStagesRateModel.h
//  CashLoan
//
//  Created by fyhy on 2017/12/8.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FyInStagesAmountModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;

- (NSString *)displayPrice;


@end

@interface FyInStagesRepayModel : NSObject

@property (nonatomic, copy) NSString *allPrice;
@property (nonatomic, copy) NSString *dueTime;

- (NSString *)displayPrice;

@end


@interface FyInStagesRateModel : NSObject

@property (nonatomic, copy) NSString *principal; //借款本金
@property (nonatomic, copy) NSString *periodValue; //期限
@property (nonatomic, copy) NSString *calculateMode; //还款方式
@property (nonatomic, copy) NSArray *repaySchedule; //还款计划

@property (nonatomic, copy) NSString *arrival; //到账金额
@property (nonatomic, copy) NSArray *arrivalDetails; //到账金额详情
@property (nonatomic, copy) NSString *avgAmount; //每期大约应还金额
@property (nonatomic, copy) NSArray *avgAmountDetails; //每期大约应还金额详情

- (NSString *)displayArrival;
- (NSString *)displayAvgAmount;


@end
