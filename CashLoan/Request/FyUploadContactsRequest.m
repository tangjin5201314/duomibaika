//
//  FyUploadContactsRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUploadContactsRequest.h"

@implementation FyUploadContactsRequest

- (NSString *)serviceCode{
    return API_SERVICE_CONTACTS;
}

- (NSDictionary *)params{ //请求参数
    NSAssert(self.info, @"info不能为空");
    return @{@"info":self.info};
}

- (BOOL)notifyIfError{
    return NO;
}


@end
