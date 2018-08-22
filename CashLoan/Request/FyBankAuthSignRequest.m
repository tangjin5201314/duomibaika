//
//  FyBankAuthSignRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBankAuthSignRequest.h"

@implementation FyBankAuthSignRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_BIND_BANK_CARD_RETURN;
}

- (NSDictionary *)params{ //请求参数
    return @{@"cardNo": self.cardNO, @"bank":self.bank, @"bindMob":self.bindMob, @"agreeNo":self.agreeNO, @"userId":self.uuID, @"bankCode" : self.bankCode};
}


@end
