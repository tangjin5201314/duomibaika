//
//  FyNetworkManger+fyAdd.m
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import "FyNetworkManger+fyAdd.h"
#import "FyUserCenter.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TmpBodyHeaderObject
@end


@implementation FyNetworkManger (fyAdd)

- (TmpBodyHeaderObject *)bodyHeardObjectWithRequsetModel:(FyBaseRequest *)requestModel{
    TmpBodyHeaderObject *object = [[TmpBodyHeaderObject alloc] init];
    NSMutableDictionary *mutableBodyParams = [@{} mutableCopy];
    NSMutableDictionary *mutableHeaderParams = [@{} mutableCopy];

    
    NSDictionary *orignBodyParams = [requestModel buildUrlParams]; //网络传参
    NSDictionary *orignHeaderParams = [requestModel headerParams];

    if (orignBodyParams) {
        [mutableBodyParams addEntriesFromDictionary:orignBodyParams];
    }
    
    if (orignHeaderParams) {
        [mutableHeaderParams addEntriesFromDictionary:mutableHeaderParams];
    }
    
    [self appendBodyParamsToTargetParams:mutableBodyParams];
    [self appendHeaderParamsToTargetParams:mutableBodyParams withBodyParams:orignBodyParams];
    
    object.bodyParams = [mutableBodyParams copy];
    object.headerParams = [mutableHeaderParams copy];
    return object;
}

//拼接公共请求信息
- (void)appendBodyParamsToTargetParams:(NSMutableDictionary *)targetParams{
    //版本号
//    if (![targetParams objectForKey:@"versionNumber"]) {
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        [targetParams setObject:app_Version forKey:@"versionNumber"];
//    }
//    //1是代表iOS
//    if (![targetParams objectForKey:@"mobileType"]) {
//        [targetParams setObject:@"1" forKey:@"mobileType"];
//    }
//    //添加用户信息
//    if ([FyUserCenter sharedInstance].isLogin) {
//        [targetParams setObject:[FyUserCenter sharedInstance].userId forKey:@"userId"];
//        [targetParams setObject:[FyUserCenter sharedInstance].oauthToken forKey:@"token"];
//    }

}

//拼接公共头信息
- (void)appendHeaderParamsToTargetParams:(NSMutableDictionary *)targetParams withBodyParams:(NSDictionary *)bodyParams{
    
    //添加用户信息
//    if ([FyUserCenter sharedInstance].isLogin) {
//        [targetParams setObject:[FyUserCenter sharedInstance].oauthToken forKey:@"token"];
//    }else{
//        [targetParams setObject:@"" forKey:@"token"];
//    }
    [targetParams setObject:[self returnSignatureWithParams:bodyParams] forKey:@"sign"];
}

- (NSString *)returnSignatureWithParams:(NSDictionary *)params {
    NSMutableString *mutabelString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@",self.key]];
    if (params[@"accessToken"]) {
        [mutabelString appendString:params[@"accessToken"]];
    }

    if (params[@"serviceData"]) {
        [mutabelString appendString:params[@"serviceData"]];
    }

    if (params[@"timeStamp"]) {
        [mutabelString appendString:params[@"timeStamp"]];
    }

    //MD5 结果
    NSLog(@"upload_ServiceData = %@",[params[@"serviceData"] mj_JSONObject]);
    mutabelString = [[FyNetworkManger md5WithString:mutabelString] mutableCopy];
    
    return [mutabelString uppercaseString];
}

//- (NSString *)returnSignature:(NSArray *)keySort arguments:(NSDictionary *)arguments
//{
//    NSMutableString *mutabelString = [[NSMutableString alloc] init];
//    for (NSString *key in keySort) {
//        [mutabelString appendFormat:@"%@=%@",key,arguments[key]];
//        [mutabelString appendString:@"|"];
//    }
//    //过滤最后一个|符号
//    NSString *temStr = @"";
//    if (mutabelString.length) {
//        temStr = [mutabelString substringToIndex:mutabelString.length-1];
//    }
//    return temStr;
//}

//md5加密
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
