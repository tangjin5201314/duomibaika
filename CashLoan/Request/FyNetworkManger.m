//
//  FyNetworkManger.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyNetworkManger.h"
#import "FyNetworkManger+fyAdd.h"
#import <AFNetworking/AFNetworking.h>
#import "FyNetworkResult.h"
#import <MJExtension/MJExtension.h>
#import <CommonCrypto/CommonDigest.h>

@interface FyNetworkManger()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation FyNetworkManger

- (NSString *)key{
    return APP_KEY;
}

- (NSString *)secret{
    return APP_SECRET;
}

#pragma mark ---正式环境  基本URL-----
- (NSString *)baseUrlPath{
    return APP_BASEURLPATH;
}

#pragma mark ---测试环境  基本URL-----
- (NSString *)debugBaseUrlPath{
    return APP_BASEURLPATH_DEV;
}

+ (instancetype)sharedInstance{
    static FyNetworkManger *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[FyNetworkManger alloc] init];
            instance.manager = [AFHTTPSessionManager manager];
            instance.manager.requestSerializer.timeoutInterval = 30;
        }
    });
    return instance;
}

- (NSString *)BaseURL{
    return _useProductionServer ? self.baseUrlPath : self.debugBaseUrlPath;
}

- (NSString *)domaine:(NSString *)domaine path:(NSString *)path{
    return [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:domaine]].absoluteString;
}

- (NSString *)baseURLWithPath:(NSString *)path{
    return [self domaine:self.BaseURL path:path];
}

- (NSURLSessionDataTask *)dataTaskWithRequestModel:(FyBaseRequest *)requestModel success:(FySuccessBlock)success failure:(FyFailBlock)failure{
    if (requestModel.files.count > 0) {
        return [self uploadDataTaskWithRequestModel:requestModel success:success failure:failure];
    }else{
        return [self defaultDataTaskWithRequestModel:requestModel success:success failure:failure ymSuccess:nil];
    }
}

- (NSURLSessionDataTask *)dataTaskWithRequestModel:(FyBaseRequest *)requestModel success:(FySuccessBlock)success failure:(FyFailBlock)failure ymSuccess:(YMSuccessBlock)ymSuccess {
    if (requestModel.files.count > 0) {
        return [self uploadDataTaskWithRequestModel:requestModel success:success failure:failure];
    }else{
        return [self defaultDataTaskWithRequestModel:requestModel success:success failure:failure ymSuccess:ymSuccess];
    }
}

- (NSURLSessionDataTask *)uploadDataTaskWithRequestModel:(FyBaseRequest *)requestModel success:(FySuccessBlock)success failure:(FyFailBlock)failure {
    TmpBodyHeaderObject *object = [self bodyHeardObjectWithRequsetModel:requestModel]; //requestModel分解
    AFHTTPSessionManager *manager = _manager;
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    manager.requestSerializer.timeoutInterval = 120;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
    NSError *serializationError = nil;
    if (object.headerParams) {
        [object.headerParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[self baseURLWithPath:[requestModel urlPath]] parameters:object.bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (requestModel.files && requestModel.files.count > 0) {
            for (FyFileModel *file in requestModel.files) {
                NSData *fileData = file.fileData;
                [formData appendPartWithFileData:fileData name:file.name fileName:file.filename mimeType:file.mimeType];
            }
        }
    } error:&serializationError];

    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, [self errorWithNetworkError:serializationError]);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [manager dataTaskWithRequest:request
                             uploadProgress:nil
                           downloadProgress:nil
                          completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                              NSLog(@"url:\n %@", [self baseURLWithPath:[requestModel urlPath]]);
                              NSLog(@"parmas:\n %@", object.bodyParams);
                              NSLog(@"header:\n%@", object.headerParams);

                              if (error) {
                                  FyResponse *appResponse = [self errorWithNetworkError:error];
                                  
                                  if (failure) {
                                      failure(dataTask, appResponse);
                                  }
                                  
                                  if ([requestModel notifyIfError]) {
                                      [self unifiedTreatmentAppError:appResponse];
                                  }
                                  
                              } else {
                                  FyResponse *appResponse = [self successErrorWithResponseObject:responseObject];
                                  appResponse.responseObject = responseObject;
                                  if (success) {
                                      success(dataTask, appResponse, [self response:responseObject convertToModelClass:[requestModel objectClass] appResponse:appResponse]);
                                  }
                                  if ([requestModel notifyIfError]) {
                                      [self unifiedTreatmentAppError:appResponse];
                                  }
                                  
                              }
                          }];
    //启动
    [dataTask resume];
    requestModel.task = dataTask;
    
    return dataTask;
}


