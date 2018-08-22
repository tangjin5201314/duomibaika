//
//  FyBaseRequest.h
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FyUrlPathDef.h"
#import "FyFileModel.h"
#import "FyResponse.h"

@interface FyBaseRequest : NSObject

@property (nonatomic, weak) NSURLSessionTask *task;
@property (nonatomic, strong, readonly) NSDictionary *buildUrlParams;
@property (nonatomic, strong, readonly) NSString *urlPath;
@property (nonatomic, strong, readonly) NSString *mothod;


typedef void (^fyCompletionHandler)(NSURLSessionDataTask *task, FyResponse *error, id model);
typedef void (^fyCompletionWithCodeHandler)(NSURLSessionDataTask *task, FyResponse *error);


- (NSDictionary *)params; //请求参数
- (NSDictionary *)headerParams; //请求头信息

- (NSString *)serviceCode;  //url路径
- (NSString *)apiVersion;  //api版本号

- (NSArray<FyFileModel *> *)files; //文件

- (Class)objectClass;  //返回数据类型

- (BOOL)isRunning;
- (void)cancelCurrentTask; //取消请求
- (BOOL)notifyIfError; //出错后广播错误信息


@end
