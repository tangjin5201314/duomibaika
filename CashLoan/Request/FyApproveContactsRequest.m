//
//  FyApproveContactsRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/19.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyApproveContactsRequest.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>

@implementation FyApproveContactsRequest

- (NSDictionary *)params{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *operatingSystem = [UIDevice currentDevice].systemVersion;
    NSString *phoneBrand = [UIDevice currentDevice].name;
    NSString *phoneMark = idfa;
    NSString *mac = idfa;
    NSString *phoneType = deviceString;
    NSString *systemVersions = [UIDevice currentDevice].systemVersion;
    //构建号
    NSString *versionCode =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *versionName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return @{@"mac":mac, @"operatingSystem":operatingSystem, @"phoneBrand":phoneBrand, @"phoneMark":phoneMark, @"phoneType":phoneType, @"systemVersions":systemVersions, @"versionCode":versionCode, @"versionName":versionName, @"name":self.name, @"phone":self.phone, @"type":self.type, @"relation":self.relation, @"liveAddr":self.liveAddr, @"detailAddr":self.detailAddr, @"liveCoordinate":(self.liveCoordinate?:@""), @"appNames":@"富卡"};
}

- (NSString *)serviceCode{
    return API_SERVICE_CODE_USEREMERCONTACTSAUTH;
}


@end
