//
//  YMTool.h
//  CashLoan
//
//  Created by 叮咚钱包富银 on 2018/1/22.
//  Copyright © 2018年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenUDID.h"

@interface YMTool : NSObject

/**
 获取设备名称

 @return 设备名
 */
+ (NSString *)getDeviceName;
/**
 获取设设备型号

 @return 型号
 */
+ (NSString *)getBrandName;
/**
 获取系统总内存
 
 @return 总内存
 */
+ (NSString *)getDivceSize;

/**
 获取系统总内存
 
 @return 总内存
 */
+ (NSInteger )getDivceSizeInt;
/**
 获取随机电话号码
 @return 随机号码
 */
+ (NSString *)getRandomMobileNumber;

/**
 获取随机价格

 @return 随机价格
 */
+ (NSInteger)getRandomMobilePrice;

+ (NSString *)getUdid;

@end
