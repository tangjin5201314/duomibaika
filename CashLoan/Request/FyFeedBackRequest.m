

//
//  FyFeedBackRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyFeedBackRequest.h"

@implementation FyFeedBackRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_FEEDBACK;
}

- (NSDictionary *)params{ //请求参数
    NSAssert(self.message, @"message不能为空");
    return @{@"opinion":self.message};
}


@end
