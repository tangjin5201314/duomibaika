//
//  FyLoadMoxieRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/12/12.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyLoadMoxieRequest.h"
#import "FyMailApproveModel.h"

@implementation FyLoadMoxieRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_GETMOXIEAPIKEYANDTOKEN;
}

- (Class)objectClass{
    return [FyMailApproveModel class];
}

@end
