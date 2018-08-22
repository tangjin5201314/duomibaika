//
//  FyLoadTaobaoRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/12/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoadTaobaoRequest.h"

@implementation FyLoadTaobaoRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_GETSHANYINSDKAUTHINFO;
}

- (Class)objectClass{
    return [FyTaobaoApproveModel class];
}


@end
