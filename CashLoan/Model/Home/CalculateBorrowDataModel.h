//
//  CalculateBorrowDataModel.h
//  CashLoan
//
//  Created by hey on 2017/5/8.
//  Copyright © 2017年 heycom.eongdu.xianjingdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeeDetailDataModel.h"

@interface CalculateBorrowDataModel : NSObject

@property (nonatomic , strong) NSString *amount;
@property (nonatomic , strong) NSString *fee;
@property (nonatomic , strong) NSString *realAmount;
@property (nonatomic , strong) NSString *timeLimit;
@property (nonatomic , strong) FeeDetailDataModel *feeDetail;

@end
