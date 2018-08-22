//
//  FyH5ModelRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/24.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyH5ModelRequest.h"

@implementation FyH5ModelRequest

- (NSString *)mothod{
    return @"GET";
}

- (NSString *)urlPath{
    return self.api;
}

- (Class)objectClass{
    return [NSDictionary class];
}

@end
