//
//  LZKNetworkingManager.h
//  testWeb
//
//  Created by 李哲楷 on 16/7/20.
//  Copyright © 2016年 李哲楷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^SuccessBlock)(BOOL success, id respondObject);
typedef void (^FailureBlock)(NSError *error);
typedef void (^SessionSuccessBlock)(id respondObject);

@interface LZKNetworkingManager : NSObject

+ (LZKNetworkingManager *)shareManager;

/**
 *  http的get请求
 *
 *  @param URLString url
 *  @param succeed   成功
 *  @param failure   失败
 */
- (void)GET:(NSString *)URLString success:(SuccessBlock)succeed failure:(FailureBlock)failure;


/**
 *  http的post请求
 *
 *  @param URLString  url
 *  @param parameters 参数
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)succeed failure:(FailureBlock)failure;

/**
 *  http的post请求
 *
 *  @param URLString  url
 *  @param parameters 正常参数
 *  @param imageDic   图片参数（key：(NSString)；value：(UIImage)）
 *  @param success    成功的回调
 *  @param failure    失败的回调
 */
- (void)ImagePOST:(NSString *)URLString parameters:(id)parameters imageDic:(NSDictionary *)imageDic success:(SuccessBlock)succeed failure:(FailureBlock)failure;
@end
