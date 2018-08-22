//
//  FyProductV2.h
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyPeriodModel.h"

@interface FyProductV2 : NSObject

@property (nonatomic, copy) NSString * name; //金融产品名称
@property (nonatomic, copy) NSString * singleMax; //单笔可借最大
@property (nonatomic, copy) NSString * singleMin; //单笔可借最小
@property (nonatomic, copy) NSString * defaultLimit; //默认借款期限
@property (nonatomic, copy) NSString * defaultPrice; //默认借款金额
@property (nonatomic, copy) NSString * productInfo; //描述
@property (nonatomic, copy) NSArray * periodValue; //可选期限
@property (nonatomic, copy) NSString * h5Link; //协议链接
@property (nonatomic, assign) NSInteger step;

@end
