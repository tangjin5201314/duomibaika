//
//  FyRepayModel.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyRepayModel.h"

@implementation FyRepayModel

- (NSString *)displayState{
    NSDictionary *stateDict = @{@"10":@"还款中",@"40":@"成功",@"50":@"失败"};
    
    return [stateDict objectForKey:[NSString stringWithFormat:@"%ld", (long)self.state]];
}

@end
