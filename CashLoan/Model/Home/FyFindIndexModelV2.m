//
//  FyFindIndexModelV2.m
//  CashLoan
//
//  Created by fyhy on 2017/12/7.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyFindIndexModelV2.h"

@implementation YMHomeMobileModel
MJLogAllIvars
@end

@implementation YMHomePeriodListModel
MJLogAllIvars
@end

@implementation YMHomeUnfishedOrderModel
MJLogAllIvars
@end

@implementation FyFindIndexModelV2
MJLogAllIvars

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"periodList":[YMHomePeriodListModel class]};
}

@end
