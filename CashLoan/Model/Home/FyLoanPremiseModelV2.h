//
//  FyLoanPremiseModelV2.h
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyAuthV2.h"
#import "FyUserInfoV2.h"
#import "FyProductV2.h"
#import "FyCreditInfoV2.h"
#import "FyOrderV2.h"

@interface FyLoanPremiseModelV2 : NSObject

@property (nonatomic, strong) FyAuthV2 *auth;
@property (nonatomic, strong) FyCreditInfoV2 *creditInfo;
@property (nonatomic, strong) FyOrderV2 *order;
@property (nonatomic, strong) FyProductV2 *product;
@property (nonatomic, strong) FyUserInfoV2 *userInfo;

@end
