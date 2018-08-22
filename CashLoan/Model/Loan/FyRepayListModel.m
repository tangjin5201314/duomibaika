//
//  FyRepayListModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/23.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRepayListModel.h"

@implementation FyRepayListModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [FyRepayModel class]};
}

@end
