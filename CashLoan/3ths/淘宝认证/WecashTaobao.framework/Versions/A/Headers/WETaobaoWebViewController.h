//
//  WETaobaoWebViewController.h
//  Wecash
//
//  Created by 孙朋贞 on 15/9/11.
//  Copyright (c) 2015年 com.wecash. All rights reserved.
//

#import <UIKit/UIKit.h>

//请求淘宝授权后返回数据
@interface WEDataTransferObject : NSObject

@property(nonatomic, strong)NSString *tbusername;//淘宝名
@property(nonatomic, strong)NSString *taobaoID;//淘宝id
@property(nonatomic, assign)BOOL status;//爬虫状态

@end


//淘宝授权的代理方法
@protocol WecashTaobaoWebViewDelegate <NSObject>

-(void)authorizationSuccessWithResponse:(WEDataTransferObject *)transferObject;

@end

//淘宝授权界面
@interface WETaobaoWebViewController : UIViewController

/**
 *  WecashTaobaoWebView的代理
 */
@property(nonatomic,assign)id<WecashTaobaoWebViewDelegate> delegate;

/**
 *  初始化部分数据的方法
 *
 *  @param wecashKey  签名所用的key
 *  @param deviceId   设备号
 *  @param IPDetector 当前ip地址
 *  @param source     商户id
 *  @param customerId 用户在商户处的ID
 */
+ (void)authTaobaoWecashKey:(NSString *)wecashKey andDeviceId:(NSString *)deviceId andSource:(NSString *)source andCustomerId:(NSString *)customerId;

//获取淘宝SDK版本号
+ (NSString *)getTaobaoSDKVerson;

@end

