//
//  EventHanlder.h
//  SATEST
//
//  Created by 陈浩 on 2017/9/18.
//  Copyright © 2017年 富银宏远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const FYEventSendRegisterCode; //点击获取验证码
FOUNDATION_EXPORT NSString *const FYEventCommitRegister; //提交注册
FOUNDATION_EXPORT NSString *const FYEventFaceRecognition; //人脸识别
FOUNDATION_EXPORT NSString *const FYEventIDOCR; //身份证识别
FOUNDATION_EXPORT NSString *const FYEventApplyLoan; //申请借款
FOUNDATION_EXPORT NSString *const FYEventLoanVerify; //借款确认
FOUNDATION_EXPORT NSString *const FYEventCommitTradersPwd; //提交交易密码

// 数据接收的 URL
#define SA_SERVER_URL_TEST @"http://106.15.192.155:8006/sa?project=lmtest"
// 配置分发的 URL
#define SA_CONFIGURE_URL_TEST @"http://106.15.192.155:8006/config/?project=lmtest"
// Debug 模式选项
//   SensorsAnalyticsDebugOff - 关闭 Debug 模式
//   SensorsAnalyticsDebugOnly - 打开 Debug 模式，校验数据，但不进行数据导入
//   SensorsAnalyticsDebugAndTrack - 打开 Debug 模式，校验数据，并将数据导入到 Sensors Analytics 中
// 注意！请不要在正式发布的 App 中使用 Debug 模式！
#define SA_DEBUG_MODE_TEST SensorsAnalyticsDebugOff

#define SA_SERVER_URL @"http://106.15.192.155:8006/sa?project=lmproduction"
#define SA_CONFIGURE_URL @"http://106.15.192.155:8006/config/?project=lmproduction"
#define SA_DEBUG_MODE SensorsAnalyticsDebugOff


@interface NSString (toFloat)

- (CGFloat)toFloat;

@end

@interface EventHanlder : NSObject


+ (void)configSensorsAnalytics; //初始化sdk
+ (void)login:(NSString *)loginId;

//埋点方法
+ (void)trackSendRegisterCodeEvent;
+ (void)trackCommitRegisterEventWithSuccess:(BOOL)success;
+ (void)trackFaceRecognitionEventWithSuccess:(BOOL)success;
+ (void)trackIDOcrEventWithSuccess:(BOOL)success;
+ (void)trackApplyLoanEventWithProductName:(NSString *)productName amount:(CGFloat)amount dayLimit:(NSInteger)dayLimit;
+ (void)trackLoanVerifyEventWithProductName:(NSString *)productName amount:(CGFloat)amount dayLimit:(NSInteger)dayLimit fee:(CGFloat)fee auditFee:(CGFloat)auditFee accountManamageFee:(CGFloat)accountManamageFee realAmount:(CGFloat)realAmount;
+ (void)trackCommitTradersPwdEventWithSuccess:(BOOL)success;


@end
