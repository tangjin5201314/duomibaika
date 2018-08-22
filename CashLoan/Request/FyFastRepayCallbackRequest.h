//
//  FyFastRepayCallbackRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/25.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyFastRepayCallbackRequest : FyBaseRequest

@property (nonatomic, copy) NSString *borrowID;
@property (nonatomic, copy) NSString *resultPay;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *returnParam;

@end
