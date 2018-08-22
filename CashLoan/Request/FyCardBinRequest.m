//
//  FyCardBinRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyCardBinRequest.h"
#import "FYCardBin.h"

@implementation FyCardBinRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_CARD_BIN;
}


- (NSDictionary *)params{ //请求参数
    return @{@"cardNo":self.card};
}

- (Class)objectClass{
    return [FYCardBinModel class];
}

- (BOOL)notifyIfError{
    return NO;
}


@end
