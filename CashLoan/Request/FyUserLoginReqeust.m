//
//  FyUserLoginReqeust.m
//  CashLoan
//
//  Created by fyhy on 2017/10/16.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyUserLoginReqeust.h"
#import "FyUserCenter.h"
#import <AdSupport/AdSupport.h>
#import "YMTool.h"

//#import "sys/utsname.h"
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>


@implementation FyUserLoginReqeust

- (NSDictionary *)params{ //请求参数
    NSAssert(self.phone, @"手机号不能为空");
    NSAssert(self.code, @"验证码不能为空");
    
    NSMutableDictionary *mutableParams = [@{} mutableCopy];
    NSDictionary *params = @{
                             @"loginName":self.phone,
                             @"vcode":self.code,
                             @"type":self.type,
                             @"businessType":self.businessType,
                             @"registerAddr":@"",
                             @"channelCode":@"0",
                             @"client":@"ios",
                             };
    [mutableParams addEntriesFromDictionary:[self LPGetSystemInfo]];
    [mutableParams addEntriesFromDictionary:params];

    return [mutableParams copy];
}

- (NSString *)serviceCode{
    return API_SERVICE_CODE_USERLOGIN;
}

- (Class)objectClass{
    return [FyUserCenter class];
}

- (NSDictionary *)LPGetSystemInfo {
    //发起Http请求
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    NSString *operatingSystem = [UIDevice currentDevice].systemVersion;
//    NSString *phoneBrand = [UIDevice currentDevice].name;
//    NSString *phoneMark = idfa;
//    NSString *mac = idfa;
//    NSString *phoneType = deviceString;
//    NSString *systemVersions = [UIDevice currentDevice].systemVersion;
//    //构建号
//    NSString *versionCode =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *versionName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *param = @{
                            @"mac":CHECKNULL(idfa),
//                            @"operatingSystem":operatingSystem,
//                            @"phoneBrand":phoneBrand,
                            @"phoneMark":CHECKNULL([YMTool getUdid]),
//                            @"phoneType":phoneType,
//                            @"systemVersions":systemVersions,
//                            @"versionCode":versionCode,
//                            @"imei":@"",
                            @"versionName":versionName,
                            @"appNames":@"多米白卡"
                            };
    return param;
}

- (BOOL)notifyIfError {
    return NO;
}

@end
