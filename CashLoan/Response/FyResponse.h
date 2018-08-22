//
//  FyResponse.h
//  CashLoan
//
//  Created by fyhy on 2017/10/11.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 错误状态值
 */
typedef NS_ENUM(NSInteger, RDP2PAppErrorTypeYY)
{
    /*
     返回数据不符合规范
     */
    RDP2PAppErrorTypeYYResponseModel = 0x0001,
    /*
     成功封装数据模型
     */
    RDP2PAppErrorTypeYYSuccess = 1000,
    //返回错误
    RDPAPPErrorTypeYMError = 2000,

    /*
     RefreshToken过期 - APP提示需要登录，跳转到登录页面
     */
    RDP2PAppErrorTypeLoginError = 6006, //用户登陆异常
    RDP2PAppErrorTypeLoginOtherClient = 6008, //其他设备上登录
    RDP2PAppErrorTypeRefreshTokenNoExist = 6012, //token不存在
    RDP2PAppErrorTypeIllegalLogin = 6013, //非法登录
    RDP2PAppErrorTypeTradePwdError = 6023, //交易密码错误
    RDP2PAppErrorTypeIllegalRequest = 6024, //非法请求
    RDP2PAppErrorTypeUserInfoNoExist = 6025, //用户基本信息不存在
    RDP2PAppErrorTypeUserVerificationFailed = 6027, //用户身份证信息验证失败
    RDP2PAppErrorTypeTokenNoExist = 6033, //token不存在
    RDP2PAppErrorTypeRefreshTokenTimeOut = 6035, //登录过期
    /*
        case 6006: // 用户登陆异常
        case 6008: // 账户在其他设备已登录
        case 6012: // refreshToken不存在
        case 6013: // 非法登陆
        case 6024: // 非法请求
        case 6025: // 用户基本信息不存在
        case 6027: // 用户身份证信息验证失败
        case 6033: // 用户token不存在
        case 6035: // 登陆已过期
     */
};


@interface FyResponse : NSObject

/**
 返回code保护成功或网络失败的code
 */
@property (nonatomic, assign) NSInteger errorCode;

/**
 返回成功信息或网络错误信息
 */
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, strong) id responseObject;

/**
 网络请求成功时返回的数据
 */
@property (nonatomic, strong) id errorData;

@property (nonatomic, strong) NSString *resultData;
@property (nonatomic, strong, readonly) id resData;

/**
 有些平台（现金贷） 页码数据与data 同一层级
 */
@property (nonatomic, strong) NSDictionary *pageData;

- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                responseData:(id)responseData;
- (instancetype)initWithCode:(NSInteger)code
                errorMessage:(NSString *)errorMessage
                     resData:(NSString *)resData pageData:(NSDictionary *)pageDic;


@end