- (NSURLSessionDataTask *)defaultDataTaskWithRequestModel:(FyBaseRequest *)requestModel success:(FySuccessBlock)success failure:(FyFailBlock)failure ymSuccess:(YMSuccessBlock)ymSuccess {
    
    TmpBodyHeaderObject *object = [self bodyHeardObjectWithRequsetModel:requestModel];
    AFHTTPSessionManager *manager = _manager;
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    manager.requestSerializer.timeoutInterval = 60;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
   
    NSError *serializationError = nil;
    if (object.headerParams) {
        [object.headerParams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    

    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:[requestModel mothod] URLString:[self baseURLWithPath:[requestModel urlPath]] parameters:object.bodyParams error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, [self errorWithNetworkError:serializationError]);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [manager dataTaskWithRequest:request
                             uploadProgress:nil
                           downloadProgress:nil
                          completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                              NSLog(@"parmas:\n %@", object.bodyParams);
                              NSLog(@"header:\n%@", object.headerParams);
                              NSLog(@"url:\n %@", [self baseURLWithPath:[requestModel urlPath]]);
                              NSLog(@"err:\n %@",error);
                              NSLog(@"response\n %@",responseObject);
                              if (error) {
                                  FyResponse *appResponse = [self errorWithNetworkError:error];
                                  
                                  if (failure) {
                                      failure(dataTask, appResponse);
                                  }
                                  
                                  if ([requestModel notifyIfError]) {
                                      [self unifiedTreatmentAppError:appResponse];
                                  }
                                  
                              } else {
                                  FyResponse *appResponse = [self successErrorWithResponseObject:responseObject];
                                  appResponse.responseObject = responseObject;
                                  
                                  if (ymSuccess) {
                                      ymSuccess([appResponse.resultData mj_JSONObject]);
                                  }
                                  if (success) {
                                      success(dataTask, appResponse, [self response:responseObject convertToModelClass:[requestModel objectClass] appResponse:appResponse]);
                                  }
                                  if ([requestModel notifyIfError]) {
                                      [self unifiedTreatmentAppError:appResponse];
                                  }
                              }
                          }];
    //启动
    [dataTask resume];
    requestModel.task = dataTask;
    
    return dataTask;
}

- (FyResponse *)errorWithNetworkError:(NSError *)error{
    return [[FyResponse alloc] initWithCode:error.code errorMessage:@"网络连接错误，请查看网络是否已连接!" responseData:nil];
}

- (FyResponse *)successErrorWithResponseObject:(id)responseObject{
    FyNetworkResult *result = [FyNetworkResult mj_objectWithKeyValues:responseObject];
    if (result == nil || (result.resultCode == 0 && result.resultMessage == nil)) {
        return [[FyResponse alloc] initWithCode:RDP2PAppErrorTypeYYResponseModel errorMessage:@"返回数据格式有问题" responseData:responseObject];
    }
    
    return [[FyResponse alloc] initWithCode:result.resultCode errorMessage:result.resultMessage resData:result.resultData pageData:result.page];
}

- (id)response:(id)responseObject convertToModelClass:(__unsafe_unretained Class)ModelClass appResponse:(FyResponse *)appResponse
{
    if (!ModelClass || [NSStringFromClass(ModelClass) isEqualToString:NSStringFromClass([NSDictionary class])]) {
        return [appResponse.resultData mj_JSONObject];
    }
    else
    {
        return [ModelClass mj_objectWithKeyValues:appResponse.resultData];
    }
}

- (void)unifiedTreatmentAppError:(FyResponse *)appError{
    //统一处理
    NSLog(@"resultCode:%ld resultMessage:%@ resultData:%@",(long)appError.errorCode, appError.errorMessage, appError.resultData);
    if(appError.errorCode != RDP2PAppErrorTypeYYSuccess && appError.errorCode != NSURLErrorCancelled){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_AppErrorNotification object:nil userInfo:@{@"error":appError}];
    }
}

- (NSString *)validateMD5EncryptionBody:(NSString *)bodyStr{
    NSString *temStr = [NSString stringWithFormat:@"%@%@",self.key,bodyStr];
    return [FyNetworkManger md5WithString:temStr];
}

+ (NSString *)md5WithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}


@end
