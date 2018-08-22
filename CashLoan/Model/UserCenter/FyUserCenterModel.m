//
//  FyUserCenterModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUserCenterModel.h"

@implementation Auth
@end

@implementation Data
@end


@implementation FyUserCenterModel

-(NSString *)AMorPM{
    return [self.data.ampm isEqual:@"0"] ? @"上午好!" : @"下午好!";
}


@end
