//
//  YMRecordListRequest.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/27.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMRecordListRequest.h"

@implementation YMRecordListRequest
- (NSString *)serviceCode{
    return ORDER_FINDORDERLIST;
}

- (NSDictionary *)params {
    return @{
             @"current" : @(self.current),
             @"pageSize": @(20)
             };

}
- (Class)objectClass{
    return [YMHomeUnfishedOrderModel class];
}
@end
