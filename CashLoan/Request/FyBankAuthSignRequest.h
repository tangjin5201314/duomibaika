//
//  FyBankAuthSignRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"

@interface FyBankAuthSignRequest : FyBaseRequest

@property (nonatomic, copy) NSString *cardNO;
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *bindMob;
@property (nonatomic, copy) NSString *agreeNO;
@property (nonatomic, copy) NSString *uuID;
@property (nonatomic, copy) NSString *bankCode;

@end
