//
//  FyAnnouncementRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/20.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyAnnouncementRequest.h"
#import "FyAnnouncementListModel.h"

@implementation FyAnnouncementRequest

- (NSString *)serviceCode{
    return API_SERVICE_CODE_ACCOUNTINFO_APP_PUSH;
}

- (NSDictionary *)params{ //请求参数
    return @{@"type":@"ios"};
}

- (Class)objectClass{
    return [FyAnnouncementListModel class];
}


@end
