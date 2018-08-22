//
//  FyHomePageStateRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyHomePageStateRequest.h"
#import "FyHomeStatusModel.h"

@implementation FyHomePageStateRequest

- (NSString *)urlPath{
    return URLPATH_HOMESTATE;
}


- (Class)objectClass{
    return [FyHomeStatusModel class];
}

@end
