//
//  FyHomePageModelV2.m
//  CashLoan
//
//  Created by fyhy on 2017/11/22.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomePageModelV2.h"

@implementation FyHomePageModelV2

+(NSDictionary *)mj_objectClassInArray{
    return @{@"bannerList":[FyBannerModelV2 class], @"carousel":[FyLoanMsgModel class]};
}

@end
