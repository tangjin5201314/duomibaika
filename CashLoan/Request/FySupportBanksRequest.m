//
//  FySupportBanksRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/12/15.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FySupportBanksRequest.h"

@implementation FySupportBankModel
@end

@implementation FySupportBankListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : [FySupportBankModel class]};
}

@end

@implementation FySupportBanksRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_SUPPORT_BANK_LIST;
}

- (Class)objectClass{
    return [FySupportBankListModel class];
}

@end
