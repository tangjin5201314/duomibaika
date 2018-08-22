//
//  YMTool.m
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/22.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import "YMTool.h"
#import <sys/utsname.h>

@implementation YMTool
// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
//    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
//    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
//    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
//    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
//    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
//    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
//    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
//    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
//    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
//    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";

    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
//    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
//    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
//    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
//    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
//    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
//    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
//    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
//    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
//    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
//    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    
//    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
//
//    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
//    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
//    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
//    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
//    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
//    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
//    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
//    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
//    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
//    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
//    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
//    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
//    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
//    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
//    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
//    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
//    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
//    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
//    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
//    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
//    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
//    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
//    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
//    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
//    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
//    if ([deviceString isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
//    if ([deviceString isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
//    if ([deviceString isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
//    if ([deviceString isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
//    if ([deviceString isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
//    if ([deviceString isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";

//    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
//    if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
//    if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
//    if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";

//    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
//    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString.length > 0 ? deviceString : @"";
}

+ (NSString *)getBrandName {
    return [UIDevice currentDevice].localizedModel;
}

+ (NSString *)getDivceSize{
    //可用大小
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    long long space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;

    NSInteger size = space / 1024 / 1024 / 1024;
    if (size <= 8) {
        return [NSString stringWithFormat:@"8G"];
    } else if (size <= 16) {
        return [NSString stringWithFormat:@"16G"];
    } else if (size <= 32) {
        return [NSString stringWithFormat:@"32G"];
    } else if (size <= 64) {
        return [NSString stringWithFormat:@"64G"];
    } else if (size <= 128) {
        return [NSString stringWithFormat:@"128G"];
    } else if (size <= 256) {
        return [NSString stringWithFormat:@"256G"];
    } else if (size <= 512) {
        return [NSString stringWithFormat:@"512G"];
    }else if (size <= 1024) {
        return [NSString stringWithFormat:@"1024G"];
    }else {
        return [NSString stringWithFormat:@"大于1024G"];
    }
}

+ (NSInteger)getDivceSizeInt {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    long long space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    
    NSInteger size = space / 1024 / 1024 / 1024;
    if (size <= 8) {
        return 8;
    } else if (size <= 16) {
        return 16;
    } else if (size <= 32) {
        return 32;
    } else if (size <= 64) {
        return 64;
    } else if (size <= 128) {
        return 128;
    } else if (size <= 256) {
        return 256;
    } else if (size <= 512) {
        return 512;
    }else if (size <= 1024) {
        return 1024;
    }else {
        return 2048;
    }
}

+ (NSString *)getRandomMobileNumber {
    NSArray *mobileHeader = @[@(157),@(182),@(187),@(188),@(130),@(131),@(132),@(155),@(156),@(185),@(133),@(153),@(134),@(135),@(136),@(137),@(138),@(139),@(150),@(151),@(152),@(158),@(189),@(175),@(186),@(173)];
    NSInteger headerIndex = [self getRandomNumber:0 to:mobileHeader.count];
    NSNumber *headerNumber = mobileHeader.firstObject;
    if (headerIndex < mobileHeader.count) {
        headerNumber = mobileHeader[headerIndex];
    }
    NSInteger mantissaNumber = [self getRandomNumber:1000 to:9999];
    return [NSString stringWithFormat:@"%@****%ld",headerNumber,(long)mantissaNumber];
}

+ (NSInteger)getRandomMobilePrice {
    NSInteger price = [self getRandomNumber:1500 to:2500];
    price = price - price % 100;
    return price;
}

+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to{
    
    return (NSInteger)(from + (arc4random() % ((to - from) + 1)));
}

+ (NSString *)getUdid {
    return [OpenUDID value];
}


@end
