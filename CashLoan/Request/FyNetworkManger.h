//
//  FyNetworkManger.h
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyUrlPathDef.h"
#import "FyBaseRequest.h"
#import "FyResponse.h"
#import "FyEasyRequest.h"

#define NOTICE_AppErrorNotification @"AppErrorNotification"

typedef void(^FySuccessBlock)(NSURLSessionDataTask *task, FyResponse *error, id model);
typedef void(^FyFailBlock)(NSURLSessionDataTask *task, FyResponse *error);
typedef void(^YMSuccessBlock)(id data);


@interface FyNetworkManger : NSObject

/**
 *  是否是生产环境，default = YES
 */
@property (nonatomic, assign) BOOL useProductionServer;

@property (nonatomic,copy, readonly) NSString *key; //加密用的appkey
@property (nonatomic,copy, readonly) NSString *secret; //加密用的appsecret
@property (nonatomic,copy, readonly) NSString *baseUrlPath; //host地址
@property (nonatomic,copy, readonly) NSString *debugBaseUrlPath; //沙盒host地址

+ (instancetype)sharedInstance;
- (NSURLSessionDataTask *)dataTaskWithRequestModel:(FyBaseRequest *)requestModel success:(FySuccessBlock)success failure:(FyFailBlock)failure;
- (NSURLSessionDataTask *)dataTaskWithRequestModel:(FyBaseRequest *)requestModel success:(FySuccessBlock)success failure:(FyFailBlock)failure ymSuccess:(YMSuccessBlock)ymSuccess;

- (NSString *)validateMD5EncryptionBody:(NSString *)bodyStr;
- (NSString *)baseURLWithPath:(NSString *)path;
@end
