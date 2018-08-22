//
//  FyHomePageStateRequestV2.m
//  CashLoan
//
//  Created by fyhy on 2017/11/22.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomePageStateRequestV2.h"
#import "FyFindIndexModelV2.h"
#import "YMTool.h"

@implementation FyHomePageStateRequestV2

- (NSString *)serviceCode{
    return HOME_GETHOMEINDEX;
}

- (NSDictionary *)params {
    return @{@"vest":@"4",
             @"udid": CHECKNULL([YMTool getUdid]),
             @"model": CHECKNULL([YMTool getDeviceName]),
             @"memory": @([YMTool getDivceSizeInt])
             };
}

- (Class)objectClass{
    return [FyFindIndexModelV2 class];
}


@end
