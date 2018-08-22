//
//  FyBaseRequest.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyBaseRequest.h"
#import "NSString+Tools.h"

@implementation FyBaseRequest

- (NSDictionary *)buildUrlParams{
    NSMutableDictionary *params = [@{} mutableCopy];
    params[@"accessToken"] = @"";
    params[@"osType"] = @"ios";//平台信息
    params[@"timeStamp"] = [NSString currentDateTimeIntervalString];//日期字符串

    //用户访问令牌
    if ([FyUserCenter sharedInstance].accessToken.length>0) {
        params[@"accessToken"] = [FyUserCenter sharedInstance].accessToken;
    }

    if ([self params]) {
        params[@"serviceData"] = [[self params] mj_JSONString];//日期字符串
    }
    
    return [params copy];
}

- (NSString *)urlPath{
    NSAssert([self serviceCode], @"业务代码不能为空");
    
    if (self.files.count > 0) {
        return [NSString stringWithFormat:@"/api/upload/%@/%@", [self apiVersion], [self serviceCode]];
    }else{
        return [NSString stringWithFormat:@"/api/rest/%@/%@", [self apiVersion], [self serviceCode]];
    }
}

- (NSString *)apiVersion{  //api版本号
    return @"v1x0";
}

- (NSString *)mothod{
    return  @"POST";
}
- (NSDictionary *)params{
    return nil;
}
- (NSDictionary *)headerParams{
    return nil;
}
- (NSString *)serviceCode{
    return nil;
}
- (Class)objectClass{
    return nil;
}

- (NSArray<FyFileModel *> *)files{
    return nil;
}

- (BOOL)notifyIfError{
    return YES;
}

- (BOOL)isRunning{
    return self.task && self.task.state == NSURLSessionTaskStateRunning;
}

- (void)cancelCurrentTask{
    if ([self isRunning]) {
        [self.task cancel];
        self.task = nil;
    }
}



@end
