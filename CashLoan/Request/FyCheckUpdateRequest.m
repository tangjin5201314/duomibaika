//
//  FyCheckUpdateRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyCheckUpdateRequest.h"

@implementation FyCheckUpdateRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_CHECKUPDATE;
}

- (NSDictionary *)params{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"firstAct": @"1"}];
    NSString *firstAct = [[NSUserDefaults standardUserDefaults] stringForKey:@"firstAct"];
    
    return @{@"firstAct": firstAct};
}

@end
