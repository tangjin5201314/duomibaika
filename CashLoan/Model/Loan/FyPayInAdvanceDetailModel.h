//
//  FyPayInAdvanceDetailModel.h
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyPenaltyState.h"

@interface FyPayInAdvanceDetailModel : NSObject

@property (nonatomic , copy) NSString              * dueAmount;
@property (nonatomic , copy) NSString              * dueInfoAuthFee;
@property (nonatomic , copy) NSString              * cardNo;
@property (nonatomic , copy) NSString              * duePrincipal;
@property (nonatomic , assign) FyPenaltyState        penaltyState;
@property (nonatomic , copy) NSString              * dueServiceFee;
@property (nonatomic , copy) NSString              * bank;
@property (nonatomic , copy) NSString              * duePenaltyAmout;
@property (nonatomic , copy) NSString              * dueInterest;
@property (nonatomic , copy) NSString              * repayTime;
@property (nonatomic, assign) BOOL               isPwd;

@end
